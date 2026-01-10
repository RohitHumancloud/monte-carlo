# Technology Stack for Monte Carlo Simulation SaaS MVP
## Complete SaaS Platform with Dashboard and API

**Version:** 3.0 (SaaS MVP)
**Created:** December 31, 2025
**Last Updated:** December 31, 2025
**Purpose:** Explain technology decisions for **SaaS MVP** (self-service platform with user dashboard)

---

## 📋 Table of Contents

1. [Executive Summary](#executive-summary)
2. [MVP Scope](#mvp-scope)
3. [Technology Stack](#technology-stack)
4. [Why These Technologies?](#why-these-technologies)
5. [What We're NOT Using (and Why)](#what-were-not-using-and-why)
6. [Architecture Diagram](#architecture-diagram)
7. [Development Setup](#development-setup)
8. [Future Enhancements (Phase 2)](#future-enhancements-phase-2)

---

## Executive Summary

### ✅ SAAS MVP STACK

```
FRONTEND:
  Framework:      React.js 18
  UI Library:     Tailwind CSS
  Build Tool:     Vite
  HTTP Client:    Axios
  Deployment:     Vercel / Netlify

BACKEND:
  Language:       Python 3.11+
  Framework:      FastAPI
  Performance:    NumPy + Numba JIT (10-100x speedup)
  Data Source:    Bloomberg API (xbbg library)

DATABASE:
  Database:       PostgreSQL 15
  ORM:            SQLAlchemy (async)
  Migrations:     Alembic
  Connection:     asyncpg driver

AUTHENTICATION:
  Dashboard Auth: JWT (JSON Web Tokens) - 24-hour expiry
  API Auth:       API Keys (header-based) - 30-day expiry
  Password Hash:  bcrypt (12 rounds)

DEPLOYMENT:
  Containerization: Docker + docker-compose
  Orchestration:    Docker Compose (local), Kubernetes (future)
```

### 🎯 SaaS MVP Goal

**For Users:**
1. Sign up via web dashboard (self-service)
2. Login to dashboard (JWT authentication)
3. Generate minimum 2 API keys (30-day validity)
4. Use API keys to run simulations programmatically

**For Developers:**
- **Input:** Portfolio data in JSON format via API
- **Process:** Run Monte Carlo simulation with Bloomberg data
- **Output:** Simulation results (percentiles, VaR, CVaR, probabilities)
- **Auth:** API key in request header (`X-API-Key`)

---

## SaaS MVP Scope

### ✅ WHAT WE'RE BUILDING

**Frontend (React Dashboard):**
```
✅ User signup page (email + password)
✅ User login page (JWT authentication)
✅ Dashboard UI with API key management
✅ API key generation (minimum 2 keys per user)
✅ API key display (full key shown once, then hidden)
✅ API key revocation
✅ API usage tracking display
✅ Responsive design (desktop + mobile)
```

**Backend (FastAPI + PostgreSQL):**
```
✅ User registration endpoint (POST /auth/register)
✅ User login endpoint (POST /auth/login) - returns JWT
✅ API key management endpoints (generate, list, revoke)
✅ API key validation middleware (30-day expiry check)
✅ PostgreSQL database (users, api_keys, api_call_logs)
✅ JWT authentication for dashboard access
✅ bcrypt password hashing (12 rounds)
✅ Database migrations (Alembic)
```

**Monte Carlo Simulation:**
```
✅ Simulation API endpoint: POST /api/v1/simulate
✅ Core Monte Carlo engine (Numba-optimized)
✅ Bloomberg data integration (xbbg)
✅ Returns rich results (percentiles, VaR, CVaR, probabilities)
✅ Health check endpoint
```

**Deployment:**
```
✅ Docker containers (frontend + backend + database)
✅ docker-compose for local development
✅ Environment variable configuration
✅ Database seed data for testing
```

### ❌ WHAT WE'RE NOT BUILDING (SaaS MVP)

```
❌ No billing/Stripe integration (Phase 2)
❌ No pricing tiers or subscription plans (Phase 2)
❌ No rate limiting (Phase 2)
❌ No Redis caching (Phase 2)
❌ No message queues (Phase 2 - Celery/RabbitMQ)
❌ No Kubernetes (Phase 2 - using Docker Compose only)
❌ No email verification (Phase 2)
❌ No password reset flow (Phase 2)
❌ No OAuth2 social login (Google, GitHub) (Phase 2)
❌ No advanced analytics dashboard (Phase 2)
```

**Philosophy:** Build complete self-service SaaS platform (signup → dashboard → API keys), but NO billing/monetization in MVP. Focus on user experience and API quality first.

---

## Technology Stack

### 1. Language: Python 3.11+

**Why Python for Monte Carlo?**

- ✅ NumPy/SciPy support for numerical computing
- ✅ Numba JIT compilation makes Python **as fast as C** (10-100x speedup)
- ✅ Bloomberg API (xbbg) native Python support
- ✅ Industry standard for quantitative finance
- ✅ Easy to write and maintain compared to C++/Java

**Key Point:** With Numba JIT compilation, Python achieves C-level performance for Monte Carlo while being 10x easier to develop.

---

### 2. Framework: FastAPI

**Why FastAPI for MVP?**

- ✅ **Fastest** Python framework with async support (2-3x faster than Flask)
- ✅ **Auto-generated API documentation** (Swagger UI at `/docs`)
- ✅ **Type safety** with Pydantic (automatic request validation)
- ✅ **Modern** - best for microservices in 2025
- ✅ **Easy learning curve** compared to Django

**Key Features:**

```python
from pydantic import BaseModel

class SimulationRequest(BaseModel):
    initial_investment: float
    monthly_contribution: float = 0
    time_horizon_years: int

@app.post("/api/v1/simulate")
async def run_simulation(request: SimulationRequest):
    # Automatic validation + type checking
    # Auto-generated docs at /docs
    # Async support for concurrent requests
    result = monte_carlo_engine.simulate(request)
    return result
```

---

### 3. Performance: NumPy + Numba

**NumPy: Fast Array Operations**

```python
import numpy as np

# Slow Python loop
total = 0
for i in range(1000000):
    total += i * 2

# Fast NumPy
total = np.sum(np.arange(1000000) * 2)

# Result: NumPy is 100x faster!
```

**Numba: JIT Compilation Magic**

```python
from numba import jit
import numpy as np

# WITHOUT Numba (slow)
def monte_carlo_slow(n):
    result = 0
    for i in range(n):
        result += np.random.random()
    return result

# Time: 3.5 seconds for n=10,000,000

# WITH Numba (fast)
@jit(nopython=True)
def monte_carlo_fast(n):
    result = 0
    for i in range(n):
        result += np.random.random()
    return result

# Time: 0.12 seconds for n=10,000,000
# Speedup: 29x faster!
```

**Numba Features:**
- ✅ Compiles Python to machine code (like C++)
- ✅ No code changes needed (just add `@jit` decorator)
- ✅ Parallel execution with `prange`
- ✅ 10-100x speedup for numerical code

**Example: Geometric Brownian Motion**

```python
from numba import jit, prange
import numpy as np

@jit(nopython=True, parallel=True)
def simulate_gbm_paths(S0, mu, sigma, T, dt, num_paths):
    """
    Simulate stock price paths using GBM

    Performance: 10,000 paths, 252 steps
    - Without Numba: ~30 seconds
    - With Numba:    ~2 seconds (15x faster!)
    """
    num_steps = int(T / dt)
    paths = np.zeros((num_paths, num_steps + 1))
    paths[:, 0] = S0

    drift = (mu - 0.5 * sigma**2) * dt
    vol = sigma * np.sqrt(dt)

    for i in prange(num_paths):  # Parallel execution!
        for t in range(1, num_steps + 1):
            Z = np.random.standard_normal()
            paths[i, t] = paths[i, t-1] * np.exp(drift + vol * Z)

    return paths
```

---

### 4. Data Source: Bloomberg API (xbbg)

**Why Bloomberg for Production?**

- ✅ **Institutional-grade data quality** (99.9% accuracy)
- ✅ **Global coverage** - 350+ million securities
- ✅ **Real-time data** with minimal delay
- ✅ **Total return indices** (includes dividend reinvestment)
- ✅ **Corporate action adjustments** (splits, dividends, mergers)
- ✅ Used by every major bank and hedge fund

**xbbg Library - Python Interface:**

```python
from xbbg import blp
import pandas as pd
from datetime import datetime, timedelta

# Fetch historical data
end_date = datetime.today()
start_date = end_date - timedelta(days=365*10)  # 10 years

data = blp.bdh(
    tickers=['NSEI Index', 'GIND10YR Index'],  # Nifty 50, 10Y Govt Bond
    flds='TOT_RETURN_INDEX_GROSS_DVDS',        # Includes dividends
    start_date=start_date.strftime('%Y%m%d'),
    end_date=end_date.strftime('%Y%m%d'),
    adjust='all'  # Adjust for splits, dividends
)

# Calculate returns
returns = np.log(data / data.shift(1)).dropna()
annual_returns = returns.mean() * 252
annual_volatility = returns.std() * np.sqrt(252)
```

**Alternative for Development/POC:**
```python
# If you don't have Bloomberg Terminal, use yfinance for POC
import yfinance as yf

# Download Nifty 50 data
data = yf.download('^NSEI', start='2015-01-01', end='2025-01-01')
```

---

### 5. Database: PostgreSQL 15

**Why PostgreSQL for SaaS MVP?**

- ✅ **ACID Compliance** - Critical for user data and API key management
- ✅ **Strong Data Integrity** - Foreign keys, constraints, transactions
- ✅ **JSON Support** - Can store simulation metadata if needed
- ✅ **Excellent Python Support** - SQLAlchemy, asyncpg, psycopg2
- ✅ **Free and Open Source** - No licensing costs
- ✅ **Horizontal Scalability** - Can add read replicas later
- ✅ **Industry Standard** - Used by GitHub, Instagram, Reddit

**Database Schema (3 Tables):**

```sql
-- Users table (authentication)
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,  -- bcrypt with 12 rounds
    full_name VARCHAR(255),
    company VARCHAR(255),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW(),
    last_login_at TIMESTAMP
);

-- API keys table (30-day expiry)
CREATE TABLE api_keys (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    key VARCHAR(255) UNIQUE NOT NULL,  -- mk_live_XXXXXXXXXXXXXXXXXXXXXXXX
    name VARCHAR(100),
    status VARCHAR(50) DEFAULT 'active',  -- active, expired, revoked
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP NOT NULL,  -- created_at + 30 days
    last_used_at TIMESTAMP
);

-- API call logs (usage tracking)
CREATE TABLE api_call_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    api_key VARCHAR(255),
    endpoint VARCHAR(255),
    status_code INTEGER,
    execution_time_ms FLOAT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

**SQLAlchemy Integration:**

```python
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

# Async engine
engine = create_async_engine(
    "postgresql+asyncpg://user:password@localhost:5432/monte_carlo_db",
    echo=True,
    pool_size=10
)

# Async session factory
AsyncSessionLocal = sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False
)

# FastAPI dependency
async def get_db():
    async with AsyncSessionLocal() as session:
        yield session
```

---

### 6. Frontend: React.js 18 + Tailwind CSS

**Why React for Dashboard?**

- ✅ **Industry Standard** - Most popular frontend framework (2025)
- ✅ **Component-Based** - Reusable UI components (LoginForm, ApiKeyCard, Dashboard)
- ✅ **Large Ecosystem** - React Router, Axios, state management libraries
- ✅ **Fast Development** - Vite for instant hot module replacement
- ✅ **Easy Deployment** - Vercel/Netlify free tiers

**Why Tailwind CSS?**

- ✅ **Utility-First** - Rapid UI development
- ✅ **No Custom CSS** - Everything in className
- ✅ **Responsive Design** - Built-in breakpoints (sm, md, lg, xl)
- ✅ **Modern Look** - Professional UI out of the box

**Dashboard Components:**

```javascript
// Login page
/pages/Login.jsx

// Dashboard with API key management
/pages/Dashboard.jsx
  ├── /components/Dashboard/ApiKeyCard.jsx
  ├── /components/Dashboard/ApiKeyGenerator.jsx
  └── /components/Dashboard/ApiCallsTable.jsx

// User registration
/pages/Register.jsx
```

**Example Component (API Key Card):**

```jsx
import React from 'react';
import { Copy, Trash2 } from 'lucide-react';

export default function ApiKeyCard({ apiKey, onRevoke }) {
  const handleCopy = () => {
    navigator.clipboard.writeText(apiKey.key);
  };

  return (
    <div className="border rounded-lg p-4 bg-white">
      <h3 className="font-semibold text-lg">{apiKey.name}</h3>
      <code className="text-sm text-gray-600">{apiKey.key_preview}</code>

      <div className="flex gap-2 mt-3">
        <button
          onClick={handleCopy}
          className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
        >
          <Copy size={16} /> Copy Key
        </button>

        <button
          onClick={onRevoke}
          className="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600"
        >
          <Trash2 size={16} /> Revoke
        </button>
      </div>
    </div>
  );
}
```

---

### 7. Authentication: JWT + API Keys (Dual Model)

**Why Dual Authentication?**

```
Dashboard Access (JWT):
✅ Users login to dashboard with email + password
✅ Server returns JWT token (valid for 24 hours)
✅ Frontend stores token in localStorage
✅ All dashboard API calls include Authorization header
✅ Token includes user_id and email

Simulation API Access (API Keys):
✅ Users generate API keys from dashboard
✅ API keys valid for 30 days (free trial)
✅ Programmatic access via X-API-Key header
✅ No need to share JWT tokens with external systems
✅ Can revoke individual API keys without affecting others
```

**JWT Implementation (Dashboard Login):**

```python
from jose import jwt
from datetime import datetime, timedelta
from passlib.context import CryptContext

# Password hashing (bcrypt)
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)  # 12 rounds by default

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)

# JWT token generation
def create_access_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(hours=24)  # 24-hour expiry
    to_encode.update({"exp": expire})

    return jwt.encode(
        to_encode,
        SECRET_KEY,  # From environment variable
        algorithm="HS256"
    )

# Usage in login endpoint
@app.post("/auth/login")
async def login(email: str, password: str, db: AsyncSession = Depends(get_db)):
    user = await get_user_by_email(db, email)

    if not user or not verify_password(password, user.password_hash):
        raise HTTPException(401, "Invalid credentials")

    token = create_access_token({"user_id": user.id, "email": user.email})
    return {"access_token": token, "token_type": "bearer"}
```

**API Key Implementation (Simulation Access):**

```python
import secrets
import string
from datetime import datetime, timedelta

def generate_api_key() -> str:
    """Generate random API key: mk_live_XXXXXXXXXXXXXXXXXXXXXXXX"""
    alphabet = string.ascii_letters + string.digits
    random_part = ''.join(secrets.choice(alphabet) for _ in range(24))
    return f"mk_live_{random_part}"

# Create API key with 30-day expiry
@app.post("/api-keys/generate")
async def create_api_key(
    name: str,
    current_user: User = Depends(get_current_user),  # JWT validated
    db: AsyncSession = Depends(get_db)
):
    new_key = generate_api_key()

    api_key = ApiKey(
        user_id=current_user.id,
        key=new_key,
        name=name,
        created_at=datetime.now(),
        expires_at=datetime.now() + timedelta(days=30),  # 30-day trial
        status='active'
    )

    db.add(api_key)
    await db.commit()

    return {"key": new_key, "expires_at": api_key.expires_at}

# Validate API key for simulation endpoint
@app.post("/api/v1/simulate")
async def simulate(
    request: SimulationRequest,
    x_api_key: str = Header(None, alias="X-API-Key"),
    db: AsyncSession = Depends(get_db)
):
    # Find API key in database
    api_key = await db.execute(
        select(ApiKey).where(ApiKey.key == x_api_key)
    )
    api_key = api_key.scalar_one_or_none()

    if not api_key:
        raise HTTPException(403, "Invalid API key")

    # Check expiry (30 days)
    if datetime.now() > api_key.expires_at:
        raise HTTPException(403, "API key expired. Please generate a new key.")

    # Run simulation
    result = await run_monte_carlo(request)

    # Update last_used_at
    api_key.last_used_at = datetime.now()
    await db.commit()

    return result
```

**Security Best Practices:**

- ✅ **Password Security**: bcrypt with 12 rounds (industry standard)
- ✅ **JWT Security**: 24-hour expiry, signed with HS256
- ✅ **API Key Security**: 32-character random keys (base62 alphabet)
- ✅ **HTTPS Only**: All production traffic over TLS
- ✅ **No Hardcoded Secrets**: All secrets in environment variables

---

### 8. Deployment: Docker + docker-compose

**Why Docker Compose (Multi-Container)?**

```
Benefits:
✅ Same environment (dev/prod)
✅ Easy multi-service orchestration
✅ Isolated dependencies per service
✅ One command to run everything: docker-compose up
✅ Can migrate to Kubernetes later

Services:
✅ PostgreSQL (database)
✅ Backend (FastAPI)
✅ Frontend (React + Nginx)
✅ Automatic networking between containers
```

**docker-compose.yml:**

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: monte_carlo_db
      POSTGRES_USER: monte_carlo_user
      POSTGRES_PASSWORD: your_secure_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: postgresql+asyncpg://monte_carlo_user:your_secure_password@postgres:5432/monte_carlo_db
      JWT_SECRET_KEY: your_jwt_secret_key_here
    depends_on:
      - postgres
    volumes:
      - ./backend:/app

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      VITE_API_BASE_URL: http://localhost:8000
    depends_on:
      - backend

volumes:
  postgres_data:
```

**Backend Dockerfile:
```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY app/ ./app/
COPY .env .env

# Expose port
EXPOSE 8000

# Run FastAPI
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Build & Run:**

```bash
# Build image
docker build -t monte-carlo-mvp .

# Run container
docker run -p 8000:8000 --name monte-carlo monte-carlo-mvp

# Access API
curl http://localhost:8000/health
# Response: {"status": "healthy"}
```

---

## What We're NOT Using (SaaS MVP)

**Note:** This section lists technologies we're intentionally excluding from MVP to keep scope manageable.

### ❌ Billing & Payments (Stripe)
- **Why NOT:** Focus on user experience and API quality first
- **MVP Approach:** 30-day free trial for all users (no payment required)
- **Future (Phase 2):** Add Stripe integration for paid plans

### ❌ Redis Cache
- **Why NOT:** Premature optimization - not needed for initial user base
- **MVP Approach:** Direct PostgreSQL queries (fast enough for < 1000 users)
- **Future (Phase 2):** Cache Bloomberg data and simulation results

### ❌ Message Queue (Celery, RabbitMQ)
- **Why NOT:** Synchronous simulations sufficient for MVP (< 30 seconds)
- **MVP Approach:** Direct FastAPI response with async/await
- **Future (Phase 2):** Add Celery for background jobs (100k+ simulations)

### ❌ Kubernetes
- **Why NOT:** Docker Compose sufficient for MVP scale (< 1000 concurrent users)
- **MVP Approach:** docker-compose on single server or PaaS (Heroku, DigitalOcean)
- **Future (Phase 2):** Migrate to Kubernetes for auto-scaling and high availability

### ❌ Email Verification
- **Why NOT:** Reduces friction for trial users
- **MVP Approach:** Instant signup without email verification
- **Future (Phase 2):** Add email verification to reduce spam accounts

### ❌ OAuth2 Social Login (Google, GitHub)
- **Why NOT:** Email/password sufficient for MVP
- **MVP Approach:** Standard email/password registration
- **Future (Phase 2):** Add social login for easier onboarding

### ❌ Rate Limiting
- **Why NOT:** Free trial model doesn't require strict limits yet
- **MVP Approach:** Unlimited API calls during 30-day trial
- **Future (Phase 2):** Add rate limiting per pricing tier

---

## Architecture Diagram

### SaaS MVP Architecture (Full Stack)

```
┌─────────────────────────────────────────────────────────────────┐
│                       END USERS (Web Browser)                    │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ HTTPS
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│            FRONTEND (React.js + Tailwind CSS + Vite)             │
│                         Port: 3000                               │
├─────────────────────────────────────────────────────────────────┤
│  Pages:                                                          │
│  - /login       → LoginForm.jsx                                 │
│  - /register    → RegisterForm.jsx                              │
│  - /dashboard   → Dashboard.jsx (API key management)            │
│                                                                  │
│  Components:                                                     │
│  - ApiKeyCard.jsx         (display/copy/revoke keys)            │
│  - ApiKeyGenerator.jsx     (create new keys)                    │
│  - ApiCallsTable.jsx       (usage tracking)                     │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ HTTP/JSON
                         │ Authorization: Bearer <JWT>
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              BACKEND (FastAPI + PostgreSQL)                      │
│                         Port: 8000                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Dashboard API (JWT Required):                                  │
│  ┌────────────────────────────────────────────────────┐        │
│  │ POST /auth/register   → Create user account        │        │
│  │ POST /auth/login      → Return JWT token           │        │
│  │ POST /api-keys/generate → Create new API key       │        │
│  │ GET  /api-keys/list    → List user's API keys      │        │
│  │ POST /api-keys/revoke  → Revoke API key            │        │
│  └────────────────────────────────────────────────────┘        │
│                                                                  │
│  Public API (API Key Required):                                 │
│  ┌────────────────────────────────────────────────────┐        │
│  │ POST /api/v1/simulate → Run Monte Carlo simulation │        │
│  │ GET  /health          → Health check               │        │
│  └────────────────────────────────────────────────────┘        │
│                                                                  │
│  Services:                                                       │
│  - AuthService (JWT generation, password hashing)               │
│  - ApiKeyService (generate, validate, revoke keys)              │
│  - MonteCarloService (NumPy + Numba simulation)                 │
│  - BloombergService (xbbg data fetching)                        │
└────────────┬────────────────────────────┬─────────────────────┘
             │                            │
             │ SQL Queries                │ Bloomberg API calls
             ▼                            ▼
┌──────────────────────┐        ┌─────────────────────┐
│  PostgreSQL 15       │        │  Bloomberg Terminal  │
│  Port: 5432          │        │  API                 │
├──────────────────────┤        └─────────────────────┘
│                      │
│  Tables:             │
│  - users             │ (email, password_hash, status)
│  - api_keys          │ (key, expires_at, status)
│  - api_call_logs     │ (endpoint, execution_time)
│                      │
│  Indexes:            │
│  - users(email)      │
│  - api_keys(key)     │
│  - api_keys(user_id) │
└──────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    DEPLOYMENT (docker-compose)                   │
├─────────────────────────────────────────────────────────────────┤
│  3 Services:                                                     │
│  1. postgres    → PostgreSQL database                           │
│  2. backend     → FastAPI application                           │
│  3. frontend    → React.js (Vite dev server)                    │
│                                                                  │
│  Run: docker-compose up                                          │
│  Access: http://localhost:3000 (frontend)                       │
│          http://localhost:8000 (backend API)                    │
└─────────────────────────────────────────────────────────────────┘

User Journey:
1. User visits http://localhost:3000
2. User clicks "Sign Up" → POST /auth/register
3. User logs in → POST /auth/login → receives JWT
4. Dashboard loads → GET /api-keys/list (with JWT)
5. User generates API key → POST /api-keys/generate (with JWT)
6. User integrates API → POST /api/v1/simulate (with API key)
```

---

## Development Setup

### Prerequisites

```bash
# 1. Python 3.11+ (for backend)
python --version  # Should be 3.11 or higher

# 2. Node.js 18+ (for frontend)
node --version  # Should be 18 or higher
npm --version

# 3. PostgreSQL 15 (via Docker or local install)
psql --version

# 4. Docker + Docker Compose (recommended)
docker --version
docker-compose --version

# 5. Bloomberg Terminal (or yfinance for POC)
# If you have Bloomberg Terminal, xbbg will connect automatically
```

### Option 1: Docker Compose (Recommended)

```bash
# 1. Clone repository
cd monte-carlo-saas

# 2. Create .env file
cat > .env << EOF
# Database
DATABASE_URL=postgresql://monte_carlo_user:password@postgres:5432/monte_carlo_db
DATABASE_URL_ASYNC=postgresql+asyncpg://monte_carlo_user:password@postgres:5432/monte_carlo_db

# JWT Secret (generate with: openssl rand -hex 32)
JWT_SECRET_KEY=your_super_secret_jwt_key_here_32_characters_minimum

# API Key Config
API_KEY_PREFIX=mk_live_
API_KEY_LENGTH=24
API_KEY_EXPIRY_DAYS=30
EOF

# 3. Start all services (PostgreSQL + Backend + Frontend)
docker-compose up -d

# 4. Run database migrations
docker-compose exec backend alembic upgrade head

# 5. (Optional) Seed database with test data
docker-compose exec backend python seed_data.py

# 6. Access services
# Frontend: http://localhost:3000
# Backend:  http://localhost:8000
# API Docs: http://localhost:8000/docs

# 7. View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# 8. Stop all services
docker-compose down
```

### Option 2: Local Development (Without Docker)

**Backend Setup:**
```bash
# 1. Create virtual environment
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Set up PostgreSQL locally
createdb monte_carlo_db

# 4. Create .env file (use localhost for DATABASE_URL)
# DATABASE_URL=postgresql://user:password@localhost:5432/monte_carlo_db

# 5. Run migrations
alembic upgrade head

# 6. Run backend server
uvicorn app.main:app --reload --port 8000

# 7. Test API
curl http://localhost:8000/health
# Response: {"status": "healthy"}

# 8. View API docs
# Open browser: http://localhost:8000/docs
```

**Frontend Setup:**
```bash
# 1. Install dependencies
cd frontend
npm install

# 2. Create .env file
echo "VITE_API_BASE_URL=http://localhost:8000" > .env

# 3. Run frontend dev server
npm run dev

# 4. Access frontend
# Open browser: http://localhost:3000
```

---

## Future Enhancements (Phase 2+)

**After SaaS MVP is working, consider adding:**

1. **Billing & Payments (Stripe)** - Monetize with subscription plans
   - Free tier: 100 simulations/month
   - Pro tier: 1,000 simulations/month ($19/month)
   - Enterprise: Unlimited ($99/month)

2. **Email Service (SendGrid, AWS SES)** - Email verification, password reset
   - Welcome emails
   - API key expiry notifications
   - Monthly usage reports

3. **Redis Cache** - Speed up Bloomberg data requests and simulation results
   - Cache Bloomberg data for 1 hour
   - Cache identical simulation requests
   - Expected: 50% faster response times

4. **Rate Limiting (per tier)** - Prevent abuse and manage resources
   - Free: 10 requests/hour
   - Pro: 100 requests/hour
   - Enterprise: Unlimited

5. **Celery + Background Jobs** - Handle long-running simulations asynchronously
   - Simulations > 50,000 paths run in background
   - Email notification when complete
   - Job status tracking

6. **Kubernetes** - Auto-scaling and high availability for production
   - Auto-scale based on CPU/memory
   - Rolling deployments (zero downtime)
   - Multi-region deployment

7. **Monitoring & Observability** - Track performance and errors
   - Prometheus + Grafana for metrics
   - Sentry for error tracking
   - DataDog for APM

8. **Advanced Features:**
   - Portfolio optimization (Black-Litterman model)
   - Custom asset correlations
   - Multi-currency support
   - Downloadable reports (PDF, Excel)

---

## Summary

### ✅ SaaS MVP Technology Stack

```
FRONTEND:
  Framework:      React.js 18 + Tailwind CSS
  Build Tool:     Vite
  Deployment:     Vercel / Netlify

BACKEND:
  Language:       Python 3.11+ (Numba for 10-100x speedup)
  Framework:      FastAPI (modern, async, type-safe)
  Database:       PostgreSQL 15 (users, API keys, logs)
  ORM:            SQLAlchemy (async)
  Auth:           JWT (dashboard) + API Keys (simulation)

MONTE CARLO:
  Performance:    NumPy + Numba JIT compilation
  Data Source:    Bloomberg API (xbbg)
  Output:         Percentiles, VaR, CVaR, Sharpe Ratio

DEPLOYMENT:
  Containers:     Docker + docker-compose
  Services:       Frontend + Backend + PostgreSQL

Timeline:       3-4 weeks
Cost:           $0 (open source) + Bloomberg license
Performance:    < 5 seconds for 10,000 simulations
```

### 🎯 Key Principles

1. **User Experience First:** Self-service signup, easy API key management
2. **Security by Design:** bcrypt passwords, JWT tokens, API key expiry
3. **Production Quality:** PostgreSQL, migrations, error handling, logging
4. **Defer Billing:** Focus on platform and API quality first, monetize later

### 📚 Next Steps

1. ✅ Read this document (TECH_STACK_ARCHITECTURE.md) - Technology decisions
2. ⏭️ Read SAAS_MVP_ARCHITECTURE.md - Complete SaaS architecture
3. ⏭️ Read DATABASE_SCHEMA.md - PostgreSQL database design
4. ⏭️ Read SAAS_IMPLEMENTATION_GUIDE.md - Full-stack implementation code
5. ⏭️ Read API_DOCUMENTATION.md - Public API documentation
6. ⏭️ Read PROJECT_ROADMAP.md - 3-4 week timeline
7. ⏭️ Start implementation!

---

**Document Version:** 3.0 (SaaS MVP)
**Last Updated:** December 31, 2025
**Next Document:** SAAS_MVP_ARCHITECTURE.md
**Author:** Friday (AI Assistant for Tony)
