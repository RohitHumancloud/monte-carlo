# Monte Carlo SaaS MVP - Project Roadmap
## 3-4 Week Implementation Plan

**Version:** 2.0 (SaaS MVP)
**Created:** December 31, 2025
**Last Updated:** December 31, 2025
**Purpose:** Detailed timeline and milestones for SaaS MVP implementation

**Team Size:** 2-3 developers (1 backend, 1 frontend, 1 full-stack)
**Timeline:** 3-4 weeks (120-160 hours total)
**Complexity:** High (requires full-stack + database + auth + deployment)

---

## 📋 Table of Contents

1. [Executive Summary](#executive-summary)
2. [Timeline Overview](#timeline-overview)
3. [Week-by-Week Breakdown](#week-by-week-breakdown)
4. [Milestones & Deliverables](#milestones--deliverables)
5. [Risk Assessment](#risk-assessment)
6. [Success Criteria](#success-criteria)
7. [Post-MVP Roadmap](#post-mvp-roadmap)

---

## Executive Summary

### Goals

**Primary Goal:** Build a complete SaaS platform for Monte Carlo simulation with self-service user dashboard

**SaaS MVP Features:**

**Frontend:**
- ✅ User signup page (email + password)
- ✅ User login page (JWT authentication)
- ✅ Dashboard UI (React + Tailwind CSS)
- ✅ API key management (generate, view, revoke)
- ✅ Usage tracking display

**Backend:**
- ✅ User registration/login endpoints
- ✅ JWT token generation and validation
- ✅ PostgreSQL database (users, api_keys, logs)
- ✅ API key generation/validation/revocation
- ✅ 30-day automatic key expiry
- ✅ Core Monte Carlo engine (Numba-optimized)
- ✅ Bloomberg data integration (xbbg)
- ✅ FastAPI REST API

**Deployment:**
- ✅ Docker containers (frontend + backend + database)
- ✅ docker-compose orchestration
- ✅ Database migrations (Alembic)

**NOT in MVP:**
- ❌ Billing/Stripe integration (Phase 2)
- ❌ Email verification (Phase 2)
- ❌ Password reset flow (Phase 2)
- ❌ Redis cache (Phase 2)
- ❌ Rate limiting (Phase 2)
- ❌ Kubernetes (Phase 2)

### Resource Requirements

```
Team:
  - 1 Backend Developer (Python + FastAPI + PostgreSQL)
  - 1 Frontend Developer (React + Tailwind CSS)
  - 1 Full-Stack/DevOps (docker-compose, testing, deployment)

Time:         3-4 weeks (120-160 hours total)

Hardware:
  - Development laptops (16GB+ RAM recommended)
  - PostgreSQL database server (can use Docker)

Software:
  - Python 3.11+
  - Node.js 18+
  - PostgreSQL 15
  - Docker + Docker Compose
  - Bloomberg Terminal (or Yahoo Finance for POC)

Budget:
  - $0 (all open source) + Bloomberg license (if available)
```

### Success Metrics

```
Performance:
- 10,000 simulations in < 5 seconds ✅
- API response time < 10 seconds ✅
- Dashboard loads in < 2 seconds ✅
- Database queries < 10ms ✅

Functionality:
- User can sign up ✅
- User can login ✅
- User can generate minimum 2 API keys ✅
- User can view API key usage ✅
- User can revoke API keys ✅
- API keys expire after 30 days ✅
- /api/v1/simulate endpoint works ✅
- All tests pass (backend + frontend) ✅

Quality:
- Code coverage > 70% ✅
- No critical bugs ✅
- Documentation complete ✅
- Responsive design (desktop + mobile) ✅
```

---

## Timeline Overview

### Visual Timeline (Week-by-Week)

```
Week 1: Backend Foundation (40 hours)
├─ Database Setup (PostgreSQL + Alembic)         │ 12 hours
├─ User Authentication (JWT + bcrypt)            │ 10 hours
├─ API Key Management (CRUD + validation)        │ 12 hours
└─ Basic API structure (FastAPI skeleton)        │ 6 hours

Week 2: Monte Carlo Engine + Bloomberg Integration (40 hours)
├─ Core simulation engine (NumPy + Numba)        │ 14 hours
├─ Bloomberg data integration (xbbg)             │ 10 hours
├─ Simulation API endpoint (/api/v1/simulate)    │ 8 hours
└─ Result formatting + validation                │ 8 hours

Week 3: Backend Testing + API Polish (40 hours)
├─ Comprehensive testing (unit + integration)    │ 12 hours
├─ API documentation (Swagger/OpenAPI)           │ 10 hours
├─ Security audit + rate limiting                │ 8 hours
└─ Load testing + performance optimization       │ 10 hours

Week 4: Frontend Development (40 hours)
├─ React project setup (Vite + Tailwind)         │ 6 hours
├─ Authentication pages (Login/Signup)           │ 12 hours
├─ Dashboard UI (API key management)             │ 14 hours
└─ Full integration + docker-compose             │ 8 hours

Total: 160 hours (4 weeks × 40 hours)
Fast-track option: 120 hours (3 weeks with 2-3 developers working in parallel)
```

### Progress Tracking

```
✅ = Completed
🔄 = In Progress
⏳ = Pending
❌ = Blocked

Week 1: ⏳ Backend Foundation
  ├─ Database Setup          ⏳
  ├─ User Authentication     ⏳
  ├─ API Key Management      ⏳
  └─ FastAPI Skeleton        ⏳

Week 2: ⏳ Monte Carlo Engine + Bloomberg
  ├─ Core Engine             ⏳
  ├─ Bloomberg Integration   ⏳
  ├─ Simulation API          ⏳
  └─ Result Formatting       ⏳

Week 3: ⏳ Backend Testing + API Polish
  ├─ Unit Testing            ⏳
  ├─ API Documentation       ⏳
  ├─ Security Audit          ⏳
  └─ Load Testing            ⏳

Week 4: ⏳ Frontend Development
  ├─ React Setup             ⏳
  ├─ Auth Pages              ⏳
  ├─ Dashboard UI            ⏳
  └─ Full Integration        ⏳
```

---

## Week-by-Week Breakdown

### Week 1: Backend Foundation (40 hours)

**Goal:** Build complete backend infrastructure with database, authentication, and API key management

**Team Assignment:** Backend Developer (full-time)

---

#### Day 1-2: Database Setup (12 hours)

**Task 1.1: PostgreSQL + Docker Setup (4 hours)**

```bash
# Create project structure
mkdir monte-carlo-saas
cd monte-carlo-saas

# Backend structure
mkdir -p backend/app/models backend/app/api backend/app/services backend/app/db
mkdir -p backend/tests backend/alembic/versions

# Create docker-compose.yml for PostgreSQL
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: monte_carlo_db
    environment:
      POSTGRES_USER: monte_user
      POSTGRES_PASSWORD: monte_pass
      POSTGRES_DB: monte_carlo_db
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF

# Start PostgreSQL
docker-compose up -d postgres

# Verify connection
docker exec -it monte_carlo_db psql -U monte_user -d monte_carlo_db -c "SELECT version();"
```

**✅ Checkpoint:** PostgreSQL running on port 5432

**Task 1.2: SQLAlchemy Models (4 hours)**

Create `backend/app/models/database.py`:

```python
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from datetime import datetime

Base = declarative_base()

# Database URL
DATABASE_URL = "postgresql+asyncpg://monte_user:monte_pass@localhost/monte_carlo_db"

# Async engine
engine = create_async_engine(DATABASE_URL, echo=True)
async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

# Dependency for FastAPI
async def get_db():
    async with async_session() as session:
        yield session
```

Create `backend/app/models/user.py`:

```python
from sqlalchemy import Column, BigInteger, String, DateTime, func
from .database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(BigInteger, primary_key=True, index=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    hashed_password = Column(String(255), nullable=False)
    full_name = Column(String(255))
    status = Column(String(50), default="active")  # active, suspended, deleted
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
```

Create `backend/app/models/api_key.py`:

```python
from sqlalchemy import Column, BigInteger, String, DateTime, ForeignKey, func
from sqlalchemy.orm import relationship
from .database import Base

class ApiKey(Base):
    __tablename__ = "api_keys"

    id = Column(BigInteger, primary_key=True, index=True)
    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    key = Column(String(255), unique=True, nullable=False, index=True)
    name = Column(String(100))
    status = Column(String(50), default="active")  # active, expired, revoked
    created_at = Column(DateTime, server_default=func.now())
    expires_at = Column(DateTime, nullable=False)
    last_used_at = Column(DateTime)

    # Relationship
    user = relationship("User", back_populates="api_keys")
```

**✅ Checkpoint:** Database models defined

**Task 1.3: Alembic Migrations (4 hours)**

```bash
# Install Alembic
pip install alembic asyncpg

# Initialize Alembic
cd backend
alembic init alembic

# Edit alembic/env.py to use async
# Edit alembic.ini to set sqlalchemy.url

# Create initial migration
alembic revision --autogenerate -m "Initial schema: users, api_keys, api_call_logs"

# Run migration
alembic upgrade head

# Verify tables
docker exec -it monte_carlo_db psql -U monte_user -d monte_carlo_db -c "\dt"
```

**✅ Checkpoint:** Database schema created with 3 tables

**📦 Deliverables Day 1-2:**
- ✅ PostgreSQL running in Docker
- ✅ 3 tables: users, api_keys, api_call_logs
- ✅ Alembic migrations working
- ✅ SQLAlchemy async models defined

---

#### Day 3-4: User Authentication (JWT) (10 hours)

**Task 2.1: Password Hashing with bcrypt (2 hours)**

Create `backend/app/services/auth.py`:

```python
from passlib.context import CryptContext
from jose import JWTError, jwt
from datetime import datetime, timedelta

# bcrypt with 12 rounds
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

SECRET_KEY = "your-secret-key-here-change-in-production"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_HOURS = 24

def hash_password(password: str) -> str:
    """Hash password with bcrypt (12 rounds)"""
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify password against hash"""
    return pwd_context.verify(plain_password, hashed_password)

def create_access_token(data: dict) -> str:
    """Create JWT token (24-hour expiry)"""
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(hours=ACCESS_TOKEN_EXPIRE_HOURS)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def decode_access_token(token: str) -> dict:
    """Decode and validate JWT token"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        return None
```

**Task 2.2: Signup API (3 hours)**

Create `backend/app/api/auth.py`:

```python
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from pydantic import BaseModel, EmailStr
from ..models.database import get_db
from ..models.user import User
from ..services.auth import hash_password, create_access_token

router = APIRouter(prefix="/auth", tags=["Authentication"])

class SignupRequest(BaseModel):
    email: EmailStr
    password: str  # Min 8 chars
    full_name: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"

@router.post("/signup", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
async def signup(request: SignupRequest, db: AsyncSession = Depends(get_db)):
    """User signup - creates new user account"""

    # Check if email already exists
    result = await db.execute(select(User).where(User.email == request.email))
    existing_user = result.scalar_one_or_none()

    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Validate password strength
    if len(request.password) < 8:
        raise HTTPException(status_code=400, detail="Password must be at least 8 characters")

    # Create new user
    new_user = User(
        email=request.email,
        hashed_password=hash_password(request.password),
        full_name=request.full_name,
        status="active"
    )

    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)

    # Generate JWT token
    access_token = create_access_token(data={"sub": str(new_user.id), "email": new_user.email})

    return {"access_token": access_token, "token_type": "bearer"}
```

**Task 2.3: Login API (3 hours)**

```python
class LoginRequest(BaseModel):
    email: EmailStr
    password: str

@router.post("/login", response_model=TokenResponse)
async def login(request: LoginRequest, db: AsyncSession = Depends(get_db)):
    """User login - returns JWT token"""

    # Find user by email
    result = await db.execute(select(User).where(User.email == request.email))
    user = result.scalar_one_or_none()

    if not user:
        raise HTTPException(status_code=401, detail="Invalid email or password")

    # Verify password
    if not verify_password(request.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid email or password")

    # Check user status
    if user.status != "active":
        raise HTTPException(status_code=403, detail="Account suspended")

    # Generate JWT token
    access_token = create_access_token(data={"sub": str(user.id), "email": user.email})

    return {"access_token": access_token, "token_type": "bearer"}
```

**Task 2.4: JWT Middleware (2 hours)**

```python
from fastapi import Header, HTTPException
from ..services.auth import decode_access_token

async def get_current_user(authorization: str = Header(None)):
    """Dependency to extract user from JWT token"""

    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing or invalid authorization header")

    token = authorization.split(" ")[1]
    payload = decode_access_token(token)

    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")

    return payload  # Returns {"sub": user_id, "email": email}
```

**✅ Checkpoint:** Users can signup, login, and receive JWT tokens

**📦 Deliverables Day 3-4:**
- ✅ Signup API (/auth/signup)
- ✅ Login API (/auth/login)
- ✅ JWT token generation (24-hour expiry)
- ✅ bcrypt password hashing (12 rounds)
- ✅ JWT middleware for protected routes

---

#### Day 5: API Key Management (12 hours)

**Task 3.1: API Key Generation (4 hours)**

Create `backend/app/services/api_key_generator.py`:

```python
import secrets
import string
from datetime import datetime, timedelta

def generate_api_key() -> str:
    """
    Generate API key: mk_live_[24 random characters]
    Format: mk_live_AbCdEfGh1234567890XyZ
    """
    chars = string.ascii_letters + string.digits  # Base62
    random_part = ''.join(secrets.choice(chars) for _ in range(24))
    return f"mk_live_{random_part}"

def calculate_expiry_date(days: int = 30) -> datetime:
    """Calculate expiry date (default 30 days)"""
    return datetime.utcnow() + timedelta(days=days)
```

**Task 3.2: API Key CRUD Endpoints (6 hours)**

Create `backend/app/api/api_keys.py`:

```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from pydantic import BaseModel
from typing import List
from datetime import datetime

from ..models.database import get_db
from ..models.api_key import ApiKey
from ..api.auth import get_current_user
from ..services.api_key_generator import generate_api_key, calculate_expiry_date

router = APIRouter(prefix="/api-keys", tags=["API Keys"])

class ApiKeyCreate(BaseModel):
    name: str  # e.g., "Production Key", "Development Key"

class ApiKeyResponse(BaseModel):
    id: int
    key: str  # Only shown once during creation
    name: str
    status: str
    created_at: datetime
    expires_at: datetime
    last_used_at: datetime | None

    class Config:
        from_attributes = True

@router.post("/", response_model=ApiKeyResponse, status_code=201)
async def create_api_key(
    request: ApiKeyCreate,
    current_user: dict = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Create new API key (30-day expiry)"""

    user_id = int(current_user["sub"])

    # Check if user already has 2+ active keys
    result = await db.execute(
        select(func.count(ApiKey.id)).where(
            ApiKey.user_id == user_id,
            ApiKey.status == "active"
        )
    )
    active_count = result.scalar()

    if active_count >= 10:  # Max 10 active keys
        raise HTTPException(status_code=400, detail="Maximum 10 active API keys allowed")

    # Generate unique key
    api_key = generate_api_key()

    # Create API key record
    new_key = ApiKey(
        user_id=user_id,
        key=api_key,
        name=request.name,
        status="active",
        expires_at=calculate_expiry_date(30)  # 30 days
    )

    db.add(new_key)
    await db.commit()
    await db.refresh(new_key)

    return new_key

@router.get("/", response_model=List[ApiKeyResponse])
async def list_api_keys(
    current_user: dict = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """List all API keys for current user"""

    user_id = int(current_user["sub"])

    result = await db.execute(
        select(ApiKey).where(ApiKey.user_id == user_id).order_by(ApiKey.created_at.desc())
    )
    keys = result.scalars().all()

    # Mask keys (except during creation)
    for key in keys:
        key.key = f"{key.key[:12]}...{key.key[-4:]}"  # mk_live_Ab...XyZ

    return keys

@router.delete("/{key_id}")
async def revoke_api_key(
    key_id: int,
    current_user: dict = Depends(get_current_user),
    db: AsyncSession = Depends(get_db)
):
    """Revoke (soft delete) an API key"""

    user_id = int(current_user["sub"])

    result = await db.execute(
        select(ApiKey).where(ApiKey.id == key_id, ApiKey.user_id == user_id)
    )
    api_key = result.scalar_one_or_none()

    if not api_key:
        raise HTTPException(status_code=404, detail="API key not found")

    # Soft delete
    api_key.status = "revoked"
    await db.commit()

    return {"message": "API key revoked successfully"}
```

**Task 3.3: API Key Validation Middleware (2 hours)**

Create `backend/app/api/middleware.py`:

```python
from fastapi import Header, HTTPException, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from datetime import datetime

from ..models.database import get_db
from ..models.api_key import ApiKey

async def validate_api_key(
    x_api_key: str = Header(None, alias="X-API-Key"),
    db: AsyncSession = Depends(get_db)
):
    """Middleware to validate API key from header"""

    if not x_api_key:
        raise HTTPException(status_code=401, detail="Missing X-API-Key header")

    # Find API key in database
    result = await db.execute(select(ApiKey).where(ApiKey.key == x_api_key))
    api_key = result.scalar_one_or_none()

    if not api_key:
        raise HTTPException(status_code=403, detail="Invalid API key")

    # Check status
    if api_key.status != "active":
        raise HTTPException(status_code=403, detail=f"API key is {api_key.status}")

    # Check expiry (30 days)
    if datetime.utcnow() > api_key.expires_at:
        api_key.status = "expired"
        await db.commit()
        raise HTTPException(status_code=403, detail="API key expired. Please generate a new key from your dashboard.")

    # Update last_used_at
    api_key.last_used_at = datetime.utcnow()
    await db.commit()

    return api_key  # Return for logging purposes
```

**✅ Checkpoint:** API key system fully functional

**📦 Deliverables Day 5:**
- ✅ API key generation (mk_live_XXXXXXXXXXXXXXXXXXXXXXXX)
- ✅ CRUD endpoints (create, list, revoke)
- ✅ API key validation middleware
- ✅ 30-day expiry enforcement
- ✅ Minimum 2 keys requirement implemented

---

**📦 Week 1 Final Deliverables:**
- ✅ PostgreSQL database with 3 tables
- ✅ User signup & login (JWT authentication)
- ✅ API key management system
- ✅ FastAPI skeleton with auth middleware
- ✅ Alembic migrations working
- ✅ All authentication endpoints tested
- ✅ Code coverage > 70% for auth module

---

### Week 2: Monte Carlo Engine + Bloomberg Integration (40 hours)

**Goal:** Build complete Monte Carlo simulation engine with Bloomberg data integration

**Team Assignment:** Backend Developer + Data Scientist

---

####  Day 1-2: Core Monte Carlo Engine (14 hours)

**Task 1.1: Geometric Brownian Motion with Numba (6 hours)**

Create `backend/app/services/monte_carlo.py`:

```python
import numpy as np
from numba import jit, prange
from typing import Dict
import time

@jit(nopython=True, parallel=True)
def simulate_gbm_paths(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    dt: float,
    num_paths: int,
    seed: int = 42
) -> np.ndarray:
    """
    Simulate stock price paths using Geometric Brownian Motion (Numba-optimized)

    Performance: 10,000 paths in ~2-3 seconds (10-100x faster than pure Python)

    Args:
        S0: Initial price
        mu: Expected return (annual)
        sigma: Volatility (annual)
        T: Time horizon (years)
        dt: Time step (1/252 for daily)
        num_paths: Number of simulation paths
        seed: Random seed for reproducibility

    Returns:
        Array of shape (num_paths, num_steps + 1) with simulated prices
    """
    np.random.seed(seed)
    num_steps = int(T / dt)
    paths = np.zeros((num_paths, num_steps + 1))
    paths[:, 0] = S0

    drift = (mu - 0.5 * sigma**2) * dt
    vol = sigma * np.sqrt(dt)

    for i in prange(num_paths):  # Parallel execution
        for t in range(1, num_steps + 1):
            Z = np.random.standard_normal()
            paths[i, t] = paths[i, t-1] * np.exp(drift + vol * Z)

    return paths
```

**✅ Checkpoint:** GBM simulation working (verified with unit tests)

**Task 1.2: Portfolio Simulation Logic (6 hours)**

```python
def calculate_portfolio_simulation(
    weights: np.ndarray,
    expected_returns: np.ndarray,
    cov_matrix: np.ndarray,
    initial_value: float,
    monthly_contribution: float,
    num_simulations: int,
    time_horizon_years: int,
    confidence_levels: list = [0.90, 0.95, 0.99]
) -> Dict:
    """
    Run Monte Carlo simulation for multi-asset portfolio

    Returns comprehensive risk metrics and simulation results
    """
    # Portfolio statistics
    portfolio_return = np.dot(weights, expected_returns)
    portfolio_volatility = np.sqrt(np.dot(weights.T, np.dot(cov_matrix, weights)))

    # Time parameters
    dt = 1/12  # Monthly steps
    num_steps = time_horizon_years * 12

    # Storage for final values
    final_values = np.zeros(num_simulations)
    sample_paths = []  # Store a few sample paths for visualization

    # Run simulations
    start_time = time.time()

    for sim in range(num_simulations):
        value = initial_value
        path = [value]

        for month in range(num_steps):
            # Monthly return (log-normal distribution)
            monthly_return = np.random.normal(
                portfolio_return / 12,
                portfolio_volatility / np.sqrt(12)
            )

            # Update portfolio value
            value = value * (1 + monthly_return) + monthly_contribution

            if sim < 5:  # Store first 5 paths for visualization
                path.append(value)

        final_values[sim] = value
        if sim < 5:
            sample_paths.append(path)

    execution_time = time.time() - start_time

    # Calculate comprehensive statistics
    mean_value = float(np.mean(final_values))
    median_value = float(np.median(final_values))
    std_deviation = float(np.std(final_values))

    # Percentiles
    percentiles = {
        'p5': float(np.percentile(final_values, 5)),
        'p10': float(np.percentile(final_values, 10)),
        'p25': float(np.percentile(final_values, 25)),
        'p50': float(np.percentile(final_values, 50)),
        'p75': float(np.percentile(final_values, 75)),
        'p90': float(np.percentile(final_values, 90)),
        'p95': float(np.percentile(final_values, 95)),
    }

    # Risk metrics
    var_95 = float(np.percentile(final_values, 5))  # Value at Risk (95% confidence)
    cvar_95 = float(np.mean(final_values[final_values <= var_95]))  # Conditional VaR

    # Sharpe Ratio (annualized)
    excess_return = portfolio_return - 0.02  # Assuming 2% risk-free rate
    sharpe_ratio = float(excess_return / portfolio_volatility) if portfolio_volatility > 0 else 0

    # Probabilities
    prob_loss = float(np.mean(final_values < initial_value))
    prob_doubling = float(np.mean(final_values >= initial_value * 2))

    return {
        'final_portfolio_value': {
            'mean': mean_value,
            'median': median_value,
            'std_deviation': std_deviation,
            'percentiles': percentiles
        },
        'risk_metrics': {
            'var_95': var_95,
            'cvar_95': cvar_95,
            'sharpe_ratio': sharpe_ratio,
            'portfolio_volatility': float(portfolio_volatility)
        },
        'probabilities': {
            'probability_of_loss': prob_loss,
            'probability_of_doubling': prob_doubling
        },
        'execution_time_seconds': execution_time,
        'sample_paths': sample_paths[:5]  # First 5 paths for visualization
    }
```

**Task 1.3: Unit Testing (2 hours)**

Create `backend/tests/test_monte_carlo.py`:

```python
import pytest
import numpy as np
from app.services.monte_carlo import simulate_gbm_paths, calculate_portfolio_simulation

def test_gbm_positive_prices():
    """GBM should always produce positive prices"""
    paths = simulate_gbm_paths(S0=100, mu=0.1, sigma=0.2, T=1, dt=1/252, num_paths=1000)
    assert np.all(paths > 0), "All GBM paths must have positive prices"

def test_gbm_initial_value():
    """All paths should start at S0"""
    S0 = 100
    paths = simulate_gbm_paths(S0=S0, mu=0.1, sigma=0.2, T=1, dt=1/252, num_paths=1000)
    assert np.allclose(paths[:, 0], S0), "All paths must start at S0"

def test_portfolio_simulation():
    """Portfolio simulation should return valid statistics"""
    weights = np.array([0.6, 0.4])
    returns = np.array([0.10, 0.05])
    cov = np.array([[0.04, 0.01], [0.01, 0.02]])

    results = calculate_portfolio_simulation(
        weights=weights,
        expected_returns=returns,
        cov_matrix=cov,
        initial_value=100000,
        monthly_contribution=1000,
        num_simulations=1000,
        time_horizon_years=5
    )

    assert 'final_portfolio_value' in results
    assert results['final_portfolio_value']['mean'] > 100000, "Portfolio should grow"
    assert results['execution_time_seconds'] < 30, "Should complete within 30 seconds"
```

**✅ Checkpoint:** Monte Carlo engine tested and performant

**📦 Deliverables Day 1-2:**
- ✅ GBM simulation (Numba-optimized, 10-100x faster)
- ✅ Portfolio simulation with risk metrics
- ✅ Unit tests (100% coverage for core engine)
- ✅ Performance: 10,000 paths in < 5 seconds

---

#### Day 3-4: Bloomberg Integration (10 hours)

**Task 2.1: Bloomberg Data Service (6 hours)**

Create `backend/app/services/bloomberg.py`:

```python
from xbbg import blp
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from typing import Dict, List

class BloombergDataService:
    """Service to fetch and process Bloomberg Terminal data"""

    def fetch_historical_data(
        self,
        tickers: List[str],
        years: int = 10
    ) -> Dict:
        """
        Fetch historical data and calculate statistics

        Args:
            tickers: List of Bloomberg tickers (e.g., ["NSEI Index", "GIND10YR Index"])
            years: Historical data period

        Returns:
            Dict with returns, volatility, correlation, covariance matrices
        """
        end_date = datetime.today()
        start_date = end_date - timedelta(days=365 * years)

        try:
            # Fetch total return index (includes dividends)
            data = blp.bdh(
                tickers=tickers,
                flds='TOT_RETURN_INDEX_GROSS_DVDS',
                start_date=start_date.strftime('%Y%m%d'),
                end_date=end_date.strftime('%Y%m%d'),
                adjust='all'  # Corporate actions adjustment
            )

            # Calculate log returns
            returns = np.log(data / data.shift(1)).dropna()

            # Annualize statistics (252 trading days)
            annual_returns = returns.mean() * 252
            annual_volatility = returns.std() * np.sqrt(252)
            correlation_matrix = returns.corr()
            covariance_matrix = returns.cov() * 252

            return {
                'returns': annual_returns.values,
                'volatility': annual_volatility.values,
                'correlation': correlation_matrix.values,
                'covariance': covariance_matrix.values,
                'tickers': tickers,
                'data_points': len(returns),
                'start_date': start_date.strftime('%Y-%m-%d'),
                'end_date': end_date.strftime('%Y-%m-%d')
            }

        except Exception as e:
            raise ValueError(f"Bloomberg data fetch failed: {str(e)}")

    def validate_tickers(self, tickers: List[str]) -> bool:
        """Validate that Bloomberg tickers exist and have data"""
        try:
            test = blp.bdp(tickers=tickers, flds='NAME')
            return len(test) == len(tickers)
        except:
            return False
```

**Task 2.2: Integration with Monte Carlo (2 hours)**

Update simulation flow to use Bloomberg data:

```python
# In app/api/simulation.py
from ..services.bloomberg import BloombergDataService
from ..services.monte_carlo import calculate_portfolio_simulation

bloomberg_service = BloombergDataService()

@router.post("/api/v1/simulate")
async def run_simulation(
    request: SimulationRequest,
    api_key: ApiKey = Depends(validate_api_key),
    db: AsyncSession = Depends(get_db)
):
    """Run Monte Carlo simulation with Bloomberg data"""

    # Extract tickers and weights
    tickers = [asset.ticker for asset in request.portfolio.assets]
    weights = np.array([asset.weight for asset in request.portfolio.assets])

    # Validate tickers
    if not bloomberg_service.validate_tickers(tickers):
        raise HTTPException(status_code=400, detail="Invalid Bloomberg tickers")

    # Fetch market data
    try:
        market_data = bloomberg_service.fetch_historical_data(tickers, years=10)
    except ValueError as e:
        raise HTTPException(status_code=500, detail=str(e))

    # Run Monte Carlo simulation
    results = calculate_portfolio_simulation(
        weights=weights,
        expected_returns=market_data['returns'],
        cov_matrix=market_data['covariance'],
        initial_value=request.parameters.initial_investment,
        monthly_contribution=request.parameters.monthly_contribution,
        num_simulations=request.parameters.num_simulations,
        time_horizon_years=request.parameters.time_horizon_years
    )

    # Log API call
    log_entry = ApiCallLog(
        api_key_id=api_key.id,
        endpoint="/api/v1/simulate",
        status_code=200,
        execution_time_seconds=results['execution_time_seconds']
    )
    db.add(log_entry)
    await db.commit()

    return {
        'simulation_id': f"sim_{uuid.uuid4().hex[:12]}",
        'status': 'completed',
        'created_at': datetime.utcnow().isoformat(),
        'execution_time_seconds': results['execution_time_seconds'],
        'results': results
    }
```

**Task 2.3: Testing Bloomberg Integration (2 hours)**

```python
# tests/test_bloomberg.py
def test_bloomberg_fetch():
    """Test fetching real data from Bloomberg"""
    service = BloombergDataService()
    data = service.fetch_historical_data(["NSEI Index"], years=1)

    assert 'returns' in data
    assert 'volatility' in data
    assert data['data_points'] > 200  # At least 200 trading days

def test_bloomberg_validation():
    """Test ticker validation"""
    service = BloombergDataService()
    assert service.validate_tickers(["NSEI Index"]) == True
    assert service.validate_tickers(["INVALID_TICKER_XYZ"]) == False
```

**✅ Checkpoint:** Bloomberg data integrated with Monte Carlo engine

**📦 Deliverables Day 3-4:**
- ✅ Bloomberg data service (production-ready)
- ✅ Ticker validation
- ✅ Integration with Monte Carlo engine
- ✅ API call logging
- ✅ Error handling for Bloomberg failures

---

#### Day 5: Simulation API Endpoint (8 hours)

**Task 3.1: Complete API Implementation (4 hours)**

Create `backend/app/api/simulation.py` with full request/response models:

```python
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field, validator
from typing import List
import numpy as np

router = APIRouter(prefix="/api/v1", tags=["Simulation"])

class Asset(BaseModel):
    ticker: str = Field(..., example="NSEI Index")
    weight: float = Field(..., ge=0, le=1, example=0.6)
    asset_class: str = Field(..., example="equity")

class Portfolio(BaseModel):
    assets: List[Asset]

    @validator('assets')
    def weights_sum_to_one(cls, v):
        total = sum(asset.weight for asset in v)
        if not 0.99 <= total <= 1.01:
            raise ValueError(f"Weights must sum to 1.0, got {total}")
        return v

class SimulationParameters(BaseModel):
    initial_investment: float = Field(..., gt=0, example=1000000)
    monthly_contribution: float = Field(default=0, ge=0, example=50000)
    time_horizon_years: int = Field(..., ge=1, le=50, example=10)
    num_simulations: int = Field(default=10000, ge=1000, le=100000)

class SimulationRequest(BaseModel):
    portfolio: Portfolio
    parameters: SimulationParameters

class SimulationResponse(BaseModel):
    simulation_id: str
    status: str
    created_at: str
    execution_time_seconds: float
    results: dict

# Implementation from Task 2.2 above
```

**Task 3.2: API Documentation (2 hours)**

FastAPI auto-generates Swagger docs at `/docs`. Add custom descriptions:

```python
@router.post(
    "/simulate",
    response_model=SimulationResponse,
    summary="Run Monte Carlo Simulation",
    description="""
    Runs a Monte Carlo simulation for portfolio analysis using Bloomberg market data.

    **Steps:**
    1. Validates API key (X-API-Key header)
    2. Fetches historical data from Bloomberg Terminal
    3. Runs Monte Carlo simulation (10,000 paths default)
    4. Returns comprehensive risk metrics

    **Performance:** Typical execution: 2-10 seconds depending on simulation count
    """
)
async def run_simulation(...):
    ...
```

**Task 3.3: Integration Testing (2 hours)**

Create `backend/tests/test_api_integration.py`:

```python
import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_full_simulation_flow():
    """Test complete simulation workflow"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        # 1. Signup user
        signup_response = await client.post("/auth/signup", json={
            "email": "test@example.com",
            "password": "testpass123",
            "full_name": "Test User"
        })
        assert signup_response.status_code == 201
        token = signup_response.json()["access_token"]

        # 2. Create API key
        key_response = await client.post(
            "/api-keys/",
            headers={"Authorization": f"Bearer {token}"},
            json={"name": "Test Key"}
        )
        assert key_response.status_code == 201
        api_key = key_response.json()["key"]

        # 3. Run simulation
        sim_response = await client.post(
            "/api/v1/simulate",
            headers={"X-API-Key": api_key},
            json={
                "portfolio": {
                    "assets": [
                        {"ticker": "NSEI Index", "weight": 0.6, "asset_class": "equity"},
                        {"ticker": "GIND10YR Index", "weight": 0.4, "asset_class": "bonds"}
                    ]
                },
                "parameters": {
                    "initial_investment": 1000000,
                    "monthly_contribution": 50000,
                    "time_horizon_years": 10,
                    "num_simulations": 1000
                }
            }
        )

        assert sim_response.status_code == 200
        result = sim_response.json()
        assert 'results' in result
        assert result['results']['final_portfolio_value']['mean'] > 1000000
```

**✅ Checkpoint:** Full API tested end-to-end

**📦 Week 3 Final Deliverables:**
- ✅ Monte Carlo engine (Numba-optimized, production-ready)
- ✅ Bloomberg integration (validated)
- ✅ /api/v1/simulate endpoint (fully functional)
- ✅ Comprehensive API documentation
- ✅ Integration tests passing
- ✅ Performance: < 10 seconds for 10,000 simulations

---

### Week 3: Backend Testing + API Polish (40 hours)

**Goal:** Production-ready backend with comprehensive testing and API documentation

**Team Assignment:** Backend Developer + QA Engineer

**Prerequisites:** Week 1 & 2 completed (Backend + Monte Carlo engine functional)

---

#### Day 1-2: Comprehensive Backend Testing (12 hours)

**Task 1.1: Unit Test Suite (6 hours)**

```bash
# Run all tests with coverage
cd backend
pytest --cov=app --cov-report=html --cov-report=term-missing

# Target: > 80% code coverage
```

Test modules:
- `tests/test_monte_carlo.py` - Core engine tests
- `tests/test_bloomberg.py` - Bloomberg service tests
- `tests/test_auth.py` - Authentication tests (signup, login, JWT)
- `tests/test_api_keys.py` - API key management tests (CRUD, expiry)
- `tests/test_simulation_api.py` - Simulation endpoint tests

**Task 1.2: Integration Testing (4 hours)**

Test complete user journeys:
1. User signup → Login → Create API key → Run simulation → Success
2. API key expiry flow (simulate 30-day expiry) → Error handling
3. Invalid ticker validation → Bloomberg error handling
4. Concurrent simulation requests → Performance validation

**Task 1.3: Performance Testing (2 hours)**

```python
# tests/test_performance.py
import time
import asyncio

async def test_concurrent_simulations():
    """Test 10 concurrent simulation requests"""
    start = time.time()

    tasks = []
    for i in range(10):
        task = asyncio.create_task(run_simulation(...))
        tasks.append(task)

    results = await asyncio.gather(*tasks)

    elapsed = time.time() - start
    assert elapsed < 60, "10 concurrent simulations should complete in < 60 seconds"
    assert all(r['status'] == 'completed' for r in results)

def test_large_simulation():
    """Test 100,000 path simulation"""
    start = time.time()
    result = run_simulation(num_simulations=100000)
    elapsed = time.time() - start

    assert elapsed < 120, "100K simulation should complete in < 2 minutes"
    assert result['status'] == 'completed'
```

**✅ Checkpoint:** All backend tests passing (>80% coverage)

**📦 Deliverables Day 1-2:**
- ✅ Backend unit tests: >80% code coverage
- ✅ Integration tests: All user flows working
- ✅ Performance tests: Benchmarks met
- ✅ No critical bugs

---

#### Day 3: API Documentation & Docker (10 hours)

**Task 2.1: Swagger/OpenAPI Documentation (4 hours)**

Enhance FastAPI auto-generated docs at `/docs`:

```python
# Add detailed descriptions to all endpoints
app = FastAPI(
    title="Monte Carlo Simulation API",
    description="""
    **Production-ready API for portfolio Monte Carlo simulations.**

    ## Authentication
    - Dashboard: JWT tokens (24-hour expiry)
    - API: API keys (30-day expiry) via X-API-Key header

    ## Key Features
    - Bloomberg Terminal data integration
    - Numba-optimized simulations (10,000 paths in <5 seconds)
    - Comprehensive risk metrics (VaR, CVaR, Sharpe Ratio)

    ## Rate Limits
    - 100 requests per hour per API key
    - 1,000 simulations maximum per request
    """,
    version="1.0.0",
    contact={
        "name": "API Support",
        "email": "support@montecarlo.example.com"
    }
)
```

**Task 2.2: Backend Docker Container (4 hours)**

Create `backend/Dockerfile`:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY app/ ./app/
COPY alembic/ ./alembic/
COPY alembic.ini .

# Expose port
EXPOSE 8000

# Run migrations and start server
CMD alembic upgrade head && uvicorn app.main:app --host 0.0.0.0 --port 8000
```

**Task 2.3: Test Backend Deployment (2 hours)**

```bash
# Build Docker image
docker build -t monte-carlo-backend:v1.0 ./backend

# Run with docker-compose (backend + postgres only)
docker-compose up -d postgres backend

# Verify
curl http://localhost:8000/health
curl http://localhost:8000/docs  # Swagger UI
```

**✅ Checkpoint:** Backend API fully documented and containerized

**📦 Deliverables Day 3:**
- ✅ Complete Swagger/OpenAPI documentation
- ✅ Backend Dockerfile (production-ready)
- ✅ Backend runs in Docker container
- ✅ API testable via Swagger UI

---

#### Day 4-5: API Refinement & Security Audit (10 hours)

**Task 3.1: Error Handling & Validation (4 hours)**

Improve error messages and validation:

```python
# Enhanced error responses
@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": exc.detail,
            "status_code": exc.status_code,
            "timestamp": datetime.utcnow().isoformat(),
            "path": str(request.url)
        }
    )

# Improved validation messages
class SimulationRequest(BaseModel):
    portfolio: Portfolio = Field(
        ...,
        description="Portfolio composition with weights summing to 1.0"
    )
    parameters: SimulationParameters = Field(
        ...,
        description="Simulation parameters (investment, horizon, count)"
    )

    class Config:
        schema_extra = {
            "example": {
                "portfolio": {
                    "assets": [
                        {"ticker": "NSEI Index", "weight": 0.6, "asset_class": "equity"},
                        {"ticker": "GIND10YR Index", "weight": 0.4, "asset_class": "bonds"}
                    ]
                },
                "parameters": {
                    "initial_investment": 1000000,
                    "monthly_contribution": 50000,
                    "time_horizon_years": 10,
                    "num_simulations": 10000
                }
            }
        }
```

**Task 3.2: Security Audit (4 hours)**

Security checklist:
- ✅ SQL injection prevention (SQLAlchemy ORM - parameterized queries)
- ✅ Password hashing (bcrypt, 12 rounds)
- ✅ JWT secret key (stored in .env, rotated regularly)
- ✅ API key validation (database lookup, status + expiry check)
- ✅ Input validation (Pydantic models with constraints)
- ✅ CORS configuration (restrict origins in production)
- ✅ Rate limiting (implement with slowapi)
- ✅ HTTPS enforcement (production deployment)

Add rate limiting:

```python
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

@app.post("/api/v1/simulate")
@limiter.limit("100/hour")  # 100 requests per hour per IP
async def run_simulation(...):
    ...
```

**Task 3.3: Load Testing (2 hours)**

```bash
# Install locust for load testing
pip install locust

# Create loadtest.py
# Simulate 100 concurrent users making requests

locust -f loadtest.py --host=http://localhost:8000 --users 100 --spawn-rate 10
```

Target metrics:
- 95th percentile response time: < 10 seconds
- Error rate: < 1%
- Throughput: > 10 requests/second

**✅ Checkpoint:** Backend API hardened and load-tested

**📦 Week 3 Final Deliverables:**
- ✅ Backend: >80% test coverage
- ✅ All integration tests passing
- ✅ Complete Swagger documentation
- ✅ Docker container production-ready
- ✅ Security audit passed
- ✅ Rate limiting implemented
- ✅ Load testing benchmarks met
- ✅ **Backend API ready for frontend integration**

---

### Week 4: Frontend Development (40 hours)

**Goal:** Build complete React dashboard for self-service user experience

**Team Assignment:** Frontend Developer (full-time)

**Prerequisites:** Week 1-3 completed (Backend API fully functional and tested)

---

#### Day 1-2: React Setup + Authentication Pages (12 hours)

**Task 1.1: React Project Setup (4 hours)**

```bash
# Create React app with Vite
cd monte-carlo-saas
npm create vite@latest frontend -- --template react
cd frontend

# Install dependencies
npm install react-router-dom axios
npm install -D tailwindcss postcss autoprefixer
npm install lucide-react  # Icons

# Initialize Tailwind CSS
npx tailwindcss init -p

# Update tailwind.config.js
cat > tailwind.config.js << 'EOF'
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        primary: '#3B82F6',
        secondary: '#10B981',
      }
    },
  },
  plugins: [],
}
EOF

# Add Tailwind to index.css
cat > src/index.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# Start dev server
npm run dev
```

**✅ Checkpoint:** React app running on http://localhost:5173

**Task 1.2: Routing Setup (2 hours)**

Create `frontend/src/App.jsx`:

```jsx
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import Login from './pages/Login'
import Signup from './pages/Signup'
import Dashboard from './pages/Dashboard'
import PrivateRoute from './components/PrivateRoute'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
        <Route
          path="/dashboard"
          element={
            <PrivateRoute>
              <Dashboard />
            </PrivateRoute>
          }
        />
        <Route path="/" element={<Navigate to="/dashboard" replace />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
```

**Task 1.3: Login Page (3 hours)**

Create `frontend/src/pages/Login.jsx`:

```jsx
import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import axios from 'axios'

export default function Login() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const response = await axios.post('http://localhost:8000/auth/login', {
        email,
        password
      })

      // Store JWT token
      localStorage.setItem('access_token', response.data.access_token)

      // Redirect to dashboard
      navigate('/dashboard')
    } catch (err) {
      setError(err.response?.data?.detail || 'Login failed')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg shadow-xl p-8 w-full max-w-md">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Welcome Back</h1>
        <p className="text-gray-600 mb-6">Sign in to your Monte Carlo account</p>

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-4">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Email
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="you@example.com"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Password
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="••••••••"
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded-lg transition disabled:opacity-50"
          >
            {loading ? 'Signing in...' : 'Sign In'}
          </button>
        </form>

        <p className="mt-6 text-center text-sm text-gray-600">
          Don't have an account?{' '}
          <Link to="/signup" className="text-blue-600 hover:text-blue-700 font-semibold">
            Sign up
          </Link>
        </p>
      </div>
    </div>
  )
}
```

**Task 1.4: Signup Page (3 hours)**

Create `frontend/src/pages/Signup.jsx`:

```jsx
import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import axios from 'axios'

