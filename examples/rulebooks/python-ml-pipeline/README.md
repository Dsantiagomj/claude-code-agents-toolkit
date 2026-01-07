# Python ML Pipeline Example

Real-world ML pipeline for fraud detection processing 1M+ transactions/day.

## Project Context

- **Scale:** 1M+ transactions/day
- **Latency:** < 100ms for predictions
- **Accuracy:** 95%+ required
- **Impact:** $2M+/year fraud prevention

## Pipeline Stages

1. **Data Ingestion:** Kafka streaming
2. **Feature Engineering:** Feast feature store
3. **Model Training:** Airflow orchestration, daily retraining
4. **Model Serving:** FastAPI REST API
5. **Monitoring:** Prometheus + DataDog

## What's Unique

- **Feature Store:** Feast for online/offline features
- **Model Registry:** MLflow for versioning
- **Automated Training:** Airflow DAG (daily)
- **Real-Time Inference:** < 100ms latency
- **Data Validation:** Great Expectations
- **Model Monitoring:** Track drift & performance

## Key Decisions

1. **XGBoost vs Neural Networks:** XGBoost (tabular data, interpretable)
2. **Feast vs Custom:** Feast (consistency, versioning)
3. **FastAPI vs Flask:** FastAPI (3x faster, async)

## Use This Example When

✅ Building ML pipelines
✅ Need feature store patterns
✅ Want model serving architecture
✅ Require real-time inference
✅ Need MLOps best practices

---

**Based on:** Real fraud detection ML system
**Last Updated:** 2026-01-07
