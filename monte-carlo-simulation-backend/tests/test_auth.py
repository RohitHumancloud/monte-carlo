"""
Authentication API Tests
Test user registration, login, and JWT token validation
"""

import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.pool import NullPool

from app.main import app
from app.database import Base, get_db
from app.config import settings

# Test database URL (use separate test database)
TEST_DATABASE_URL = settings.DATABASE_URL_ASYNC.replace("monte_carlo_dev", "monte_carlo_test")

# Create test engine
test_engine = create_async_engine(
    TEST_DATABASE_URL,
    poolclass=NullPool,
    echo=False  # Set to True for SQL query debugging
)

# Create test session factory
TestSessionLocal = async_sessionmaker(
    test_engine,
    class_=AsyncSession,
    expire_on_commit=False
)


# Fixtures
@pytest.fixture(scope="function")
async def db_session():
    """
    Create test database tables and provide a database session

    Scope: function - creates fresh database for each test
    """
    # Create all tables
    async with test_engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    # Provide session
    async with TestSessionLocal() as session:
        yield session

    # Drop all tables after test
    async with test_engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)


@pytest.fixture(scope="function")
async def client(db_session):
    """
    Create test client with database dependency override
    """
    async def override_get_db():
        yield db_session

    app.dependency_overrides[get_db] = override_get_db

    async with AsyncClient(app=app, base_url="http://test") as ac:
        yield ac

    app.dependency_overrides.clear()


# Test Data
valid_user = {
    "email": "test@example.com",
    "password": "SecurePass123",
    "full_name": "Test User",
    "company": "Test Corp"
}

invalid_password_user = {
    "email": "weak@example.com",
    "password": "weak",  # Too short, no uppercase/digit
    "full_name": "Weak User"
}


# ============================================================================
# USER REGISTRATION TESTS
# ============================================================================

@pytest.mark.asyncio
async def test_register_success(client: AsyncClient):
    """
    Test successful user registration

    Expected:
    - Status 201 Created
    - Returns user details (without password)
    - Email matches input
    """
    response = await client.post("/auth/register", json=valid_user)

    assert response.status_code == 201
    data = response.json()

    assert "id" in data
    assert data["email"] == valid_user["email"]
    assert data["full_name"] == valid_user["full_name"]
    assert data["company"] == valid_user["company"]
    assert data["status"] == "active"
    assert "password" not in data
    assert "password_hash" not in data
    assert "created_at" in data


@pytest.mark.asyncio
async def test_register_duplicate_email(client: AsyncClient):
    """
    Test registration with duplicate email

    Expected:
    - First registration succeeds
    - Second registration fails with 400
    - Error message indicates email already exists
    """
    # First registration
    response1 = await client.post("/auth/register", json=valid_user)
    assert response1.status_code == 201

    # Duplicate registration
    response2 = await client.post("/auth/register", json=valid_user)
    assert response2.status_code == 400
    assert "already registered" in response2.json()["detail"].lower()


@pytest.mark.asyncio
async def test_register_invalid_password(client: AsyncClient):
    """
    Test registration with invalid password

    Expected:
    - Status 422 Unprocessable Entity (Pydantic validation error)
    - Error details include password requirements
    """
    response = await client.post("/auth/register", json=invalid_password_user)

    assert response.status_code == 422
    # Pydantic validation error


@pytest.mark.asyncio
async def test_register_missing_fields(client: AsyncClient):
    """
    Test registration with missing required fields

    Expected:
    - Status 422 Unprocessable Entity
    """
    incomplete_user = {"email": "incomplete@example.com"}
    response = await client.post("/auth/register", json=incomplete_user)

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_register_invalid_email(client: AsyncClient):
    """
    Test registration with invalid email format

    Expected:
    - Status 422 Unprocessable Entity (Pydantic email validation)
    """
    invalid_email_user = {
        "email": "not-an-email",
        "password": "SecurePass123",
        "full_name": "Test User"
    }
    response = await client.post("/auth/register", json=invalid_email_user)

    assert response.status_code == 422


# ============================================================================
# USER LOGIN TESTS
# ============================================================================