export default function Signup() {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    full_name: ''
  })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')

    // Validation
    if (formData.password.length < 8) {
      setError('Password must be at least 8 characters')
      return
    }

    setLoading(true)

    try {
      const response = await axios.post('http://localhost:8000/auth/signup', formData)

      // Store JWT token
      localStorage.setItem('access_token', response.data.access_token)

      // Redirect to dashboard
      navigate('/dashboard')
    } catch (err) {
      setError(err.response?.data?.detail || 'Signup failed')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg shadow-xl p-8 w-full max-w-md">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Create Account</h1>
        <p className="text-gray-600 mb-6">Start your 30-day free trial</p>

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-4">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
            <input
              type="text"
              name="full_name"
              value={formData.full_name}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input
              type="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              required
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Password</label>
            <input
              type="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              required
              minLength={8}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <p className="text-xs text-gray-500 mt-1">Minimum 8 characters</p>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded-lg transition disabled:opacity-50"
          >
            {loading ? 'Creating account...' : 'Create Account'}
          </button>
        </form>

        <p className="mt-6 text-center text-sm text-gray-600">
          Already have an account?{' '}
          <Link to="/login" className="text-blue-600 hover:text-blue-700 font-semibold">
            Sign in
          </Link>
        </p>
      </div>
    </div>
  )
}
```

**✅ Checkpoint:** Users can sign up and log in

**📦 Deliverables Day 1-2:**
- ✅ React + Vite setup with Tailwind CSS
- ✅ React Router configured
- ✅ Login page (working)
- ✅ Signup page (working)
- ✅ JWT token storage in localStorage
- ✅ Responsive design (mobile + desktop)

---

#### Day 3-4: Dashboard UI + API Key Management (14 hours)

**Task 2.1: Protected Route Component (2 hours)**

Create `frontend/src/components/PrivateRoute.jsx`:

```jsx
import { Navigate } from 'react-router-dom'

