# RULEBOOK - Python FastAPI Backend

## Project Overview

**Name:** Python FastAPI Backend
**Type:** Modern Python API Service
**Description:** High-performance async API with automatic documentation and type safety

**Key Features:**
- Async/await support
- Automatic API documentation (Swagger + ReDoc)
- Type hints & validation (Pydantic)
- Fast performance (comparable to Node.js/Go)
- SQL + NoSQL support
- Background tasks (Celery)
- WebSocket support

---

## Tech Stack

### Backend
- **Framework:** FastAPI 0.110+
- **Language:** Python 3.12+
- **ASGI Server:** Uvicorn
- **Database:** PostgreSQL 16
- **ORM:** SQLAlchemy 2.0 (async)
- **Migrations:** Alembic
- **Validation:** Pydantic V2
- **Testing:** Pytest + pytest-asyncio
- **Task Queue:** Celery + Redis

### Infrastructure
- **Hosting:** AWS (EC2, ECS, Lambda) or Render
- **Database:** AWS RDS or Railway
- **Cache:** Redis
- **Storage:** AWS S3
- **Monitoring:** Sentry + Prometheus
- **CI/CD:** GitHub Actions

---

## Folder Structure

```
src/
├── api/
│   ├── deps.py            # Dependencies (DB session, auth)
│   └── routes/            # API routes
│       ├── auth.py
│       ├── users.py
│       └── items.py
├── core/
│   ├── config.py          # Settings (Pydantic BaseSettings)
│   ├── security.py        # JWT, password hashing
│   └── database.py        # DB connection
├── models/                # SQLAlchemy models
│   ├── user.py
│   └── item.py
├── schemas/               # Pydantic schemas
│   ├── user.py
│   └── item.py
├── crud/                  # CRUD operations
│   ├── user.py
│   └── item.py
├── services/              # Business logic
│   └── email.py
├── utils/
│   └── helpers.py
├── tasks/                 # Celery tasks
│   └── email_tasks.py
└── main.py                # FastAPI app

alembic/                   # Database migrations
tests/
├── conftest.py           # Pytest fixtures
├── test_auth.py
└── test_users.py
```

---

## API Architecture

### FastAPI Application
```python
# main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from core.config import settings
from api.routes import auth, users, items

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

# Routes
app.include_router(auth.router, prefix=f"{settings.API_V1_STR}/auth", tags=["auth"])
app.include_router(users.router, prefix=f"{settings.API_V1_STR}/users", tags=["users"])
app.include_router(items.router, prefix=f"{settings.API_V1_STR}/items", tags=["items"])

@app.get("/")
async def root():
    return {"message": "API is running"}
```

### Route Structure
```python
# api/routes/users.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from api import deps
from crud import user as user_crud
from schemas.user import User, UserCreate, UserUpdate

router = APIRouter()

@router.get("/", response_model=list[User])
async def get_users(
    skip: int = 0,
    limit: int = 100,
    db: AsyncSession = Depends(deps.get_db)
):
    """Get all users"""
    users = await user_crud.get_multi(db, skip=skip, limit=limit)
    return users

@router.post("/", response_model=User, status_code=201)
async def create_user(
    user_in: UserCreate,
    db: AsyncSession = Depends(deps.get_db)
):
    """Create new user"""
    user = await user_crud.create(db, obj_in=user_in)
    return user

@router.get("/{user_id}", response_model=User)
async def get_user(
    user_id: int,
    db: AsyncSession = Depends(deps.get_db)
):
    """Get user by ID"""
    user = await user_crud.get(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
```

---

## Database (SQLAlchemy 2.0 Async)

### Model Definition
```python
# models/user.py
from sqlalchemy import String, Boolean
from sqlalchemy.orm import Mapped, mapped_column

from core.database import Base

class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    email: Mapped[str] = mapped_column(String, unique=True, index=True)
    hashed_password: Mapped[str] = mapped_column(String)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    is_superuser: Mapped[bool] = mapped_column(Boolean, default=False)
```

### CRUD Operations
```python
# crud/user.py
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from models.user import User
from schemas.user import UserCreate, UserUpdate
from core.security import get_password_hash

async def get(db: AsyncSession, id: int) -> User | None:
    result = await db.execute(select(User).where(User.id == id))
    return result.scalar_one_or_none()

async def get_multi(
    db: AsyncSession,
    skip: int = 0,
    limit: int = 100
) -> list[User]:
    result = await db.execute(select(User).offset(skip).limit(limit))
    return list(result.scalars().all())

async def create(db: AsyncSession, obj_in: UserCreate) -> User:
    db_obj = User(
        email=obj_in.email,
        hashed_password=get_password_hash(obj_in.password),
        is_active=obj_in.is_active
    )
    db.add(db_obj)
    await db.commit()
    await db.refresh(db_obj)
    return db_obj
```

