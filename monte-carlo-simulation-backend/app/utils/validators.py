"""
Validation Utilities
Functions for validating email addresses, API keys, and other inputs
"""

import re
from typing import Optional


def validate_email(email: str) -> bool:
    """
    Validate email address format

    Args:
        email: Email address string

    Returns:
        True if valid email format, False otherwise

    Example:
        >>> validate_email("user@example.com")
        True
        >>> validate_email("invalid-email")
        False
        >>> validate_email("user@")
        False
    """
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(pattern, email) is not None


def validate_api_key_format(key: str) -> bool:
    """
    Validate API key format: mk_live_XXXXXXXXXXXXXXXXXXXXXXXX

    Format Requirements:
        - Starts with "mk_live_"
        - Followed by exactly 24 alphanumeric characters
        - Total length: 32 characters
        - Only letters (a-z, A-Z) and digits (0-9)

    Args:
        key: API key string

    Returns:
        True if valid format, False otherwise

    Example:
        >>> validate_api_key_format("mk_live_aB3cD4eF5gH6iJ7kL8mN9oP")
        True
        >>> validate_api_key_format("invalid_key")
        False
        >>> validate_api_key_format("mk_live_short")
        False
    """
    pattern = r'^mk_live_[A-Za-z0-9]{24}$'
    return re.match(pattern, key) is not None


def validate_password_strength(password: str) -> tuple[bool, Optional[str]]:
    """
    Validate password strength

    Requirements:
        - Minimum 8 characters
        - At least one uppercase letter
        - At least one lowercase letter
        - At least one digit

    Args:
        password: Password string

    Returns:
        Tuple of (is_valid, error_message)

    Example:
        >>> validate_password_strength("SecurePass123")
        (True, None)
        >>> validate_password_strength("weak")
        (False, "Password must be at least 8 characters long")
        >>> validate_password_strength("nodigits")
        (False, "Password must contain at least one digit")
    """
    if len(password) < 8:
        return False, "Password must be at least 8 characters long"

    if not any(c.isupper() for c in password):
        return False, "Password must contain at least one uppercase letter"

    if not any(c.islower() for c in password):
        return False, "Password must contain at least one lowercase letter"

    if not any(c.isdigit() for c in password):
        return False, "Password must contain at least one digit"

    return True, None


def validate_ticker(ticker: str) -> bool:
    """
    Validate Bloomberg ticker format

    Args:
        ticker: Ticker string

    Returns:
        True if valid ticker format

    Example:
        >>> validate_ticker("NSEI Index")
        True
        >>> validate_ticker("AAPL US Equity")
        True
        >>> validate_ticker("")
        False
    """
    if not ticker or len(ticker.strip()) == 0:
        return False

    # Tickers should be alphanumeric with spaces allowed
    pattern = r'^[A-Za-z0-9\s]+$'
    return re.match(pattern, ticker) is not None


def validate_portfolio_weights(weights: list[float]) -> tuple[bool, Optional[str]]:
    """
    Validate portfolio weights sum to 1.0

    Args:
        weights: List of weight values

    Returns:
        Tuple of (is_valid, error_message)

    Example:
        >>> validate_portfolio_weights([0.6, 0.4])
        (True, None)
        >>> validate_portfolio_weights([0.5, 0.6])
        (False, "Weights sum to 1.1000, must equal 1.0")
    """
    total = sum(weights)

    # Allow 1% tolerance for floating point precision
    if not (0.99 <= total <= 1.01):
        return False, f"Weights sum to {total:.4f}, must equal 1.0"

    # Check all weights are non-negative
    if any(w < 0 for w in weights):
        return False, "All weights must be non-negative"

    # Check all weights are <= 1
    if any(w > 1 for w in weights):
        return False, "No single weight can exceed 1.0"

    return True, None
