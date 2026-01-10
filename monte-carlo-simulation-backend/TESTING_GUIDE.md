# 🧪 Complete Testing Guide for Monte Carlo Simulation API

## ⚠️ Python Version Compatibility Note

**Recommended**: Python 3.11 or 3.12 (Python 3.13 has package compatibility issues)

If you're using Python 3.13, consider using Python 3.11:
```bash
# Download Python 3.11 from https://www.python.org/downloads/
# Or use pyenv/conda to manage multiple versions
```

---

## 📋 Quick Start Testing Checklist

- [ ] 1. Configure `.env` file
- [ ] 2. Setup PostgreSQL databases
- [ ] 3. Install Python dependencies
- [ ] 4. Run database migrations
- [ ] 5. Start the application
- [ ] 6. Run automated tests
- [ ] 7. Test API endpoints manually

---

## Step 1: Configure Environment (.env file)

1. **Copy environment template:**
   ```bash
   cp .env.example .env
   ```

2. **Update `.env` file with these settings:**
   ```env
   # Database (use password you set)
   DATABASE_URL=postgresql://monte_carlo_user:monte_carlo_pass@localhost:5432/monte_carlo_dev
   DATABASE_URL_ASYNC=postgresql+asyncpg://monte_carlo_user:monte_carlo_pass@localhost:5432/monte_carlo_dev

   # JWT Secret (generated with: openssl rand -hex 32)
   JWT_SECRET_KEY=c2db906e491a520142125fb5376e089ed6a7dabc2e88e186a136e94d60d8d5be

   # API Key Configuration
   API_KEY_PREFIX=mk_live_
   API_KEY_LENGTH=24
   API_KEY_EXPIRY_DAYS=30

   # CORS
   CORS_ORIGINS=http://localhost:3000,http://localhost:8080
   ```

---

## Step 2: Setup PostgreSQL Databases

### Option A: Using psql Command Line
```bash
# Connect to PostgreSQL
psql -U postgres

# Run these SQL commands:
CREATE DATABASE monte_carlo_dev;
CREATE DATABASE monte_carlo_test;
CREATE USER monte_carlo_user WITH PASSWORD 'monte_carlo_pass';
GRANT ALL PRIVILEGES ON DATABASE monte_carlo_dev TO monte_carlo_user;
GRANT ALL PRIVILEGES ON DATABASE monte_carlo_test TO monte_carlo_user;
\q
```

### Option B: Using SQL Script
```bash
psql -U postgres -f setup_database.sql
```

### Verify Database Creation
```bash
psql -U postgres -c "\l" | grep monte_carlo
```

---

## Step 3: Install Python Dependencies

### Recommended: Use Virtual Environment
```bash
# Create virtual environment
python -m venv venv

# Activate (Windows)
venv\Scripts\activate

# Activate (Linux/Mac)
source venv/bin/activate

# Upgrade pip
python -m pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt
```

### If Installation Fails (Python 3.13 issues):
Try installing packages individually or use Python 3.11:
```bash
# Core packages first
pip install fastapi uvicorn[standard] python-dotenv pydantic pydantic-settings
pip install sqlalchemy asyncpg psycopg2-binary alembic
pip install python-jose[cryptography] passlib bcrypt

# Scientific packages (may need Visual Studio Build Tools on Windows)
pip install numpy scipy numba pandas

# Testing packages
pip install pytest pytest-asyncio httpx
```

---

## Step 4: Run Database Migrations

```bash
# Check current migration status
alembic current

# Run migrations to create tables
alembic upgrade head

# Verify tables were created
psql -U monte_carlo_user -d monte_carlo_dev -c "\dt"

# You should see:
# - users
# - api_keys
# - api_call_logs
```

---

## Step 5: Start the Application

### Development Mode (with auto-reload)
```bash
# Method 1: Using uvicorn directly
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Method 2: Using Python module
python -m uvicorn app.main:app --reload --port 8000

# Method 3: Run main.py directly
python -m app.main
```

### Verify Application is Running
Open your browser:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

Expected response:
```json
{
  "status": "healthy",
  "service": "Monte Carlo Simulation",
  "version": "1.0.0",
  "timestamp": "2026-01-10T...",
  "components": {
    "api": "operational",
    "database": "operational"
  }
}
```

