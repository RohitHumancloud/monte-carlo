"""
Alembic Migration Environment
Configures async SQLAlchemy for database migrations
"""

import asyncio
from logging.config import fileConfig
from sqlalchemy import pool
from sqlalchemy.engine import Connection
from sqlalchemy.ext.asyncio import async_engine_from_config
from alembic import context

# Import application models and config
from app.config import settings
from app.database import Base

# Import all models to ensure they're registered with Base.metadata
from app.models.user import User
from app.models.api_key import ApiKey
from app.models.api_call_log import ApiCallLog

# Alembic Config object (provides access to alembic.ini)
config = context.config

# Interpret the config file for Python logging
# This will configure loggers based on alembic.ini
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# Target metadata for autogenerate support
# This is the SQLAlchemy MetaData object that contains all table definitions
target_metadata = Base.metadata


def run_migrations_offline() -> None:
    """
    Run migrations in 'offline' mode.

    This configures the context with just a URL and not an Engine.
    By skipping Engine creation, we don't need a database connection.

    Calls to context.execute() emit the given SQL string directly to the script output.

    Use case: Generate SQL scripts for manual execution (useful for production deployments)

    Example:
        alembic upgrade head --sql > migration.sql
    """
    # Get database URL from settings (not alembic.ini)
    url = settings.DATABASE_URL_ASYNC

    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        compare_type=True,  # Detect column type changes
        compare_server_default=True,  # Detect default value changes
    )

    with context.begin_transaction():
        context.run_migrations()


def do_run_migrations(connection: Connection) -> None:
    """
    Execute migrations within a database transaction

    Args:
        connection: SQLAlchemy database connection
    """
    context.configure(
        connection=connection,
        target_metadata=target_metadata,
        compare_type=True,  # Detect column type changes
        compare_server_default=True,  # Detect default value changes
        render_as_batch=False,  # Set to True for SQLite support
    )

    with context.begin_transaction():
        context.run_migrations()


async def run_async_migrations() -> None:
    """
    Run migrations using async SQLAlchemy engine

    Creates an async engine and executes migrations within a connection context.
    This is the standard approach for async SQLAlchemy applications.
    """
    # Override alembic.ini database URL with settings from .env
    configuration = config.get_section(config.config_ini_section)
    configuration["sqlalchemy.url"] = settings.DATABASE_URL_ASYNC

    # Create async engine
    connectable = async_engine_from_config(
        configuration,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,  # No connection pooling for migrations
    )

    async with connectable.connect() as connection:
        # Run migrations synchronously within async connection
        await connection.run_sync(do_run_migrations)

    # Dispose engine
    await connectable.dispose()


def run_migrations_online() -> None:
    """
    Run migrations in 'online' mode.

    Creates an Engine and associates a connection with the context.
    Uses asyncio to handle async SQLAlchemy.

    Use case: Standard migration execution against live database

    Example:
        alembic upgrade head
        alembic downgrade -1
        alembic revision --autogenerate -m "add user table"
    """
    asyncio.run(run_async_migrations())


# Determine which mode to run migrations
if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
