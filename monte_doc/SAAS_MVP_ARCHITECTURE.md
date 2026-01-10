# Monte Carlo SaaS MVP - Architecture Documentation
## Self-Service Platform with 30-Day Free Trial

**Version:** 1.0 (SaaS MVP)
**Created:** December 31, 2025
**Purpose:** Complete architecture for Monte Carlo as a SaaS product

---

## Table of Contents

1. [Overview](#overview)
2. [SaaS MVP Features](#saas-mvp-features)
3. [System Architecture](#system-architecture)
4. [User Journey Flow](#user-journey-flow)
5. [Component Details](#component-details)
6. [Tech Stack](#tech-stack)
7. [Security Model](#security-model)
8. [API Key Lifecycle](#api-key-lifecycle)
9. [Deployment Architecture](#deployment-architecture)

---

## Overview

### What is This?

A **SaaS (Software as a Service) MVP** for Monte Carlo portfolio simulation with:
- ✅ **Self-Service Signup** - Users create accounts themselves
- ✅ **Free 30-Day Trial** - No credit card required
- ✅ **API Key Management** - Users generate and manage their own API keys
- ✅ **Dashboard** - Web interface to view keys, usage, documentation
- ❌ **NO Billing (MVP)** - No Stripe, no subscriptions, no payments

### Business Model

```
Phase 1 (MVP - NOW):
User signs up → Gets 30-day free trial → Uses API
After 30 days → Keys expire → Manual conversion to paid

Phase 2 (FUTURE):
Add Stripe → Auto-billing → Subscription plans → Upgrade path
```

### Key Metrics

```
Target Users (MVP):        100-500 trial signups
Conversion Goal:           10-20% to paid (after validation)
Timeline:                  3-4 weeks to build
Team Size:                 2-3 developers
```

---

## SaaS MVP Features

### ✅ What We're Building

| Feature | Description | Purpose |
|---------|-------------|---------|
| **User Registration** | Email + password signup | Self-service onboarding |
| **User Login** | JWT authentication | Secure access |
| **User Dashboard** | Web UI to manage account | View keys, usage, docs |
| **API Key Generation** | Users create min 2 keys | Enable API integration |
| **30-Day Expiry** | Keys auto-expire after 30 days | Time-limited trial |
| **API Documentation** | Public docs with examples | Help users integrate |
| **Monte Carlo API** | Portfolio simulation endpoint | Core value proposition |
| **Usage Tracking** | Log API calls per user | Monitor adoption |

### ❌ What We're NOT Building (MVP)

| Feature | Status | When? |
|---------|--------|-------|
| Billing/Payments | ❌ Not in MVP | Phase 2 |
| Stripe Integration | ❌ Not in MVP | Phase 2 |
| Subscription Plans | ❌ Not in MVP | Phase 2 |
| Auto-Renewal | ❌ Not in MVP | Phase 2 |
| Rate Limiting | ⚠️ Optional | Phase 1.5 |
| Webhooks | ❌ Not in MVP | Phase 2 |
| Multi-Org Accounts | ❌ Not in MVP | Phase 3 |

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    USER'S BROWSER                            │
│                                                              │
│  1. Visits https://montecarlo.ai                            │
│  2. Signs up (email + password)                             │
│  3. Logs in → Gets JWT token                                │
│  4. Views dashboard → Generates API keys                    │
│  5. Copies API key → Uses in their application              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ HTTPS
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              FRONTEND (React.js / Vue.js)                    │
│              Hosted on: Vercel / Netlify                     │
│                                                              │
│  Pages:                                                      │
│  ├── Landing Page (/)                                        │
│  ├── Sign Up (/signup)                                       │
│  ├── Login (/login)                                          │
│  ├── Dashboard (/dashboard)                                  │
│  │   ├── My API Keys                                         │
│  │   ├── Generate New Key                                    │
│  │   ├── Usage Stats                                         │
│  │   └── API Documentation                                   │
│  └── Public API Docs (/docs)                                │
│                                                              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ REST API (JSON)
                         │ Authorization: Bearer <JWT>
                         ▼
┌─────────────────────────────────────────────────────────────┐
│           BACKEND API SERVER (FastAPI / Node.js)             │
│           Hosted on: AWS EC2 / GCP / Azure                   │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Authentication Module                               │   │
│  │  - POST /api/auth/signup                            │   │
│  │  - POST /api/auth/login                             │   │
│  │  - POST /api/auth/logout                            │   │
│  │  - GET  /api/auth/me                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Dashboard APIs (Protected - needs JWT)             │   │
│  │  - GET  /api/dashboard/keys                         │   │
│  │  - POST /api/dashboard/keys/create                  │   │
│  │  - DELETE /api/dashboard/keys/:id                   │   │
│  │  - GET  /api/dashboard/usage                        │   │
│  │  - GET  /api/dashboard/profile                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Public Monte Carlo API (needs API key)             │   │
│  │  - POST /api/v1/simulate                            │   │
│  │       → Validates API key                           │   │
│  │       → Checks 30-day expiry                        │   │
│  │       → Calls Monte Carlo Engine                    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
└────────────────────────┬────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
┌─────────────┐  ┌──────────────┐  ┌──────────────┐
│ PostgreSQL  │  │    Redis     │  │ Monte Carlo  │
│  Database   │  │   (Cache)    │  │   Engine     │
│             │  │              │  │  (Python +   │
│ Tables:     │  │ - Sessions   │  │   Numba)     │
│ - users     │  │ - Rate limit │  │              │
│ - api_keys  │  │              │  │ Bloomberg    │
│ - api_calls │  │              │  │ Integration  │
└─────────────┘  └──────────────┘  └──────────────┘
```

---

## User Journey Flow

### Complete Flow (Sign Up → API Integration)

```
STEP 1: User Visits Website
┌────────────────────────────────────────┐
│  https://montecarlo.ai                 │
│                                        │
│  🎲 Monte Carlo Simulation API         │
│  Portfolio Analysis as a Service       │
│                                        │
│  ✅ Free 30-Day Trial                  │
│  ✅ No Credit Card Required            │
│  ✅ 2 API Keys Included                │
│                                        │
│  [Get Started Free]                    │
└────────────────────────────────────────┘
           │
           ▼

STEP 2: Sign Up Form
┌────────────────────────────────────────┐
│  Create Your Free Account              │
│                                        │
│  Full Name:  [John Doe          ]     │
│  Email:      [john@company.com  ]     │
│  Company:    [ACME Financial    ]     │
│  Password:   [*************     ]     │
│                                        │
│  [Create Account]                      │
└────────────────────────────────────────┘
           │
           ▼
     Backend Processing:
     1. Validate email unique
     2. Hash password (bcrypt)
     3. Create user record
     4. Auto-generate 2 API keys (30-day expiry)
     5. Send welcome email
     6. Return JWT token
           │
           ▼

STEP 3: Dashboard (After Login)
┌────────────────────────────────────────┐
│  🔑 Your API Keys                      │
│                                        │
│  API Key 1                             │
│  mk_live_abc123xyz789      [Copy]     │
│  Expires: Jan 30, 2026 (28 days) ⏳   │
│  Status: ✅ Active                     │
│                                        │
│  API Key 2                             │
│  mk_live_def456ghi012      [Copy]     │
│  Expires: Jan 30, 2026 (28 days) ⏳   │
│  Status: ✅ Active                     │
│                                        │
│  [+ Generate New API Key]              │
│                                        │
│  📖 API Documentation                  │
│  [View Docs] [Code Examples]           │
└────────────────────────────────────────┘
           │
           ▼

STEP 4: User Integrates in Their App
┌────────────────────────────────────────┐
│  User's Java/Python/Node.js App        │
│                                        │
│  POST https://api.montecarlo.ai/v1/... │
│  Header: X-API-Key: mk_live_abc123...  │
│  Body: { portfolio, parameters }       │
└────────────────────────────────────────┘
           │
           ▼
     Backend Validation:
     1. Extract API key from header
     2. Find key in database
     3. Check status = 'active'
     4. Check expires_at > now()
     5. ✅ Run Monte Carlo simulation
     6. Log API call
     7. Return results
           │
           ▼

STEP 5: Results Returned
┌────────────────────────────────────────┐
│  {                                     │
│    "results": {                        │
│      "median": 2567890,                │
│      "percentiles": {                  │
│        "p10": 2043210,  // Worst       │
│        "p50": 2567890,  // Base        │
│        "p90": 3398760   // Best        │
│      }                                 │
│    }                                   │
│  }                                     │
└────────────────────────────────────────┘
```

---

## Component Details

### 1. Frontend (React.js)

**Technology:** React.js + Tailwind CSS + Axios

**Pages:**

```
src/
├── pages/
│   ├── LandingPage.jsx          → Home page with "Sign Up" CTA
│   ├── SignupPage.jsx           → User registration form
│   ├── LoginPage.jsx            → User login form
│   ├── DashboardPage.jsx        → Main dashboard (after login)
│   │   ├── ApiKeysSection       → List/generate API keys
│   │   ├── UsageStatsSection    → API call statistics
│   │   └── QuickStartSection    → Getting started guide
│   └── DocsPage.jsx             → Public API documentation
│
├── components/
│   ├── ApiKeyCard.jsx           → Display single API key
│   ├── GenerateKeyModal.jsx     → Modal to create new key
│   ├── CopyButton.jsx           → Copy to clipboard
│   └── CodeExample.jsx          → Syntax-highlighted code
│
├── services/
│   ├── authService.js           → Login/signup API calls
│   ├── dashboardService.js      → Dashboard API calls
│   └── apiClient.js             → Axios instance with JWT
│
└── App.jsx
```

**State Management:**
- Context API for auth state (user, JWT token)
- Local state for dashboard data

---

### 2. Backend API (FastAPI)

**Technology:** Python 3.11 + FastAPI + PostgreSQL + Redis

**Project Structure:**

```
backend/
├── app/
│   ├── main.py                  → FastAPI application
│   │
│   ├── auth/
│   │   ├── __init__.py
│   │   ├── routes.py            → /api/auth/* endpoints
│   │   ├── service.py           → Auth logic (signup, login)
│   │   └── middleware.py        → JWT validation
│   │
│   ├── dashboard/
│   │   ├── __init__.py
│   │   ├── routes.py            → /api/dashboard/* endpoints
│   │   ├── service.py           → API key generation, usage stats
│   │   └── models.py            → Pydantic models
│   │
│   ├── simulation/
│   │   ├── __init__.py
│   │   ├── routes.py            → /api/v1/simulate endpoint
│   │   ├── service.py           → Monte Carlo simulation logic
│   │   └── validation.py        → API key validation
│   │
│   ├── models/
│   │   ├── __init__.py
│   │   ├── user.py              → User SQLAlchemy model
│   │   ├── api_key.py           → ApiKey SQLAlchemy model
│   │   └── api_call.py          → ApiCall SQLAlchemy model
│   │
│   ├── database.py              → PostgreSQL connection
│   ├── config.py                → Environment variables
│   └── utils.py                 → Helper functions
│
├── requirements.txt
├── Dockerfile
└── .env
```

---

### 3. Database (PostgreSQL)

**Schema:** 3 main tables

```sql
-- Users table
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    company VARCHAR(255),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW(),
    last_login_at TIMESTAMP
);

-- API Keys table
CREATE TABLE api_keys (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    key VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP NOT NULL,
    last_used_at TIMESTAMP
);

-- API Call Logs table
CREATE TABLE api_call_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id),
    api_key VARCHAR(255),
    endpoint VARCHAR(255),
    execution_time DECIMAL(10, 2),
    status_code INT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

See `DATABASE_SCHEMA.md` for complete schema.

---

### 4. Monte Carlo Engine (Python)

**Same as documented in IMPLEMENTATION_GUIDE.md**

- NumPy + Numba optimization
- Bloomberg data integration (xbbg)
- Geometric Brownian Motion (GBM)
- Returns percentiles (P10, P50, P90)

**Integration:**
- Called by Backend API after API key validation
- Stateless service (can be scaled independently)

---

## Tech Stack

### Frontend

```
Language:       JavaScript (ES6+)
Framework:      React.js 18+
Styling:        Tailwind CSS
HTTP Client:    Axios
Build Tool:     Vite
Deployment:     Vercel / Netlify
```

### Backend

```
Language:       Python 3.11+
Framework:      FastAPI
Database ORM:   SQLAlchemy
Migration:      Alembic
Auth:           PyJWT (JSON Web Tokens)
Password:       Bcrypt
Cache:          Redis (optional)
Deployment:     Docker + AWS EC2 / GCP
```

### Database

```
Database:       PostgreSQL 14+
Hosting:        AWS RDS / Google Cloud SQL
Backup:         Automated daily backups
```

### Monte Carlo Engine

```
Language:       Python 3.11+
Libraries:      NumPy, Numba, SciPy
Data Source:    Bloomberg API (xbbg)
Alternative:    Yahoo Finance (yfinance) for dev
```

---

## Security Model

### Authentication Flow

```
1. User Signup:
   Email + Password → Hash password (bcrypt) → Store in DB

2. User Login:
   Email + Password → Verify hash → Generate JWT token (24h expiry)

3. Dashboard Access:
   Request with JWT → Validate JWT → Allow access

4. API Call:
   Request with API key → Validate key + expiry → Run simulation
```

### JWT Token Structure

```json
{
  "user_id": 123,
  "email": "user@company.com",
  "exp": 1704153600,  // Expiry timestamp (24 hours)
  "iat": 1704067200   // Issued at timestamp
}
```

### API Key Format

```
Prefix: mk_live_
Random: 24 characters (base62: a-z, A-Z, 0-9)
Example: mk_live_abc123XYZ789def456GHI

Validation:
- Check if exists in database
- Check status = 'active'
- Check expires_at > current_time
```

### Password Security

```python
# Hashing
import bcrypt

password = "user_password"
salt = bcrypt.gensalt(rounds=12)  # Strong hashing
hash = bcrypt.hashpw(password.encode(), salt)

# Verification
is_valid = bcrypt.checkpw(password.encode(), hash)
```

---

## API Key Lifecycle

### States

```
┌──────────┐
│  ACTIVE  │  → Valid, can make API calls
└──────────┘
     │
     ├─ After 30 days ──→ ┌──────────┐
     │                    │ EXPIRED  │
     │                    └──────────┘
     │
     └─ User clicks    ──→ ┌──────────┐
        "Revoke"           │ REVOKED  │
                           └──────────┘
```

### Expiry Logic

```python
from datetime import datetime, timedelta

# On key creation
api_key = ApiKey(
    key=generate_key(),
    created_at=datetime.now(),
    expires_at=datetime.now() + timedelta(days=30),  # 30-day trial
    status='active'
)

# On API call
if datetime.now() > api_key.expires_at:
    # Auto-update status
    api_key.status = 'expired'
    raise HTTPException(403, "API key expired")
```

### Expiry Notification

```
Day 25: Email warning "Your trial expires in 5 days"
Day 28: Email warning "Your trial expires in 2 days"
Day 30: Email "Your trial has expired" + CTA to upgrade
```

---

## Deployment Architecture

### Production Setup

```
┌─────────────────────────────────────────────────────────┐
│                    CLOUDFLARE CDN                        │
│  - SSL/TLS                                               │
│  - DDoS Protection                                       │
│  - Caching                                               │
└────────────────────────┬────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│   Frontend   │  │   Backend    │  │  Database    │
│   (Vercel)   │  │  (AWS EC2)   │  │  (AWS RDS)   │
│              │  │              │  │              │
│ - React app  │  │ - FastAPI    │  │ - PostgreSQL │
│ - Static     │  │ - Docker     │  │ - Backups    │
│   assets     │  │ - Nginx      │  │              │
└──────────────┘  └──────────────┘  └──────────────┘
```

### Environment Variables

```bash
# Backend (.env)
DATABASE_URL=postgresql://user:pass@host:5432/monte_carlo
JWT_SECRET_KEY=your_secret_key_here
REDIS_URL=redis://localhost:6379
BLOOMBERG_API_KEY=your_bloomberg_key
FRONTEND_URL=https://montecarlo.ai

# Frontend (.env)
VITE_API_URL=https://api.montecarlo.ai
```

---

## Monitoring & Analytics

### Key Metrics to Track

```
1. User Metrics:
   - Total signups
   - Daily active users (DAU)
   - Trial completion rate

2. API Metrics:
   - Total API calls
   - Average response time
   - Error rate
   - API calls per user

3. Conversion Metrics:
   - Trial → Paid conversion (after 30 days)
   - Engagement score (API calls per week)
```

### Logging

```python
import logging

logger = logging.getLogger(__name__)

# Log all API calls
logger.info(f"API call: user_id={user_id}, endpoint={endpoint}, status={status}")

# Log errors
logger.error(f"Simulation failed: {error}", exc_info=True)
```

---

## Summary

### What You Have

✅ **Complete SaaS MVP Architecture**
- User signup/login system
- Dashboard for API key management
- 30-day free trial (auto-expiry)
- Public API documentation
- Monte Carlo simulation endpoint
- Database schema
- Security model
- Deployment plan

### What's NOT Included (Phase 2)

❌ Billing/payments (Stripe)
❌ Subscription management
❌ Auto-renewal
❌ Pricing tiers
❌ Usage-based limits

### Timeline

```
Week 1: Backend (auth, API keys, database)
Week 2: Frontend (dashboard, docs)
Week 3: Integration & testing
Week 4: Deployment & launch
```

### Next Steps

1. Read `SAAS_IMPLEMENTATION_GUIDE.md` for step-by-step code
2. Read `DATABASE_SCHEMA.md` for complete database design
3. Read `API_DOCUMENTATION.md` for public API docs
4. Follow `PROJECT_ROADMAP.md` for implementation timeline

---

**Document Version:** 1.0
**Last Updated:** December 31, 2025
**Status:** ✅ Ready for Implementation