@pytest.mark.asyncio
async def test_login_success(client: AsyncClient):
    """
    Test successful user login

    Expected:
    - Status 200 OK
    - Returns JWT access token
    - Token type is "bearer"
    """
    # Register user first
    await client.post("/auth/register", json=valid_user)

    # Login
    login_data = {
        "email": valid_user["email"],
        "password": valid_user["password"]
    }
    response = await client.post("/auth/login", json=login_data)

    assert response.status_code == 200
    data = response.json()

    assert "access_token" in data
    assert "token_type" in data
    assert data["token_type"] == "bearer"
    assert len(data["access_token"]) > 50  # JWT tokens are long


@pytest.mark.asyncio
async def test_login_wrong_password(client: AsyncClient):
    """
    Test login with incorrect password

    Expected:
    - Status 401 Unauthorized
    - Error message indicates invalid credentials
    """
    # Register user
    await client.post("/auth/register", json=valid_user)

    # Login with wrong password
    login_data = {
        "email": valid_user["email"],
        "password": "WrongPassword123"
    }
    response = await client.post("/auth/login", json=login_data)

    assert response.status_code == 401
    assert "invalid" in response.json()["detail"].lower()


@pytest.mark.asyncio
async def test_login_nonexistent_user(client: AsyncClient):
    """
    Test login with non-existent email

    Expected:
    - Status 401 Unauthorized
    - Error message indicates invalid credentials
    """
    login_data = {
        "email": "nonexistent@example.com",
        "password": "AnyPassword123"
    }
    response = await client.post("/auth/login", json=login_data)

    assert response.status_code == 401


# ============================================================================
# PROTECTED ENDPOINT TESTS
# ============================================================================

@pytest.mark.asyncio
async def test_get_current_user_success(client: AsyncClient):
    """
    Test accessing protected endpoint with valid JWT token

    Expected:
    - Status 200 OK
    - Returns current user details
    """
    # Register and login
    await client.post("/auth/register", json=valid_user)
    login_response = await client.post(
        "/auth/login",
        json={"email": valid_user["email"], "password": valid_user["password"]}
    )
    token = login_response.json()["access_token"]

    # Access protected endpoint
    response = await client.get(
        "/auth/me",
        headers={"Authorization": f"Bearer {token}"}
    )

    assert response.status_code == 200
    data = response.json()
    assert data["email"] == valid_user["email"]


@pytest.mark.asyncio
async def test_get_current_user_no_token(client: AsyncClient):
    """
    Test accessing protected endpoint without token

    Expected:
    - Status 401 Unauthorized or 403 Forbidden
    """
    response = await client.get("/auth/me")

    assert response.status_code in [401, 403]


@pytest.mark.asyncio
async def test_get_current_user_invalid_token(client: AsyncClient):
    """
    Test accessing protected endpoint with invalid token

    Expected:
    - Status 401 Unauthorized
    """
    response = await client.get(
        "/auth/me",
        headers={"Authorization": "Bearer invalid_token_here"}
    )

    assert response.status_code == 401


# ============================================================================
# PASSWORD VALIDATION TESTS
# ============================================================================

@pytest.mark.asyncio
async def test_password_too_short(client: AsyncClient):
    """Test password minimum length requirement (8 characters)"""
    user = {
        "email": "short@example.com",
        "password": "Short1",  # Only 6 characters
        "full_name": "Test User"
    }
    response = await client.post("/auth/register", json=user)
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_password_no_uppercase(client: AsyncClient):
    """Test password uppercase requirement"""
    user = {
        "email": "nouppercase@example.com",
        "password": "lowercase123",  # No uppercase
        "full_name": "Test User"
    }
    response = await client.post("/auth/register", json=user)
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_password_no_lowercase(client: AsyncClient):
    """Test password lowercase requirement"""
    user = {
        "email": "nolowercase@example.com",
        "password": "UPPERCASE123",  # No lowercase
        "full_name": "Test User"
    }
    response = await client.post("/auth/register", json=user)
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_password_no_digit(client: AsyncClient):
    """Test password digit requirement"""
    user = {
        "email": "nodigit@example.com",
        "password": "NoDigitPassword",  # No digit
        "full_name": "Test User"
    }
    response = await client.post("/auth/register", json=user)
    assert response.status_code == 422


# ============================================================================
# RUN TESTS
# ============================================================================

if __name__ == "__main__":
    # Run tests with: pytest tests/test_auth.py -v
    # Run with coverage: pytest tests/test_auth.py -v --cov=app --cov-report=html
    pytest.main([__file__, "-v", "--asyncio-mode=auto"])
