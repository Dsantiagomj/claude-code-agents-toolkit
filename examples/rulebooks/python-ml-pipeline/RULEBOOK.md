# RULEBOOK - ML Data Pipeline (Python)

## Project Overview

**Name:** PredictFlow ML Pipeline
**Type:** Machine Learning Data Pipeline & Model Serving
**Description:** End-to-end ML pipeline for fraud detection - data ingestion, feature engineering, model training, and real-time inference API

**Business Context:**
- Processes 1M+ transactions/day
- Real-time fraud detection (< 100ms latency)
- 95%+ accuracy required
- Team: 4 ML engineers, 2 backend engineers
- Saves company $2M+/year in fraud losses

**Pipeline Stages:**
1. **Data Ingestion** - Stream from Kafka
2. **Feature Engineering** - Transform raw data
3. **Model Training** - Automated retraining (daily)
4. **Model Serving** - REST API for predictions
5. **Monitoring** - Track model performance

---

## Tech Stack

### Core
- **Language:** Python 3.12+
- **API Framework:** FastAPI 0.110+
- **Task Queue:** Celery + Redis
- **Message Queue:** Apache Kafka (data ingestion)

### ML/Data
- **ML Framework:** scikit-learn, XGBoost
- **Feature Store:** Feast
- **Model Registry:** MLflow
- **Data Processing:** pandas, polars (faster)
- **Validation:** Pydantic V2, Great Expectations

### Infrastructure
- **Database:** PostgreSQL (metadata), Redis (cache)
- **Object Storage:** AWS S3 (models, datasets)
- **Compute:** AWS EC2 (training), Lambda (inference)
- **Orchestration:** Apache Airflow
- **Monitoring:** Prometheus + Grafana, DataDog

---

## Folder Structure

```
src/
├── api/
│   ├── main.py              # FastAPI app
│   └── routes/
│       ├── predict.py
│       └── health.py
├── pipeline/
│   ├── ingest.py            # Kafka consumer
│   ├── features.py          # Feature engineering
│   ├── train.py             # Model training
│   └── evaluate.py          # Model evaluation
├── models/
│   ├── fraud_detector.py
│   └── base.py
├── features/
│   ├── transaction.py
│   └── user.py
├── tasks/
│   ├── celery_app.py
│   └── training_tasks.py
└── utils/
    ├── metrics.py
    └── monitoring.py

dags/
└── train_pipeline.py        # Airflow DAG

tests/
├── unit/
├── integration/
└── model/                   # Model quality tests
```

---

## Data Ingestion (Kafka)

```python
# pipeline/ingest.py
from kafka import KafkaConsumer
import json

def consume_transactions():
    consumer = KafkaConsumer(
        'transactions',
        bootstrap_servers=['localhost:9092'],
        value_deserializer=lambda x: json.loads(x.decode('utf-8')),
        group_id='fraud-detection'
    )

    for message in consumer:
        transaction = message.value

        # Validate
        validated = TransactionSchema(**transaction)

        # Store raw data
        await store_raw_transaction(validated)

        # Trigger feature engineering
        await process_transaction.delay(validated.id)
```

---

## Feature Engineering

```python
# features/transaction.py
from feast import FeatureStore
import polars as pl

class TransactionFeatures:
    def __init__(self):
        self.store = FeatureStore(repo_path="feature_repo")

    def engineer_features(self, transaction_id: str) -> dict:
        # Get raw transaction
        tx = get_transaction(transaction_id)

        # Calculate features
        features = {
            # Transaction features
            'amount': tx.amount,
            'amount_log': np.log1p(tx.amount),
            'hour_of_day': tx.timestamp.hour,
            'day_of_week': tx.timestamp.dayofweek,

            # User aggregates (last 24h)
            'user_tx_count_24h': self.get_user_tx_count(tx.user_id, hours=24),
            'user_total_amount_24h': self.get_user_total_amount(tx.user_id, hours=24),

            # Merchant features
            'merchant_fraud_rate': self.get_merchant_fraud_rate(tx.merchant_id),

            # Velocity features
            'time_since_last_tx': self.time_since_last_tx(tx.user_id),

            # Device fingerprint
            'device_new': int(tx.device_id not in self.known_devices)
        }

        # Store to feature store
        self.store.write_to_online_store(
            feature_view_name="transaction_features",
            features=features
        )

        return features
```

---

## Model Training Pipeline

### Airflow DAG

```python
# dags/train_pipeline.py
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'ml-team',
    'depends_on_past': False,
    'start_date': datetime(2026, 1, 1),
    'retries': 2,
    'retry_delay': timedelta(minutes=5)
}

dag = DAG(
    'fraud_detection_training',
    default_args=default_args,
    schedule_interval='0 2 * * *',  # Daily at 2 AM
    catchup=False
)

extract_data = PythonOperator(
    task_id='extract_training_data',
    python_callable=extract_training_data,
    dag=dag
)

engineer_features = PythonOperator(
    task_id='engineer_features',
    python_callable=engineer_batch_features,
    dag=dag
)

train_model = PythonOperator(
    task_id='train_model',
    python_callable=train_fraud_model,
    dag=dag
)

evaluate_model = PythonOperator(
    task_id='evaluate_model',
    python_callable=evaluate_model,
    dag=dag
)

deploy_model = PythonOperator(
    task_id='deploy_model',
    python_callable=deploy_to_mlflow,
    dag=dag
)

extract_data >> engineer_features >> train_model >> evaluate_model >> deploy_model
```

### Training Script

