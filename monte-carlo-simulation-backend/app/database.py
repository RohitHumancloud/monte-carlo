"""
Database Configuration
Async PostgreSQL connection using SQLAlchemy 2.0
"""

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import declarative_base
from app.config import settings
import logging

logger = logging.getLogger(__name__)

# ============================================
# Create Async SQLAlchemy Engine
# ============================================
engine = create_async_engine(
    settings.DATABASE_URL_ASYNC,
    echo=settings.DEBUG,  # Log SQL queries in debug mode
    pool_size=settings.DB_POOL_SIZE,
    max_overflow=settings.DB_MAX_OVERFLOW,
    pool_pre_ping=True,  # Verify connections before using (handles stale connections)
    pool_recycle=3600,  # Recycle connections after 1 hour
)

# ============================================
# Create Async Session Factory
# ============================================
AsyncSessionLocal = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,  # Don't expire objects after commit
    autocommit=False,
    autoflush=False,
)

# ============================================
# Base Class for Models
# ============================================
Base = declarative_base()

# ============================================
# Dependency for FastAPI Routes
# ============================================
async def get_db() -> AsyncSession:
    """
    FastAPI dependency that provides a database session.

    Usage:
        @app.get("/users")
        async def get_users(db: AsyncSession = Depends(get_db)):
            result = await db.execute(select(User))
            users = result.scalars().all()
            return users

    The session is automatically closed after the request completes.
    """
    async with AsyncSessionLocal() as session:
        try:
            yield session
        except Exception as e:
            logger.error(f"Database session error: {e}")
            await session.rollback()
            raise
        finally:
            await session.close()


# ============================================
# Database Utility Functions
# ============================================
async def init_db():
    """
    Initialize database tables.
    WARNING: This drops all existing tables and recreates them.
    Only use in development!
    """
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
    logger.info("Database tables initialized")


async def check_db_connection():
    """
    Check database connection health.
    Returns True if connection is successful, False otherwise.
    """
    try:
        async with engine.connect() as conn:
            await conn.execute("SELECT 1")
        logger.info("Database connection successful")
        return True
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        return False


async def close_db():
    """
    Close database connection pool.
    Call this on application shutdown.
    """
    await engine.dispose()
    logger.info("Database connection pool closed")
