"""
Monte Carlo SaaS Backend - Main Application
FastAPI application entry point with router registration and middleware
"""

from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from contextlib import asynccontextmanager
from datetime import datetime, timezone
import logging
import time

from app.config import settings
from app.database import engine, Base
from app.api import auth, api_keys, simulation

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


# Lifespan context manager for startup/shutdown events
@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Manage application lifespan events

    Startup:
        - Log application start
        - Database connection is managed by SQLAlchemy pool

    Shutdown:
        - Close database connections
        - Log application shutdown
    """
    # Startup
    logger.info(f"🚀 Starting {settings.APP_NAME}...")
    logger.info(f"📊 Database: {settings.DATABASE_URL_ASYNC.split('@')[-1]}")  # Hide credentials
    logger.info(f"🔐 CORS Origins: {settings.CORS_ORIGINS}")
    logger.info(f"⏰ JWT Expiry: {settings.JWT_EXPIRATION_HOURS} hours")
    logger.info(f"🔑 API Key Expiry: {settings.API_KEY_EXPIRY_DAYS} days")

    yield

    # Shutdown
    logger.info("🛑 Shutting down application...")
    await engine.dispose()
    logger.info("✅ Database connections closed")


# Initialize FastAPI application
app = FastAPI(
    title=settings.APP_NAME,
    version="1.0.0",
    description="""
    **Monte Carlo Portfolio Simulation SaaS API**

    A production-ready FastAPI backend for portfolio risk analysis using Monte Carlo simulation.

    ## Features

    - **Dual Authentication**: JWT tokens for dashboard, API keys for programmatic access
    - **Monte Carlo Simulation**: Numba-optimized GBM simulation (10,000 paths in < 5 seconds)
    - **API Key Management**: Generate, list, revoke API keys with 30-day auto-expiry
    - **Usage Tracking**: Automatic API call logging for analytics and billing
    - **Bloomberg Integration**: Fetch real market data (optional)

    ## Authentication Methods

    ### 1. JWT Token (Dashboard Access)
    - **Endpoints**: `/auth/*`, `/api-keys/*`
    - **Header**: `Authorization: Bearer <token>`
    - **Expiry**: 24 hours
    - **Use Case**: User dashboard, API key management

    ### 2. API Key (Programmatic Access)
    - **Endpoints**: `/api/v1/simulate`
    - **Header**: `X-API-Key: mk_live_XXXXXXXXXXXXXXXXXXXXXXXX`
    - **Expiry**: 30 days (auto-expire)
    - **Use Case**: Third-party integrations, scripts, applications

    ## Quick Start

    1. **Register**: `POST /auth/register` - Create user account
    2. **Login**: `POST /auth/login` - Get JWT token
    3. **Generate API Key**: `POST /api-keys/generate` - Create API key (requires JWT)
    4. **Run Simulation**: `POST /api/v1/simulate` - Execute Monte Carlo simulation (requires API key)

    ## Business Rules

    - **Minimum 2 Active API Keys**: Prevent complete lockout
    - **Maximum 10 Active API Keys**: Per user limit
    - **30-Day API Key Expiry**: Free trial model
    - **Password Requirements**: Min 8 chars, uppercase + lowercase + digit

    ## Performance

    - 10,000 simulations: ~3-5 seconds
    - 50,000 simulations: ~15-25 seconds
    - 100,000 simulations: ~30-60 seconds

    ## Support

    - **Documentation**: Full API reference available at `/docs` and `/redoc`
    - **Health Check**: `GET /health` - Service status
    - **Version**: `GET /` - API version and information
    """,
    lifespan=lifespan,
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
    contact={
        "name": "Monte Carlo SaaS Support",
        "email": "support@montecarlo-saas.example.com"
    },
    license_info={
        "name": "Proprietary",
        "url": "https://montecarlo-saas.example.com/license"
    }
)


# Configure CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,  # Frontend domains
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allow_headers=[
        "Content-Type",
        "Authorization",
        "X-API-Key",
        "Accept",
        "Origin",
        "User-Agent",
        "DNT",
        "Cache-Control",
        "X-Requested-With"
    ],
    expose_headers=["Content-Length", "X-Request-ID"],
    max_age=3600  # Cache preflight requests for 1 hour
)


# Request timing middleware
@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    """
    Add X-Process-Time header to all responses

    Useful for monitoring API performance and identifying slow endpoints
    """
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time
    response.headers["X-Process-Time"] = f"{process_time:.4f}"
    return response


# Global exception handler
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """
    Catch-all exception handler for unhandled errors

    Prevents leaking sensitive error details to clients in production
    """
    logger.error(f"Unhandled exception on {request.method} {request.url}: {str(exc)}", exc_info=True)

    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "detail": "An internal server error occurred. Please try again later.",
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "path": str(request.url)
        }
    )


# Register routers
app.include_router(
    auth.router,
    prefix="",  # Already has /auth prefix in router
    tags=["Authentication"]
)

app.include_router(
    api_keys.router,
    prefix="",  # Already has /api-keys prefix in router
    tags=["API Keys"]
)

app.include_router(
    simulation.router,
    prefix="",  # Already has /api/v1 prefix in router
    tags=["Simulation"]
)


# Root endpoint
@app.get(
    "/",
    summary="API Information",
    description="Get API version and basic information",
    tags=["Root"]
)
async def root():
    """
    Root endpoint - API information

    Returns basic API details and links to documentation
    """
    return {
        "service": settings.APP_NAME,
        "version": "1.0.0",
        "status": "operational",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "documentation": {
            "swagger": "/docs",
            "redoc": "/redoc",
            "openapi": "/openapi.json"
        },
        "endpoints": {
            "authentication": "/auth",
            "api_keys": "/api-keys",
            "simulation": "/api/v1/simulate",
            "health": "/health"
        },
        "authentication_methods": {
            "jwt": {
                "header": "Authorization: Bearer <token>",
                "expiry": f"{settings.JWT_EXPIRATION_HOURS} hours",
                "endpoints": ["/auth/*", "/api-keys/*"]
            },
            "api_key": {
                "header": "X-API-Key: mk_live_XXXXXXXXXXXXXXXXXXXXXXXX",
                "expiry": f"{settings.API_KEY_EXPIRY_DAYS} days",
                "endpoints": ["/api/v1/simulate"]
            }
        },
        "support": {
            "email": "support@montecarlo-saas.example.com",
            "documentation": "https://docs.montecarlo-saas.example.com"
        }
    }


# Health check endpoint
@app.get(
    "/health",
    summary="Health Check",
    description="Service health check for monitoring and load balancers",
    tags=["Health"]
)
async def health_check():
    """
    Health check endpoint

    Returns service status without requiring authentication
    Useful for:
    - Kubernetes liveness/readiness probes
    - Load balancer health checks
    - Uptime monitoring services
    - CI/CD pipeline validation
    """
    try:
        # Basic health check - could add database ping here
        return {
            "status": "healthy",
            "service": settings.APP_NAME,
            "version": "1.0.0",
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "components": {
                "api": "operational",
                "database": "operational"  # TODO: Add actual database health check
            }
        }
    except Exception as e:
        logger.error(f"Health check failed: {str(e)}")
        return JSONResponse(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            content={
                "status": "unhealthy",
                "service": settings.APP_NAME,
                "timestamp": datetime.now(timezone.utc).isoformat(),
                "error": "Service unavailable"
            }
        )


# Optional: Startup banner
@app.on_event("startup")
async def startup_banner():
    """
    Display startup banner in console
    """
    banner = """
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║          Monte Carlo Portfolio Simulation SaaS API            ║
    ║                         Version 1.0.0                         ║
    ║                                                               ║
    ║  🚀 FastAPI Backend with Numba-Optimized Simulations         ║
    ║  📊 PostgreSQL + SQLAlchemy 2.0 (Async)                      ║
    ║  🔐 Dual Authentication: JWT + API Keys                       ║
    ║  ⚡ Production-Ready with CORS & Logging                      ║
    ║                                                               ║
    ║  📖 Documentation: http://localhost:8000/docs                 ║
    ║  💚 Health Check:  http://localhost:8000/health               ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    """
    print(banner)


# Run with: uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