---

## Step 6: Run Automated Tests

### Setup Test Database
```bash
psql -U postgres -c "CREATE DATABASE monte_carlo_test;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE monte_carlo_test TO monte_carlo_user;"
```

### Run All Tests
```bash
# Run all tests with verbose output
pytest tests/ -v

# Run specific test file
pytest tests/test_auth.py -v

# Run with coverage report
pytest tests/ -v --cov=app --cov-report=html

# View coverage report
open htmlcov/index.html  # Mac/Linux
start htmlcov/index.html  # Windows
```

### Expected Test Results
```
tests/test_auth.py::test_register_success PASSED
tests/test_auth.py::test_register_duplicate_email PASSED
tests/test_auth.py::test_login_success PASSED
tests/test_auth.py::test_login_wrong_password PASSED
tests/test_auth.py::test_get_current_user_success PASSED
... (more tests)

============= XX passed in X.XXs =============
```

---

## Step 7: Manual API Testing

### Option A: Using curl Commands

#### 1. **Register a User**
```bash
curl -X POST http://localhost:8000/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123",
    "full_name": "Test User",
    "company": "Test Corp"
  }'
```

**Expected Response (201 Created):**
```json
{
  "id": 1,
  "email": "test@example.com",
  "full_name": "Test User",
  "company": "Test Corp",
  "status": "active",
  "created_at": "2026-01-10T..."
}
```

#### 2. **Login to Get JWT Token**
```bash
curl -X POST http://localhost:8000/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123"
  }'
```

**Expected Response (200 OK):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

**📝 Save this token! You'll need it for subsequent requests.**

#### 3. **Get Current User (Protected Endpoint)**
```bash
# Replace <YOUR_JWT_TOKEN> with the token from login
curl -X GET http://localhost:8000/auth/me \
  -H "Authorization: Bearer <YOUR_JWT_TOKEN>"
```

#### 4. **Generate API Key**
```bash
curl -X POST http://localhost:8000/api-keys/generate \
  -H "Authorization: Bearer <YOUR_JWT_TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test API Key"
  }'
```

**Expected Response:**
```json
{
  "id": 1,
  "user_id": 1,
  "key": "mk_live_aB3cD4eF5gH6iJ7kL8mN9oP",
  "name": "Test API Key",
  "status": "active",
  "expires_at": "2026-02-09T...",
  "days_until_expiry": 30
}
```

**⚠️ IMPORTANT: Copy and save the API key! It's only shown once!**

#### 5. **List API Keys**
```bash
curl -X GET http://localhost:8000/api-keys/list \
  -H "Authorization: Bearer <YOUR_JWT_TOKEN>"
```

#### 6. **Run Monte Carlo Simulation**
```bash
# Replace <YOUR_API_KEY> with the key from step 4
curl -X POST http://localhost:8000/api/v1/simulate \
  -H "X-API-Key: <YOUR_API_KEY>" \
  -H "Content-Type: application/json" \
  -d '{
    "portfolio": {
      "assets": [
        {
          "ticker": "NSEI Index",
          "weight": 0.6,
          "asset_class": "equity"
        },
        {
          "ticker": "GIND10YR Index",
          "weight": 0.4,
          "asset_class": "bonds"
        }
      ]
    },
    "parameters": {
      "initial_investment": 1000000,
      "monthly_contribution": 50000,
      "time_horizon_years": 10,
      "num_simulations": 10000
    }
  }'
```

**Expected Response:**
```json
{
  "simulation_id": "sim_xxxxxxxxxxxx",
  "status": "completed",
  "execution_time_seconds": 4.523,
  "results": {
    "final_portfolio_value": {
      "mean": 12500000,
      "median": 11800000,
      "std_deviation": 2300000,
      "min": 7500000,
      "max": 25000000,
      "percentiles": {
        "p5": 8900000,
        "p25": 10200000,
        "p50": 11800000,
        "p75": 14200000,
        "p95": 17800000,
        "p99": 19500000
      }
    },
    "risk_metrics": {
      "var_95": 8900000,
      "var_99": 7800000,
      "cvar_95": 8200000,
      "cvar_99": 7500000,
      "sharpe_ratio": 1.45,
      "volatility": 0.184
    },
    "probabilities": {
      "probability_of_loss": 0.08,
      "probability_of_positive_return": 0.92,
      "probability_of_doubling": 0.65
    },
    "sample_paths": [[...], [...], [...]]
  }
}
```

