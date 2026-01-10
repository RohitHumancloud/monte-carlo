"""
Security Utilities
Functions for password hashing, JWT token management, and API key generation
"""

from passlib.context import CryptContext
from datetime import datetime, timedelta, timezone
from jose import jwt, JWTError
from app.config import settings
import secrets
import string
from typing import Dict, Optional

# ============================================
# Password Hashing Configuration
# ============================================
pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
    bcrypt__rounds=settings.BCRYPT_ROUNDS  # Default: 12 rounds
)


# ============================================
# Password Functions
# ============================================
def hash_password(password: str) -> str:
    """
    Hash password using bcrypt (12 rounds by default)

    Args:
        password: Plain text password

    Returns:
        Hashed password string (60 chars for bcrypt)

    Example:
        >>> hashed = hash_password("SecurePass123")
        >>> len(hashed)
        60
    """
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Verify password against hash

    Args:
        plain_password: Plain text password
        hashed_password: Bcrypt hashed password

    Returns:
        True if password matches, False otherwise

    Example:
        >>> hashed = hash_password("SecurePass123")
        >>> verify_password("SecurePass123", hashed)
        True
        >>> verify_password("WrongPassword", hashed)
        False
    """
    return pwd_context.verify(plain_password, hashed_password)


# ============================================
# JWT Token Functions
# ============================================
def create_access_token(data: Dict, expires_delta: Optional[timedelta] = None) -> str:
    """
    Create JWT access token

    Args:
        data: Dictionary with user_id and email
        expires_delta: Token expiration time (default: 24 hours from settings)

    Returns:
        JWT token string

    Example:
        >>> token = create_access_token({"user_id": 123, "email": "user@example.com"})
        >>> len(token) > 100
        True
    """
    to_encode = data.copy()

    # Set expiration time
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(hours=settings.JWT_EXPIRATION_HOURS)

    to_encode.update({"exp": expire})

    # Encode JWT
    encoded_jwt = jwt.encode(
        to_encode,
        settings.JWT_SECRET_KEY,
        algorithm=settings.JWT_ALGORITHM
    )

    return encoded_jwt


def verify_access_token(token: str) -> Dict:
    """
    Verify and decode JWT token

    Args:
        token: JWT token string

    Returns:
        Decoded token payload (dict with user_id, email, exp)

    Raises:
        JWTError: If token is invalid or expired

    Example:
        >>> token = create_access_token({"user_id": 123, "email": "user@example.com"})
        >>> payload = verify_access_token(token)
        >>> payload["user_id"]
        123
    """
    try:
        payload = jwt.decode(
            token,
            settings.JWT_SECRET_KEY,
            algorithms=[settings.JWT_ALGORITHM]
        )
        return payload
    except JWTError as e:
        raise JWTError(f"Invalid or expired token: {str(e)}")


# ============================================
# API Key Generation
# ============================================
def generate_api_key() -> str:
    """
    Generate secure API key in format: mk_live_XXXXXXXXXXXXXXXXXXXXXXXX

    Format:
        - Prefix: "mk_live_" (8 chars)
        - Random: 24 alphanumeric characters (base62: a-zA-Z0-9)
        - Total length: 32 characters

    Security:
        - Uses secrets module (cryptographically strong random)
        - Base62 alphabet (62^24 ≈ 1.3 × 10^43 combinations)
        - No special characters (URL-safe)

    Returns:
        API key string (32 chars)

    Example:
        >>> key = generate_api_key()
        >>> key.startswith("mk_live_")
        True
        >>> len(key)
        32
    """
    # Base62 alphabet (URL-safe, no special characters)
    alphabet = string.ascii_letters + string.digits  # a-zA-Z0-9

    # Generate random string
    random_part = ''.join(
        secrets.choice(alphabet)
        for _ in range(settings.API_KEY_LENGTH)
    )

    # Combine prefix with random part
    api_key = f"{settings.API_KEY_PREFIX}{random_part}"

    return api_key


# ============================================
# Additional Security Utilities
# ============================================
def hash_request_payload(payload: str) -> str:
    """
    Create SHA-256 hash of request payload for logging

    Args:
        payload: JSON string of request payload

    Returns:
        SHA-256 hash (64 chars hex)

    Note:
        Used for audit logging without storing sensitive data
    """
    import hashlib
    return hashlib.sha256(payload.encode()).hexdigest()


def is_token_expired(token: str) -> bool:
    """
    Check if JWT token is expired without raising exception

    Args:
        token: JWT token string

    Returns:
        True if expired, False if valid
    """
    try:
        payload = verify_access_token(token)
        exp_timestamp = payload.get("exp")
        if not exp_timestamp:
            return True
        exp_datetime = datetime.fromtimestamp(exp_timestamp, tz=timezone.utc)
        return datetime.now(timezone.utc) > exp_datetime
    except JWTError:
        return True
