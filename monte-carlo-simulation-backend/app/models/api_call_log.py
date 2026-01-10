"""
API Call Log Model
Tracks all API calls for usage monitoring and analytics
"""

from sqlalchemy import Column, BigInteger, String, Integer, Float, Text, TIMESTAMP, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base


class ApiCallLog(Base):
    """
    API Call Log model for tracking API usage

    Relationships:
        - user: Many-to-one relationship with User

    Business Rules:
        - Logs all simulation API calls
        - Tracks execution time for performance monitoring
        - Stores request payload hash (not full payload for privacy)
        - Used for billing and usage analytics
    """

    __tablename__ = "api_call_logs"

    # ============================================
    # Primary Key
    # ============================================
    id = Column(BigInteger, primary_key=True, autoincrement=True)

    # ============================================
    # Foreign Key
    # ============================================
    user_id = Column(
        BigInteger,
        ForeignKey('users.id', ondelete='CASCADE'),
        nullable=False,
        index=True,
        comment="User who made the API call"
    )

    # ============================================
    # Request Details
    # ============================================
    api_key = Column(
        String(255),
        nullable=False,
        index=True,
        comment="API key used for this request"
    )

    endpoint = Column(
        String(255),
        nullable=False,
        comment="API endpoint path (e.g., /api/v1/simulate)"
    )

    method = Column(
        String(10),
        nullable=False,
        comment="HTTP method (GET, POST, etc.)"
    )

    # ============================================
    # Response Details
    # ============================================
    status_code = Column(
        Integer,
        nullable=False,
        index=True,
        comment="HTTP status code (200, 400, 500, etc.)"
    )

    execution_time_ms = Column(
        Float,
        nullable=True,
        comment="Request execution time in milliseconds"
    )

    error_message = Column(
        Text,
        nullable=True,
        comment="Error message if request failed"
    )

    # ============================================
    # Security & Compliance
    # ============================================
    request_payload_hash = Column(
        String(64),
        nullable=True,
        comment="SHA-256 hash of request payload (for auditing)"
    )

    # ============================================
    # Timestamp
    # ============================================
    created_at = Column(
        TIMESTAMP,
        nullable=False,
        server_default=func.now(),
        index=True,
        comment="Timestamp of the API call"
    )

    # ============================================
    # Relationships
    # ============================================
    user = relationship("User", back_populates="api_call_logs")

    def __repr__(self):
        return (
            f"<ApiCallLog(id={self.id}, endpoint={self.endpoint}, "
            f"status={self.status_code}, time={self.execution_time_ms}ms)>"
        )

    @property
    def is_successful(self) -> bool:
        """Check if API call was successful (status code 2xx)"""
        return 200 <= self.status_code < 300

    @property
    def is_client_error(self) -> bool:
        """Check if API call resulted in client error (status code 4xx)"""
        return 400 <= self.status_code < 500

    @property
    def is_server_error(self) -> bool:
        """Check if API call resulted in server error (status code 5xx)"""
        return self.status_code >= 500
