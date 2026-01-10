# Database Schema for Monte Carlo SaaS MVP

**Version:** 1.0 (SaaS MVP)
**Created:** December 31, 2025
**Purpose:** Complete PostgreSQL database schema for user management, API key lifecycle, and usage tracking

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Database Choice Rationale](#database-choice-rationale)
3. [Schema Design](#schema-design)
4. [Table Definitions](#table-definitions)
5. [Indexes and Performance](#indexes-and-performance)
6. [Sample Data](#sample-data)
7. [Migration Scripts](#migration-scripts)
8. [Database Setup](#database-setup)
9. [Scalability Considerations](#scalability-considerations)

---

## Overview

### SaaS MVP Database Requirements

```
✅ User registration and authentication
✅ API key generation and management (minimum 2 keys per user)
✅ API key expiry tracking (30-day validity)
✅ API call logging (usage tracking)
✅ User status management (active/inactive/suspended)
✅ API key revocation support

❌ NOT in MVP:
- Billing and payment tables
- Subscription plans
- Usage limits/rate limiting
- Multi-tenancy (organizations)
```

### Database Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    PostgreSQL Database                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────┐      ┌──────────┐      ┌──────────────┐  │
│  │  users   │──┐   │ api_keys │──┐   │ api_call_    │  │
│  │          │  │   │          │  │   │ logs         │  │
│  │ - id     │  │   │ - id     │  │   │              │  │
│  │ - email  │  │   │ - user_id│◄─┘   │ - user_id    │  │
│  │ - pass   │  └──►│ - key    │      │ - api_key    │  │
│  │ - name   │      │ - status │      │ - endpoint   │  │
│  │ - status │      │ - created│      │ - created_at │  │
│  │ - created│      │ - expires│      └──────────────┘  │
│  └──────────┘      └──────────┘                         │
│                                                          │
│  3 Tables Total (MVP Simplified)                         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Database Choice Rationale

### Why PostgreSQL for SaaS MVP?

**✅ Advantages:**
- **ACID compliance** - Critical for user data and API key management
- **Strong data integrity** - Foreign keys, constraints, transactions
- **JSON support** - Store simulation metadata if needed
- **Excellent Python support** - SQLAlchemy, asyncpg, psycopg2
- **Free and open source** - No licensing costs
- **Horizontal scalability** - Can add read replicas later
- **Industry standard** - Used by GitHub, Instagram, Reddit

**Comparison with Alternatives:**

| Feature | PostgreSQL | MySQL | MongoDB |
|---------|-----------|-------|---------|
| ACID Transactions | ✅ Excellent | ✅ Good | ⚠️ Limited |
| Data Integrity | ✅ Strong | ✅ Good | ❌ Weak |
| JSON Support | ✅ Native | ⚠️ Basic | ✅ Native |
| Python Ecosystem | ✅ Excellent | ✅ Good | ✅ Good |
| Cost | ✅ Free | ✅ Free | ✅ Free |
| **Best For** | **SaaS MVP** | Web apps | Document storage |

**Decision:** PostgreSQL is the best choice for SaaS MVP due to strong data integrity requirements (users, API keys cannot be corrupted).

---

## Schema Design

### Entity Relationship Diagram (ERD)

```
┌─────────────────────────────────────────────────────────┐
│                        users                             │
├─────────────────────────────────────────────────────────┤
│ PK  id                BIGSERIAL                          │
│ UQ  email             VARCHAR(255)                       │
│     password_hash     VARCHAR(255)                       │
│     full_name         VARCHAR(255)                       │
│     company           VARCHAR(255)                       │
│     status            VARCHAR(50)   DEFAULT 'active'     │
│     created_at        TIMESTAMP     DEFAULT NOW()        │
│     last_login_at     TIMESTAMP                          │
└────────────┬────────────────────────────────────────────┘
             │ 1
             │
             │ N
┌────────────┴────────────────────────────────────────────┐
│                      api_keys                            │
├─────────────────────────────────────────────────────────┤
│ PK  id                BIGSERIAL                          │
│ FK  user_id           BIGINT → users(id)                 │
│ UQ  key               VARCHAR(255)                       │
│     name              VARCHAR(100)                       │
│     status            VARCHAR(50)   DEFAULT 'active'     │
│     created_at        TIMESTAMP     DEFAULT NOW()        │
│     expires_at        TIMESTAMP     NOT NULL             │
│     last_used_at      TIMESTAMP                          │
└────────────┬────────────────────────────────────────────┘
             │ 1
             │
             │ N
┌────────────┴────────────────────────────────────────────┐
│                   api_call_logs                          │
├─────────────────────────────────────────────────────────┤
│ PK  id                BIGSERIAL                          │
│ FK  user_id           BIGINT → users(id)                 │
│     api_key           VARCHAR(255)                       │
│     endpoint          VARCHAR(255)                       │
│     method            VARCHAR(10)                        │
│     status_code       INTEGER                            │
│     execution_time_ms FLOAT                              │
│     error_message     TEXT                               │
│     created_at        TIMESTAMP     DEFAULT NOW()        │
└─────────────────────────────────────────────────────────┘

Relationships:
- users (1) → (N) api_keys (One user has many API keys)
- users (1) → (N) api_call_logs (One user makes many API calls)
```

### Design Principles

1. **Normalization** - Third Normal Form (3NF) to avoid data redundancy
2. **Denormalization for Performance** - Store `user_id` in `api_call_logs` to avoid JOIN on every API call
3. **Soft Deletes** - Use `status` field instead of hard deletes (audit trail)
4. **Timestamps** - Every table has `created_at` for audit and debugging
5. **Constraints** - Foreign keys enforce referential integrity
6. **Indexes** - Strategic indexes on frequently queried columns

---

## Table Definitions

### Table 1: `users`

**Purpose:** Store user account information for dashboard login

```sql
CREATE TABLE users (
    id                BIGSERIAL PRIMARY KEY,
    email             VARCHAR(255) UNIQUE NOT NULL,
    password_hash     VARCHAR(255) NOT NULL,
    full_name         VARCHAR(255),
    company           VARCHAR(255),
    status            VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    created_at        TIMESTAMP DEFAULT NOW(),
    last_login_at     TIMESTAMP,

    -- Constraints
    CONSTRAINT email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- Comments
COMMENT ON TABLE users IS 'User accounts for Monte Carlo SaaS dashboard';
COMMENT ON COLUMN users.password_hash IS 'Bcrypt hash with 12 rounds';
COMMENT ON COLUMN users.status IS 'active: can login, inactive: disabled, suspended: banned';
```

**Field Details:**

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `id` | BIGSERIAL | Auto-incrementing primary key | `1234` |
| `email` | VARCHAR(255) | User email (unique, login identifier) | `tony@example.com` |
| `password_hash` | VARCHAR(255) | Bcrypt hashed password (12 rounds) | `$2b$12$...` |
| `full_name` | VARCHAR(255) | User's full name (optional) | `Tony Stark` |
| `company` | VARCHAR(255) | Company name (optional) | `Stark Industries` |
| `status` | VARCHAR(50) | Account status (active/inactive/suspended) | `active` |
| `created_at` | TIMESTAMP | Account creation timestamp | `2025-12-31 10:30:00` |
| `last_login_at` | TIMESTAMP | Last successful login | `2025-12-31 14:20:00` |

**Status Values:**
- `active` - User can login and create API keys
- `inactive` - User account disabled (temporarily)
- `suspended` - User banned (violates terms of service)

---

### Table 2: `api_keys`

**Purpose:** Store API keys generated by users (minimum 2 keys per user)

```sql
CREATE TABLE api_keys (
    id                BIGSERIAL PRIMARY KEY,
    user_id           BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    key               VARCHAR(255) UNIQUE NOT NULL,
    name              VARCHAR(100),
    status            VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'revoked')),
    created_at        TIMESTAMP DEFAULT NOW(),
    expires_at        TIMESTAMP NOT NULL,
    last_used_at      TIMESTAMP,

    -- Constraints
    CONSTRAINT key_format CHECK (key ~* '^mk_live_[A-Za-z0-9]{24}$')
);

-- Indexes
CREATE INDEX idx_api_keys_key ON api_keys(key);
CREATE INDEX idx_api_keys_user_id ON api_keys(user_id);
CREATE INDEX idx_api_keys_status ON api_keys(status);
CREATE INDEX idx_api_keys_expires_at ON api_keys(expires_at);

-- Composite index for common query: find active keys for user
CREATE INDEX idx_api_keys_user_status ON api_keys(user_id, status);

-- Comments
COMMENT ON TABLE api_keys IS 'API keys for accessing Monte Carlo simulation endpoint';
COMMENT ON COLUMN api_keys.key IS 'Format: mk_live_XXXXXXXXXXXXXXXXXXXXXXXX (32 chars total)';
COMMENT ON COLUMN api_keys.expires_at IS 'Auto-set to created_at + 30 days (30-day trial)';
COMMENT ON COLUMN api_keys.status IS 'active: valid, expired: past expires_at, revoked: user-revoked';
```

**Field Details:**

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `id` | BIGSERIAL | Auto-incrementing primary key | `5678` |
| `user_id` | BIGINT | Foreign key to users table | `1234` |
| `key` | VARCHAR(255) | API key string (unique) | `mk_live_a1b2c3d4e5f6g7h8i9j0k1l2` |
| `name` | VARCHAR(100) | User-provided name for the key | `Production API Key` |
| `status` | VARCHAR(50) | Key status (active/expired/revoked) | `active` |
| `created_at` | TIMESTAMP | Key creation timestamp | `2025-12-31 10:30:00` |
| `expires_at` | TIMESTAMP | Expiry timestamp (created_at + 30 days) | `2026-01-30 10:30:00` |
| `last_used_at` | TIMESTAMP | Last API call timestamp | `2025-12-31 14:20:00` |

**API Key Format:**
```
mk_live_a1b2c3d4e5f6g7h8i9j0k1l2
│   │    └─────────┬────────────┘
│   │              └─ 24 random characters (base62: A-Za-z0-9)
│   └─ Environment (live for production, test for sandbox)
└─ Prefix (monte_carlo → mk)

Total length: 32 characters
```

**Status Values:**
- `active` - Key is valid and can be used
- `expired` - Key passed `expires_at` timestamp (auto-updated by cron job or API validation)
- `revoked` - User manually revoked the key (cannot be reactivated)

**30-Day Expiry Logic:**
```sql
-- When creating a key:
INSERT INTO api_keys (user_id, key, name, created_at, expires_at)
VALUES (
    1234,
    'mk_live_a1b2c3...',
    'Production Key',
    NOW(),
    NOW() + INTERVAL '30 days'  -- Auto-expiry in 30 days
);
```

---

### Table 3: `api_call_logs`

**Purpose:** Track all API calls for usage analytics and debugging

```sql
CREATE TABLE api_call_logs (
    id                    BIGSERIAL PRIMARY KEY,
    user_id               BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    api_key               VARCHAR(255) NOT NULL,
    endpoint              VARCHAR(255) NOT NULL,
    method                VARCHAR(10) NOT NULL,
    status_code           INTEGER NOT NULL,
    execution_time_ms     FLOAT,
    error_message         TEXT,
    request_payload_hash  VARCHAR(64),  -- SHA-256 hash of request (for debugging)
    created_at            TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_api_call_logs_user_id ON api_call_logs(user_id);
CREATE INDEX idx_api_call_logs_api_key ON api_call_logs(api_key);
CREATE INDEX idx_api_call_logs_created_at ON api_call_logs(created_at DESC);
CREATE INDEX idx_api_call_logs_status_code ON api_call_logs(status_code);

-- Composite index for dashboard queries: "Show me my API calls from last 7 days"
CREATE INDEX idx_api_call_logs_user_created ON api_call_logs(user_id, created_at DESC);

-- Comments
COMMENT ON TABLE api_call_logs IS 'Log every API call for usage tracking and debugging';
COMMENT ON COLUMN api_call_logs.execution_time_ms IS 'Time taken to run simulation (in milliseconds)';
COMMENT ON COLUMN api_call_logs.request_payload_hash IS 'SHA-256 hash of request JSON (for duplicate detection)';
```

**Field Details:**

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `id` | BIGSERIAL | Auto-incrementing primary key | `123456` |
| `user_id` | BIGINT | Foreign key to users table | `1234` |
| `api_key` | VARCHAR(255) | API key used for the call | `mk_live_a1b2c3...` |
| `endpoint` | VARCHAR(255) | API endpoint called | `/api/v1/simulate` |
| `method` | VARCHAR(10) | HTTP method | `POST` |
| `status_code` | INTEGER | HTTP response code | `200` |
| `execution_time_ms` | FLOAT | Simulation execution time (ms) | `2340.56` |
| `error_message` | TEXT | Error message if call failed | `Invalid API key` |
| `request_payload_hash` | VARCHAR(64) | SHA-256 hash of request body | `a1b2c3d4e5f6...` |
| `created_at` | TIMESTAMP | Timestamp of API call | `2025-12-31 14:20:00` |

**Why Store `user_id` AND `api_key`?**
- **Performance:** Avoid JOIN with `api_keys` table on every dashboard query
- **Audit Trail:** If API key is deleted, we still know which user made the call
- **Analytics:** Fast queries like "Show all calls by user X"

---

## Indexes and Performance

### Index Strategy

**Primary Indexes (Automatic):**
- `users.id` (Primary Key)
- `api_keys.id` (Primary Key)
- `api_call_logs.id` (Primary Key)

**Unique Indexes:**
- `users.email` - Fast login lookup
- `api_keys.key` - Fast API key validation

**Foreign Key Indexes:**
- `api_keys.user_id` - Join users ↔ api_keys
- `api_call_logs.user_id` - Join users ↔ logs

**Performance Indexes:**
- `users.created_at DESC` - Dashboard: "Newest users"
- `api_keys.expires_at` - Cron job: Find expired keys
- `api_call_logs.created_at DESC` - Dashboard: "Recent API calls"
- `api_call_logs(user_id, created_at DESC)` - Dashboard: "My API calls"

**Query Performance Examples:**

```sql
-- Query 1: Login (uses idx_users_email)
SELECT * FROM users WHERE email = 'tony@example.com';
-- Execution time: ~1ms (index scan)

-- Query 2: Validate API key (uses idx_api_keys_key)
SELECT * FROM api_keys WHERE key = 'mk_live_a1b2c3...' AND status = 'active';
-- Execution time: ~1ms (index scan)

-- Query 3: User dashboard - Show my active API keys (uses idx_api_keys_user_status)
SELECT * FROM api_keys WHERE user_id = 1234 AND status = 'active';
-- Execution time: ~2ms (index scan)

-- Query 4: User dashboard - Show my last 100 API calls (uses idx_api_call_logs_user_created)
SELECT * FROM api_call_logs WHERE user_id = 1234 ORDER BY created_at DESC LIMIT 100;
-- Execution time: ~5ms (index scan)

-- Query 5: Admin - Find expired API keys (uses idx_api_keys_expires_at)
SELECT * FROM api_keys WHERE expires_at < NOW() AND status = 'active';
-- Execution time: ~10ms (index scan)
```

---

## Sample Data

### Insert Sample Users

```sql
-- Sample user 1: Tony Stark
INSERT INTO users (email, password_hash, full_name, company, status)
VALUES (
    'tony@starkindustries.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYk3H.PoIai',  -- Password: "IronMan123"
    'Tony Stark',
    'Stark Industries',
    'active'
);

-- Sample user 2: Bruce Wayne
INSERT INTO users (email, password_hash, full_name, company, status)
VALUES (
    'bruce@wayneenterprises.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYk3H.PoIai',  -- Password: "Batman123"
    'Bruce Wayne',
    'Wayne Enterprises',
    'active'
);

-- Sample user 3: Inactive user
INSERT INTO users (email, password_hash, full_name, company, status)
VALUES (
    'inactive@example.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYk3H.PoIai',
    'Inactive User',
    'Test Corp',
    'inactive'
);
```

### Insert Sample API Keys

```sql
-- Tony's API keys (2 active keys - minimum requirement)
INSERT INTO api_keys (user_id, key, name, created_at, expires_at, status)
VALUES
(
    1,  -- Tony's user_id
    'mk_live_abc123xyz789def456ghi012',
    'Production API Key',
    '2025-12-31 10:00:00',
    '2026-01-30 10:00:00',  -- 30 days later
    'active'
),
(
    1,
    'mk_live_xyz789abc123ghi456def012',
    'Development API Key',
    '2025-12-31 11:00:00',
    '2026-01-30 11:00:00',
    'active'
);

-- Bruce's API keys
INSERT INTO api_keys (user_id, key, name, created_at, expires_at, status)
VALUES
(
    2,  -- Bruce's user_id
    'mk_live_bruce123wayne456batman78',
    'Main API Key',
    '2025-12-30 09:00:00',
    '2026-01-29 09:00:00',
    'active'
),
(
    2,
    'mk_live_wayne789bruce123batman45',
    'Backup API Key',
    '2025-12-30 09:30:00',
    '2026-01-29 09:30:00',
    'active'
);

-- Expired key example
INSERT INTO api_keys (user_id, key, name, created_at, expires_at, status)
VALUES
(
    1,
    'mk_live_expired123old456key789ab',
    'Old Expired Key',
    '2025-11-01 10:00:00',
    '2025-12-01 10:00:00',  -- Expired 30 days ago
    'expired'
);
```

### Insert Sample API Call Logs

```sql
-- Successful API calls by Tony
INSERT INTO api_call_logs (user_id, api_key, endpoint, method, status_code, execution_time_ms, created_at)
VALUES
(
    1,
    'mk_live_abc123xyz789def456ghi012',
    '/api/v1/simulate',
    'POST',
    200,
    2340.56,
    '2025-12-31 14:20:00'
),
(
    1,
    'mk_live_abc123xyz789def456ghi012',
    '/api/v1/simulate',
    'POST',
    200,
    1890.23,
    '2025-12-31 15:10:00'
);

-- Failed API call (invalid API key)
INSERT INTO api_call_logs (user_id, api_key, endpoint, method, status_code, execution_time_ms, error_message, created_at)
VALUES
(
    2,
    'mk_live_invalid_key_123',
    '/api/v1/simulate',
    'POST',
    403,
    NULL,
    'Invalid API key',
    '2025-12-31 16:00:00'
);
```

---

## Migration Scripts

### Alembic Setup (Database Migrations)

**Why Alembic?**
- Industry-standard database migration tool for Python
- Version control for database schema
- Safe rollback mechanism
- Works with SQLAlchemy

**Installation:**
```bash
pip install alembic
```

**Initialize Alembic:**
```bash
# In project root
alembic init alembic

# This creates:
# alembic/
#   ├── env.py
#   ├── script.py.mako
#   └── versions/
# alembic.ini
```

### Migration 1: Initial Schema

**File:** `alembic/versions/001_initial_schema.py`

```python
"""Initial schema: users, api_keys, api_call_logs

Revision ID: 001
Revises:
Create Date: 2025-12-31 10:00:00
"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# Revision identifiers
revision = '001'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # Create users table
    op.create_table(
        'users',
        sa.Column('id', sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column('email', sa.String(length=255), nullable=False),
        sa.Column('password_hash', sa.String(length=255), nullable=False),
        sa.Column('full_name', sa.String(length=255), nullable=True),
        sa.Column('company', sa.String(length=255), nullable=True),
        sa.Column('status', sa.String(length=50), server_default='active', nullable=False),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('NOW()'), nullable=True),
        sa.Column('last_login_at', sa.TIMESTAMP(), nullable=True),
        sa.CheckConstraint("status IN ('active', 'inactive', 'suspended')", name='users_status_check'),
        sa.CheckConstraint("email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$'", name='users_email_format_check'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('email')
    )

    # Create indexes for users
    op.create_index('idx_users_email', 'users', ['email'])
    op.create_index('idx_users_status', 'users', ['status'])
    op.create_index('idx_users_created_at', 'users', [sa.text('created_at DESC')])

    # Create api_keys table
    op.create_table(
        'api_keys',
        sa.Column('id', sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column('user_id', sa.BigInteger(), nullable=False),
        sa.Column('key', sa.String(length=255), nullable=False),
        sa.Column('name', sa.String(length=100), nullable=True),
        sa.Column('status', sa.String(length=50), server_default='active', nullable=False),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('NOW()'), nullable=True),
        sa.Column('expires_at', sa.TIMESTAMP(), nullable=False),
        sa.Column('last_used_at', sa.TIMESTAMP(), nullable=True),
        sa.CheckConstraint("status IN ('active', 'expired', 'revoked')", name='api_keys_status_check'),
        sa.CheckConstraint("key ~* '^mk_live_[A-Za-z0-9]{24}$'", name='api_keys_key_format_check'),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('key')
    )

    # Create indexes for api_keys
    op.create_index('idx_api_keys_key', 'api_keys', ['key'])
    op.create_index('idx_api_keys_user_id', 'api_keys', ['user_id'])
    op.create_index('idx_api_keys_status', 'api_keys', ['status'])
    op.create_index('idx_api_keys_expires_at', 'api_keys', ['expires_at'])
    op.create_index('idx_api_keys_user_status', 'api_keys', ['user_id', 'status'])

    # Create api_call_logs table
    op.create_table(
        'api_call_logs',
        sa.Column('id', sa.BigInteger(), autoincrement=True, nullable=False),
        sa.Column('user_id', sa.BigInteger(), nullable=False),
        sa.Column('api_key', sa.String(length=255), nullable=False),
        sa.Column('endpoint', sa.String(length=255), nullable=False),
        sa.Column('method', sa.String(length=10), nullable=False),
        sa.Column('status_code', sa.Integer(), nullable=False),
        sa.Column('execution_time_ms', sa.Float(), nullable=True),
        sa.Column('error_message', sa.Text(), nullable=True),
        sa.Column('request_payload_hash', sa.String(length=64), nullable=True),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('NOW()'), nullable=True),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )

    # Create indexes for api_call_logs
    op.create_index('idx_api_call_logs_user_id', 'api_call_logs', ['user_id'])
    op.create_index('idx_api_call_logs_api_key', 'api_call_logs', ['api_key'])
    op.create_index('idx_api_call_logs_created_at', 'api_call_logs', [sa.text('created_at DESC')])
    op.create_index('idx_api_call_logs_status_code', 'api_call_logs', ['status_code'])
    op.create_index('idx_api_call_logs_user_created', 'api_call_logs', [sa.text('user_id, created_at DESC')])


def downgrade():
    # Drop tables in reverse order (due to foreign keys)
    op.drop_table('api_call_logs')
    op.drop_table('api_keys')
    op.drop_table('users')
```

### Run Migrations

```bash
# Apply migration (create tables)
alembic upgrade head

# Rollback migration (drop tables)
alembic downgrade -1

# Show current migration version
alembic current

# Show migration history
alembic history
```

---

## Database Setup

### Local Development Setup

**1. Install PostgreSQL:**

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib

# macOS (Homebrew)
brew install postgresql@15
brew services start postgresql@15

# Windows
# Download installer from: https://www.postgresql.org/download/windows/
```

**2. Create Database:**

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE monte_carlo_dev;

# Create user
CREATE USER monte_carlo_user WITH PASSWORD 'your_secure_password';

# Grant privileges
GRANT ALL PRIVILEGES ON DATABASE monte_carlo_dev TO monte_carlo_user;

# Exit psql
\q
```

**3. Configure Environment Variables:**

Create `.env` file:

```bash
# Database Configuration
DATABASE_URL=postgresql://monte_carlo_user:your_secure_password@localhost:5432/monte_carlo_dev

# For SQLAlchemy async
DATABASE_URL_ASYNC=postgresql+asyncpg://monte_carlo_user:your_secure_password@localhost:5432/monte_carlo_dev

# Database Pool Settings
DB_POOL_SIZE=10
DB_MAX_OVERFLOW=20
```

**4. Initialize Database with Alembic:**

```bash
# Install Python dependencies
pip install sqlalchemy asyncpg psycopg2-binary alembic

# Run migrations
alembic upgrade head

# Verify tables created
psql -U monte_carlo_user -d monte_carlo_dev -c "\dt"

# Expected output:
#               List of relations
#  Schema |     Name       | Type  |      Owner
# --------+----------------+-------+------------------
#  public | alembic_version| table | monte_carlo_user
#  public | api_call_logs  | table | monte_carlo_user
#  public | api_keys       | table | monte_carlo_user
#  public | users          | table | monte_carlo_user
```

**5. Seed Database with Sample Data:**

```bash
# Create seed script
cat > seed_data.sql << 'EOF'
-- Insert sample users
INSERT INTO users (email, password_hash, full_name, company, status) VALUES
('tony@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYk3H.PoIai', 'Tony Stark', 'Stark Industries', 'active'),
('bruce@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYk3H.PoIai', 'Bruce Wayne', 'Wayne Enterprises', 'active');

-- Insert sample API keys
INSERT INTO api_keys (user_id, key, name, created_at, expires_at, status) VALUES
(1, 'mk_live_abc123xyz789def456ghi012', 'Production Key', NOW(), NOW() + INTERVAL '30 days', 'active'),
(1, 'mk_live_xyz789abc123ghi456def012', 'Development Key', NOW(), NOW() + INTERVAL '30 days', 'active');
EOF

# Run seed script
psql -U monte_carlo_user -d monte_carlo_dev -f seed_data.sql
```

---

## Production Setup

### PostgreSQL Configuration for Production

**1. Recommended Cloud Providers:**

| Provider | Managed PostgreSQL | Cost (approx.) |
|----------|-------------------|----------------|
| AWS | RDS for PostgreSQL | $20-100/month |
| Google Cloud | Cloud SQL | $20-100/month |
| Azure | Azure Database for PostgreSQL | $20-100/month |
| DigitalOcean | Managed PostgreSQL | $15-60/month |
| Supabase | PostgreSQL (with free tier) | $0-25/month |

**Recommendation for MVP:** DigitalOcean or Supabase (easiest setup, good pricing)

**2. Production Database Configuration:**

```bash
# .env.production
DATABASE_URL=postgresql://user:password@production-host:5432/monte_carlo_prod
DATABASE_URL_ASYNC=postgresql+asyncpg://user:password@production-host:5432/monte_carlo_prod

# Connection Pool Settings (for production load)
DB_POOL_SIZE=20
DB_MAX_OVERFLOW=40
DB_POOL_TIMEOUT=30
DB_POOL_RECYCLE=3600

# SSL Mode (required for production)
DB_SSL_MODE=require
```

**3. Database Security Checklist:**

```
✅ Enable SSL/TLS for connections
✅ Use strong passwords (minimum 32 characters)
✅ Restrict database access by IP whitelist
✅ Enable database firewall rules
✅ Use environment variables (never hardcode credentials)
✅ Enable automated backups (daily minimum)
✅ Enable point-in-time recovery (PITR)
✅ Monitor database performance (CPU, memory, disk)
✅ Set up alerts for database issues
```

---

## Scalability Considerations

### Performance at Scale

**Expected Load (MVP):**
- Users: 100-1,000
- API Keys: 200-2,000 (minimum 2 per user)
- API Calls: 10,000-100,000/day
- Database Size: < 1 GB

**Current Schema Performance:**
- ✅ Can handle 100,000+ users
- ✅ Can handle 1,000,000+ API keys
- ✅ Can handle 10,000,000+ API call logs
- ✅ Query performance: < 10ms for all queries

### Optimization Strategies (Future)

**1. Partitioning `api_call_logs` by Date:**

```sql
-- When api_call_logs > 10 million rows, partition by month
CREATE TABLE api_call_logs_2026_01 PARTITION OF api_call_logs
FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

CREATE TABLE api_call_logs_2026_02 PARTITION OF api_call_logs
FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');

-- Benefits:
-- ✅ Faster queries (query only relevant partition)
-- ✅ Easier archival (drop old partitions)
-- ✅ Better performance for time-range queries
```

**2. Read Replicas (for dashboard analytics):**

```
┌─────────────────┐
│  Primary DB     │ ← Write operations (API key generation, user signup)
│  (Master)       │
└────────┬────────┘
         │ Replication
         ├──────────────┬──────────────┐
         ▼              ▼              ▼
    ┌─────────┐   ┌─────────┐   ┌─────────┐
    │ Replica │   │ Replica │   │ Replica │ ← Read operations (dashboard queries)
    │    1    │   │    2    │   │    3    │
    └─────────┘   └─────────┘   └─────────┘

Benefits:
✅ Distribute read load across replicas
✅ Primary DB only handles writes (faster)
✅ Dashboard queries don't slow down API key validation
```

**3. Connection Pooling (PgBouncer):**

```
┌─────────────────────────────────────────────────────────┐
│               FastAPI Application (100 workers)          │
└────────────────────────┬────────────────────────────────┘
                         │ 100 connections
                         ▼
                  ┌──────────────┐
                  │  PgBouncer   │ ← Connection pooler
                  │  (Pool: 20)  │
                  └──────┬───────┘
                         │ 20 connections
                         ▼
                  ┌──────────────┐
                  │  PostgreSQL  │
                  └──────────────┘

Benefits:
✅ Reduces database connections (from 100 to 20)
✅ Faster connection reuse
✅ Lower database memory usage
```

**4. Archival Strategy (Old API Call Logs):**

```sql
-- Move logs older than 90 days to archive table
CREATE TABLE api_call_logs_archive AS
SELECT * FROM api_call_logs WHERE created_at < NOW() - INTERVAL '90 days';

DELETE FROM api_call_logs WHERE created_at < NOW() - INTERVAL '90 days';

-- Or export to S3/Google Cloud Storage for long-term storage
```

---

## Summary

### Database Schema Overview

```
3 Tables Total:
1. users          - User accounts (email, password, status)
2. api_keys       - API keys with 30-day expiry
3. api_call_logs  - Usage tracking

Performance:
- All queries < 10ms (with indexes)
- Can handle 100,000+ users
- Can handle 10,000,000+ API calls

Security:
- Foreign key constraints (referential integrity)
- Check constraints (data validation)
- Bcrypt password hashing (12 rounds)
- API key format validation
- Soft deletes (audit trail)
```

### Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| PostgreSQL over MySQL | Better data integrity, ACID compliance |
| Separate `api_call_logs` table | Better performance, easier analytics |
| Store `user_id` in logs | Avoid JOIN on every query |
| 30-day expiry in `expires_at` | Simple timestamp comparison (no cron needed) |
| Soft deletes (`status` field) | Audit trail, can reactivate |
| Bcrypt hashing | Industry standard, slow by design (anti-brute-force) |
| BIGSERIAL for IDs | Support 9 quintillion rows (future-proof) |

### Next Steps

1. ✅ Read this document (DATABASE_SCHEMA.md)
2. ⏭️ Read SAAS_IMPLEMENTATION_GUIDE.md (code implementation)
3. ⏭️ Read API_DOCUMENTATION.md (public API docs)
4. ⏭️ Set up local PostgreSQL database
5. ⏭️ Run Alembic migrations
6. ⏭️ Seed database with sample data
7. ⏭️ Start implementation!

---

**Document Version:** 1.0 (SaaS MVP)
**Last Updated:** December 31, 2025
**Next Document:** SAAS_IMPLEMENTATION_GUIDE.md
**Author:** Friday (AI Assistant for Tony)