```python
# pipeline/train.py
from xgboost import XGBClassifier
from sklearn.model_selection import train_test_split
import mlflow
import mlflow.xgboost

def train_fraud_model():
    # Load data
    df = load_training_data(days=30)

    # Train/test split
    X_train, X_test, y_train, y_test = train_test_split(
        df.drop('is_fraud', axis=1),
        df['is_fraud'],
        test_size=0.2,
        stratify=df['is_fraud']
    )

    # Handle class imbalance
    scale_pos_weight = len(y_train[y_train == 0]) / len(y_train[y_train == 1])

    # Train model
    model = XGBClassifier(
        n_estimators=100,
        max_depth=6,
        learning_rate=0.1,
        scale_pos_weight=scale_pos_weight
    )

    # MLflow tracking
    with mlflow.start_run():
        model.fit(X_train, y_train)

        # Evaluate
        y_pred = model.predict_proba(X_test)[:, 1]

        # Log metrics
        precision = precision_score(y_test, y_pred > 0.5)
        recall = recall_score(y_test, y_pred > 0.5)
        auc = roc_auc_score(y_test, y_pred)

        mlflow.log_metrics({
            'precision': precision,
            'recall': recall,
            'auc': auc
        })

        # Log model
        mlflow.xgboost.log_model(model, "model")

        # Promote to production if better than current
        if auc > get_production_model_auc():
            mlflow.register_model(
                f"runs:/{mlflow.active_run().info.run_id}/model",
                "fraud_detector"
            )
```

---

## Model Serving (FastAPI)

```python
# api/routes/predict.py
from fastapi import APIRouter, HTTPException
import mlflow
from pydantic import BaseModel

router = APIRouter()

# Load model on startup
model = mlflow.xgboost.load_model("models:/fraud_detector/production")

class PredictionRequest(BaseModel):
    transaction_id: str
    amount: float
    user_id: str
    merchant_id: str
    device_id: str

class PredictionResponse(BaseModel):
    transaction_id: str
    fraud_probability: float
    is_fraud: bool
    confidence: float

@router.post("/predict", response_model=PredictionResponse)
async def predict_fraud(request: PredictionRequest):
    # Get features
    features = engineer_features(request.dict())

    # Predict
    fraud_prob = model.predict_proba([list(features.values())])[0][1]

    # Apply threshold
    is_fraud = fraud_prob > 0.7  # Tune based on precision/recall tradeoff

    return PredictionResponse(
        transaction_id=request.transaction_id,
        fraud_probability=float(fraud_prob),
        is_fraud=bool(is_fraud),
        confidence=abs(fraud_prob - 0.5) * 2  # 0 to 1
    )
```

---

## Model Monitoring

### Prometheus Metrics

```python
# utils/monitoring.py
from prometheus_client import Counter, Histogram, Gauge

# Prediction metrics
predictions_total = Counter(
    'fraud_predictions_total',
    'Total number of fraud predictions',
    ['prediction']  # fraud or not_fraud
)

prediction_latency = Histogram(
    'fraud_prediction_latency_seconds',
    'Latency of fraud predictions'
)

model_confidence = Gauge(
    'fraud_model_confidence',
    'Average confidence of predictions'
)

# Model performance metrics
precision_metric = Gauge('fraud_model_precision', 'Model precision')
recall_metric = Gauge('fraud_model_recall', 'Model recall')
auc_metric = Gauge('fraud_model_auc', 'Model AUC')

# Data drift detection
feature_distribution_shift = Gauge(
    'feature_distribution_shift',
    'KL divergence from training distribution',
    ['feature']
)
```

---

## Data Validation

```python
# pipeline/validate.py
from great_expectations.dataset import PandasDataset

def validate_incoming_data(df: pd.DataFrame):
    ge_df = PandasDataset(df)

    # Schema validation
    assert ge_df.expect_column_values_to_be_of_type('amount', 'float')
    assert ge_df.expect_column_values_to_be_between('amount', 0, 1000000)

    # Distribution checks
    assert ge_df.expect_column_mean_to_be_between('amount', 50, 500)

    # Data quality
    assert ge_df.expect_column_values_to_not_be_null('user_id')

    # Get validation results
    results = ge_df.get_expectation_suite()

    if not results.success:
        alert_data_quality_team(results)
        raise DataValidationError("Data quality check failed")
```

---

## Active Agents

### Core (10)
- code-reviewer, refactoring-specialist, documentation-engineer
- test-strategist, architecture-advisor, security-auditor
- performance-optimizer, git-workflow-specialist, dependency-manager, project-analyzer

### Stack-Specific (5)
- python-specialist
- postgres-expert
- rest-api-architect
- aws-cloud-specialist
- data-pipeline-specialist

**Total Active Agents:** 15

---

## Key Decisions

### 1. XGBoost vs Neural Network
- **Chose:** XGBoost
- **Why:** Tabular data, interpretable, faster training
- **Tradeoff:** Neural nets might capture complex patterns (revisit later)

### 2. Feast vs Custom Feature Store
- **Chose:** Feast
- **Why:** Open source, offline + online store, versioning
- **Tradeoff:** Learning curve, but worth it for consistency

### 3. FastAPI vs Flask
- **Chose:** FastAPI
- **Why:** Async support, auto docs, Pydantic validation
- **Result:** 3x faster than Flask for inference

---

**Last Updated:** 2026-01-07
**Project Status:** Production (2 years)
**Team Size:** 6 engineers (4 ML, 2 backend)
**Impact:** $2M+/year fraud prevention