export default function PrivateRoute({ children }) {
  const token = localStorage.getItem('access_token')

  if (!token) {
    return <Navigate to="/login" replace />
  }

  return children
}
```

**Task 2.2: Dashboard Layout (4 hours)**

Create `frontend/src/pages/Dashboard.jsx`:

```jsx
import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { Key, Plus, Trash2, Copy, AlertCircle } from 'lucide-react'
import axios from 'axios'

export default function Dashboard() {
  const [apiKeys, setApiKeys] = useState([])
  const [loading, setLoading] = useState(true)
  const [newKeyName, setNewKeyName] = useState('')
  const [showCreateForm, setShowCreateForm] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const navigate = useNavigate()

  const axiosInstance = axios.create({
    baseURL: 'http://localhost:8000',
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('access_token')}`
    }
  })

  useEffect(() => {
    fetchApiKeys()
  }, [])

  const fetchApiKeys = async () => {
    try {
      const response = await axiosInstance.get('/api-keys/')
      setApiKeys(response.data)
    } catch (err) {
      if (err.response?.status === 401) {
        localStorage.removeItem('access_token')
        navigate('/login')
      } else {
        setError('Failed to load API keys')
      }
    } finally {
      setLoading(false)
    }
  }

  const createApiKey = async () => {
    if (!newKeyName.trim()) {
      setError('Please enter a key name')
      return
    }

    try {
      const response = await axiosInstance.post('/api-keys/', { name: newKeyName })
      setApiKeys([response.data, ...apiKeys])
      setNewKeyName('')
      setShowCreateForm(false)
      setSuccess(`API key "${response.data.name}" created successfully`)
      setTimeout(() => setSuccess(''), 5000)
    } catch (err) {
      setError(err.response?.data?.detail || 'Failed to create API key')
    }
  }

  const revokeApiKey = async (keyId) => {
    if (!confirm('Are you sure you want to revoke this API key?')) return

    try {
      await axiosInstance.delete(`/api-keys/${keyId}`)
      setApiKeys(apiKeys.filter(k => k.id !== keyId))
      setSuccess('API key revoked successfully')
      setTimeout(() => setSuccess(''), 5000)
    } catch (err) {
      setError('Failed to revoke API key')
    }
  }

  const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text)
    setSuccess('Copied to clipboard!')
    setTimeout(() => setSuccess(''), 2000)
  }

  const handleLogout = () => {
    localStorage.removeItem('access_token')
    navigate('/login')
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
          <div className="flex items-center">
            <Key className="h-8 w-8 text-blue-600 mr-2" />
            <h1 className="text-2xl font-bold text-gray-900">Monte Carlo API</h1>
          </div>
          <button
            onClick={handleLogout}
            className="text-gray-600 hover:text-gray-900 font-medium"
          >
            Logout
          </button>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Alerts */}
        {error && (
          <div className="mb-4 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg flex items-center">
            <AlertCircle className="h-5 w-5 mr-2" />
            {error}
          </div>
        )}

        {success && (
          <div className="mb-4 bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg">
            {success}
          </div>
        )}

        {/* API Keys Section */}
        <div className="bg-white rounded-lg shadow">
          <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
            <h2 className="text-xl font-semibold text-gray-900">API Keys</h2>
            <button
              onClick={() => setShowCreateForm(!showCreateForm)}
              className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg flex items-center"
            >
              <Plus className="h-5 w-5 mr-1" />
              Create Key
            </button>
          </div>

          {/* Create Form */}
          {showCreateForm && (
            <div className="px-6 py-4 bg-gray-50 border-b border-gray-200">
              <div className="flex gap-2">
                <input
                  type="text"
                  value={newKeyName}
                  onChange={(e) => setNewKeyName(e.target.value)}
                  placeholder="Key name (e.g., Production Key)"
                  className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
                <button
                  onClick={createApiKey}
                  className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg"
                >
                  Create
                </button>
                <button
                  onClick={() => setShowCreateForm(false)}
                  className="bg-gray-300 hover:bg-gray-400 text-gray-700 px-4 py-2 rounded-lg"
                >
                  Cancel
                </button>
              </div>
            </div>
          )}

          {/* Keys List */}
          <div className="divide-y divide-gray-200">
            {loading ? (
              <div className="px-6 py-8 text-center text-gray-500">Loading...</div>
            ) : apiKeys.length === 0 ? (
              <div className="px-6 py-8 text-center text-gray-500">
                No API keys yet. Create your first key to get started.
              </div>
            ) : (
              apiKeys.map((key) => (
                <div key={key.id} className="px-6 py-4 hover:bg-gray-50">
                  <div className="flex justify-between items-start">
                    <div className="flex-1">
                      <h3 className="font-semibold text-gray-900">{key.name}</h3>
                      <div className="flex items-center mt-2 space-x-2">
                        <code className="bg-gray-100 px-3 py-1 rounded text-sm font-mono">
                          {key.key}
                        </code>
                        <button
                          onClick={() => copyToClipboard(key.key)}
                          className="text-blue-600 hover:text-blue-700"
                        >
                          <Copy className="h-4 w-4" />
                        </button>
                      </div>
                      <div className="mt-2 text-sm text-gray-600">
                        <span className={`inline-flex px-2 py-1 rounded text-xs font-semibold ${
                          key.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                        }`}>
                          {key.status}
                        </span>
                        <span className="ml-4">
                          Expires: {new Date(key.expires_at).toLocaleDateString()}
                        </span>
                      </div>
                    </div>
                    <button
                      onClick={() => revokeApiKey(key.id)}
                      className="text-red-600 hover:text-red-700 ml-4"
                    >
                      <Trash2 className="h-5 w-5" />
                    </button>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Documentation Link */}
        <div className="mt-6 bg-blue-50 border border-blue-200 rounded-lg px-6 py-4">
          <h3 className="font-semibold text-blue-900 mb-2">Getting Started</h3>
          <p className="text-blue-800 text-sm">
            Use your API key to make requests to the Monte Carlo simulation endpoint:
          </p>
          <pre className="mt-2 bg-white p-3 rounded text-xs overflow-x-auto">
{`curl -X POST https://api.montecarlo.example.com/api/v1/simulate \\
  -H "X-API-Key: your_api_key_here" \\
  -H "Content-Type: application/json" \\
  -d '{"portfolio": {...}}'`}
          </pre>
        </div>
      </main>
    </div>
  )
}
```

**✅ Checkpoint:** Dashboard fully functional with API key management

**Task 2.3: API Integration & Error Handling (4 hours)**

Create `frontend/src/services/api.js`:

```javascript
import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000'

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Add auth token to requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('access_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Handle 401 errors (redirect to login)
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('access_token')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export default api
```

**Task 2.4: Testing & Refinement (4 hours)**

- Test signup/login flow
- Test API key creation (minimum 2 keys)
- Test API key revocation
- Test token expiry handling
- Responsive design testing (mobile, tablet, desktop)
- Error message improvements
- Loading states refinement

**✅ Checkpoint:** All frontend features working end-to-end

**📦 Deliverables Day 3-4:**
- ✅ Dashboard UI (complete)
- ✅ API key CRUD operations (working)
- ✅ Copy to clipboard functionality
- ✅ Protected routes (JWT validation)
- ✅ Error handling & user feedback
- ✅ Responsive design (tested on all devices)
- ✅ axios interceptors for auth

---

**📦 Week 4 Final Deliverables:**
- ✅ Complete React dashboard (production-ready)
- ✅ Login & signup pages (fully functional)
- ✅ API key management UI (create, list, revoke)
- ✅ JWT authentication flow (working)
- ✅ Responsive design (mobile-first)
- ✅ Error handling & validation
- ✅ Frontend integrated with backend API
- ✅ docker-compose with all 3 services (postgres, backend, frontend)
- ✅ **COMPLETE SAAS MVP READY FOR DEPLOYMENT**

---

## Milestones & Deliverables

### Milestone 1: Environment Setup (End of Day 1)
```
✅ Python 3.11+ environment
✅ All dependencies installed
✅ Project structure created
✅ Git initialized
✅ Pydantic models defined
```

### Milestone 2: Core Engine (End of Day 2)
```
✅ GBM simulation working
✅ Portfolio simulation working
✅ Numba optimization enabled
✅ Unit tests passing (100% coverage)
✅ Performance: 10,000 paths in < 5 seconds
```

### Milestone 3: API Development (End of Day 3)
```
✅ Bloomberg data service working
✅ FastAPI application running
✅ API key authentication working
✅ /health endpoint
✅ /api/v1/simulate endpoint
✅ Auto-generated API docs
```

### Milestone 4: Testing & Docker (End of Day 4)
```
✅ Integration tests passing
✅ Test coverage > 80%
✅ Docker image built
✅ Docker container running
✅ README documentation
```

### Milestone 5: MVP Complete (End of Day 5)
```
✅ E2E tests passing
✅ Performance targets met
✅ All bugs fixed
✅ Documentation complete
✅ Demo ready
✅ MVP ready for production
```

---

## Risk Assessment

### High Risk Items

#### 1. Bloomberg Terminal Access
**Risk:** Bloomberg Terminal not available or connection issues
**Impact:** HIGH
**Mitigation:**
- Use Yahoo Finance as alternative (yfinance library)
- Test Bloomberg connection on Day 1
- Have fallback data source ready

#### 2. Numba Performance
**Risk:** Numba not achieving expected speedup
**Impact:** MEDIUM
**Mitigation:**
- Test Numba compilation on Day 2 morning
- If issues, use pure NumPy (slower but works)
- Reduce num_simulations to 5,000 instead of 10,000

#### 3. Docker Build Issues
**Risk:** Docker image fails to build or is too large
**Impact:** LOW
**Mitigation:**
- Use python:3.11-slim base image
- Multi-stage build if needed
- Test Docker build on Day 4 morning

### Medium Risk Items

#### 4. Test Coverage
**Risk:** Difficulty achieving 80% test coverage
**Impact:** MEDIUM
**Mitigation:**
- Write tests alongside code (not at end)
- Focus on critical paths first
- Use pytest-cov to track coverage

#### 5. API Response Time
**Risk:** API taking > 10 seconds to respond
**Impact:** MEDIUM
**Mitigation:**
- Profile code to find bottlenecks
- Enable Numba parallel execution
- Reduce simulation count if needed

---

## Success Criteria

### Functional Requirements

```
✅ API endpoint /api/v1/simulate works
✅ Accepts portfolio data in JSON format
✅ Returns simulation results in JSON format
✅ API key authentication works
✅ Bloomberg data integration works
✅ Monte Carlo simulation produces correct results
✅ All unit tests pass
✅ All integration tests pass
✅ Docker container runs successfully
```

### Performance Requirements

```
✅ 1,000 simulations:   < 1 second
✅ 10,000 simulations:  < 5 seconds
✅ 100,000 simulations: < 30 seconds
✅ API response time:   < 10 seconds (total)
✅ Docker image size:   < 1 GB
✅ Memory usage:        < 2 GB
```

### Quality Requirements

```
✅ Test coverage:       > 80%
✅ No critical bugs
✅ No security vulnerabilities
✅ Documentation complete
✅ Code follows PEP 8 style guide
✅ Type hints on all functions
```

---

## Post-MVP Roadmap

### Phase 2: Database & Caching (Week 2-3)

**Timeline:** 10 days
**Features:**
- PostgreSQL database for storing simulations
- Redis cache for Bloomberg data
- Celery for background jobs
- Simulation history API endpoints

**Deliverables:**
- Database schema and migrations
- Caching layer
- Background job processing
- New API endpoints: GET /api/v1/simulations (history)

### Phase 3: Advanced Features (Week 4-5)

**Timeline:** 10 days
**Features:**
- OAuth2 + JWT authentication
- Rate limiting (100 requests/hour per user)
- WebSocket for real-time progress updates
- Advanced portfolio optimization (Black-Litterman)

**Deliverables:**
- OAuth2 server
- Rate limiting middleware
- WebSocket endpoints
- Optimization algorithms

### Phase 4: Production Deployment (Week 6)

**Timeline:** 5 days
**Features:**
- Kubernetes deployment
- CI/CD pipeline (GitHub Actions)
- Monitoring (Prometheus + Grafana)
- Load testing

**Deliverables:**
- Kubernetes manifests
- CI/CD workflows
- Monitoring dashboards
- Load test results

### Phase 5: Frontend (Week 7-10)

**Timeline:** 20 days
**Features:**
- Angular 19 web application
- D3.js visualizations (fan charts)
- User authentication
- Portfolio management

**Deliverables:**
- Web application
- Interactive charts
- User dashboard
- Mobile-responsive design

---

## Summary

### MVP Timeline: 5 Days

```
Day 1: Project Setup & Structure           [8 hours]
Day 2: Core Monte Carlo Engine             [8 hours]
Day 3: Bloomberg Integration & FastAPI     [8 hours]
Day 4: Testing & Docker                    [8 hours]
Day 5: Final Testing & Deployment          [8 hours]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total:                                     40 hours
```

### Key Success Factors

1. **Start Simple:** Focus on MVP features only
2. **Test Early:** Write tests alongside code
3. **Performance First:** Optimize with Numba from Day 1
4. **Docker Ready:** Containerize from the start
5. **Documentation:** Update docs as you code

### Next Steps After MVP

1. **Week 1 (Day 1-5):** Build MVP ← YOU ARE HERE
2. **Week 2-3:** Add database and caching
3. **Week 4-5:** Advanced features (OAuth2, rate limiting)
4. **Week 6:** Production deployment (Kubernetes)
5. **Week 7-10:** Frontend development

---

**Document Version:** 1.0
**Last Updated:** December 31, 2025
**Status:** Ready for implementation

**Ready to start? Follow IMPLEMENTATION_GUIDE.md for detailed coding instructions!**