### Option B: Using Postman

1. **Import Collection**: Create a new Postman collection
2. **Set Environment Variables**:
   - `base_url`: http://localhost:8000
   - `jwt_token`: (will be set after login)
   - `api_key`: (will be set after generation)

3. **Create Requests** using the curl examples above

### Option C: Using Swagger UI

1. Open http://localhost:8000/docs
2. Click on any endpoint
3. Click "Try it out"
4. Fill in the parameters
5. Click "Execute"

**For protected endpoints:**
1. Click "Authorize" button (top right)
2. Enter: `Bearer <YOUR_JWT_TOKEN>`
3. Click "Authorize"
4. Now you can test protected endpoints

---

## 📊 Testing Scenarios

### Scenario 1: Complete User Flow
1. ✅ Register new user
2. ✅ Login and get JWT token
3. ✅ Access protected endpoint (/auth/me)
4. ✅ Generate 2 API keys
5. ✅ List API keys (should see masked keys)
6. ✅ Run simulation with API key
7. ✅ Try to revoke a key (should fail - minimum 2 keys required)
8. ✅ Generate 3rd key
9. ✅ Revoke one key successfully

### Scenario 2: Error Handling
1. ❌ Register with weak password (should fail)
2. ❌ Register with duplicate email (should fail)
3. ❌ Login with wrong password (401)
4. ❌ Access protected endpoint without token (401)
5. ❌ Use expired/invalid API key (401)
6. ❌ Generate 11th API key (should fail - max 10)
7. ❌ Simulation with invalid portfolio weights (should fail)

### Scenario 3: Performance Testing
1. Run simulation with 10,000 paths (should complete in ~3-5 seconds)
2. Run simulation with 50,000 paths (should complete in ~15-25 seconds)
3. Check X-Process-Time header in response

---

## 🐛 Troubleshooting

### Database Connection Error
```
Error: asyncpg.exceptions.InvalidCatalogNameError
```
**Solution:** Create the database:
```bash
psql -U postgres -c "CREATE DATABASE monte_carlo_dev;"
```

### JWT Token Invalid
```
Error: HTTPException 401: Could not validate credentials
```
**Solution:**
- Check JWT_SECRET_KEY in .env matches
- Token may have expired (24-hour default)
- Ensure `Authorization: Bearer <token>` format

### Import Errors
```
Error: ModuleNotFoundError: No module named 'app'
```
**Solution:**
```bash
# Ensure you're in project root
cd monte-carlo-simulation-backend

# Reinstall dependencies
pip install -r requirements.txt
```

### Port Already in Use
```
Error: OSError: [Errno 48] Address already in use
```
**Solution:**
```bash
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8000
kill -9 <PID>
```

---

## ✅ Test Results Checklist

Mark these off as you test:

**Authentication:**
- [ ] User registration works
- [ ] Login returns JWT token
- [ ] Protected endpoints require valid token
- [ ] Password validation enforces rules

**API Key Management:**
- [ ] Can generate API keys
- [ ] Keys are masked in list view
- [ ] Can revoke keys (with 2-key minimum)
- [ ] Maximum 10 active keys enforced
- [ ] 30-day expiry works

**Monte Carlo Simulation:**
- [ ] Simulation completes successfully
- [ ] Results include all metrics (VaR, CVaR, Sharpe, etc.)
- [ ] Performance is acceptable (<5s for 10k paths)
- [ ] API call is logged in database

**Database:**
- [ ] Migrations create all tables
- [ ] Foreign key relationships work
- [ ] Indexes are created

---

## 📈 Next Steps

1. **Add More Tests**: Create tests for API key management, simulation
2. **Load Testing**: Use tools like Apache Bench, Locust, or k6
3. **Security Audit**: Test for SQL injection, XSS, etc.
4. **Performance Profiling**: Use Python profilers to optimize
5. **CI/CD Setup**: Automate testing with GitHub Actions

---

**Happy Testing! 🚀**