---

## Pydantic Schemas

### Schema Definition
```python
# schemas/user.py
from pydantic import BaseModel, EmailStr, ConfigDict

class UserBase(BaseModel):
    email: EmailStr
    is_active: bool = True

class UserCreate(UserBase):
    password: str

class UserUpdate(UserBase):
    password: str | None = None

class User(UserBase):
    id: int
    is_superuser: bool

    model_config = ConfigDict(from_attributes=True)
```

---

## Authentication & Security

### JWT Implementation
```python
# core/security.py
from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext

from core.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def create_access_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)
```

### Dependencies
```python
# api/deps.py
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from sqlalchemy.ext.asyncio import AsyncSession

from core.config import settings
from core.database import async_session
from crud import user as user_crud

oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"{settings.API_V1_STR}/auth/login")

async def get_db() -> AsyncSession:
    async with async_session() as session:
        yield session

async def get_current_user(
    db: AsyncSession = Depends(get_db),
    token: str = Depends(oauth2_scheme)
):
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        user_id: int = payload.get("sub")
        if user_id is None:
            raise HTTPException(status_code=401, detail="Invalid authentication credentials")
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid authentication credentials")

    user = await user_crud.get(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
```

---

## Background Tasks (Celery)

### Celery Configuration
```python
# core/celery_app.py
from celery import Celery

from core.config import settings

celery_app = Celery(
    "worker",
    broker=settings.REDIS_URL,
    backend=settings.REDIS_URL
)

celery_app.conf.task_routes = {
    "tasks.email_tasks.*": "main-queue"
}
```

### Task Definition
```python
# tasks/email_tasks.py
from core.celery_app import celery_app
from services.email import send_email

@celery_app.task
def send_welcome_email(email: str, name: str):
    send_email(
        to=email,
        subject="Welcome!",
        body=f"Hello {name}, welcome to our platform!"
    )
```

---

## Configuration (Pydantic Settings)

```python
# core/config.py
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "FastAPI Project"
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"

    # Database
    DATABASE_URL: str

    # Security
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days

    # CORS
    ALLOWED_ORIGINS: list[str] = ["http://localhost:3000"]

    # Redis
    REDIS_URL: str = "redis://localhost:6379"

    # Email
    SMTP_HOST: str
    SMTP_PORT: int
    SMTP_USER: str
    SMTP_PASSWORD: str

    class Config:
        env_file = ".env"

settings = Settings()
```

---

## Testing

### Pytest Configuration
```python
# tests/conftest.py
import pytest
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker

from main import app
from core.database import Base
from api import deps

TEST_DATABASE_URL = "postgresql+asyncpg://test:test@localhost/test_db"

engine = create_async_engine(TEST_DATABASE_URL)
TestingSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

@pytest.fixture
async def db_session():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async with TestingSessionLocal() as session:
        yield session

    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)

@pytest.fixture
def override_get_db(db_session):
    async def _override_get_db():
        yield db_session
    app.dependency_overrides[deps.get_db] = _override_get_db
```

### API Tests
```python
# tests/test_users.py
import pytest
from httpx import AsyncClient

from main import app

@pytest.mark.asyncio
async def test_create_user(override_get_db):
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post(
            "/api/v1/users/",
            json={
                "email": "test@example.com",
                "password": "strongpassword",
                "is_active": True
            }
        )
    assert response.status_code == 201
    assert response.json()["email"] == "test@example.com"
```

---

## MCP Servers

### Mandatory: context7

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "context7-mcp"]
    }
  }
}
```

---

## Active Agents

### Core Agents (10)
- code-reviewer, refactoring-specialist, documentation-engineer
- test-strategist, architecture-advisor, security-auditor
- performance-optimizer, git-workflow-specialist, dependency-manager, project-analyzer

### Stack-Specific Agents (5)
- python-specialist
- postgres-expert
- rest-api-architect
- aws-cloud-specialist
- data-pipeline-specialist

**Total Active Agents:** 15

---

## Deployment

### Docker
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ ./src/
EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

**Template Version:** 1.0.0
**Last Updated:** 2026-01-07
