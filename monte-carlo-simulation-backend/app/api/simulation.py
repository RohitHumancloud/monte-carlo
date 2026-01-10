"""
Monte Carlo Simulation API Endpoint
Main simulation endpoint for portfolio analysis
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from datetime import datetime, timezone
import uuid

from app.database import get_db
from app.schemas.simulation import SimulationRequest, SimulationResponse
from app.services.monte_carlo import MonteCarloService
from app.middleware.auth_middleware import get_current_api_key
from app.models.api_key import ApiKey
from app.models.api_call_log import ApiCallLog
import time


router = APIRouter(prefix="/api/v1", tags=["Simulation"])


@router.post(
    "/simulate",
    response_model=SimulationResponse,
    summary="Run Monte Carlo Simulation",
    description="""
    Run Monte Carlo simulation for portfolio analysis.

    **Authentication Required:** API Key in `X-API-Key` header

    **How It Works:**
    1. Validates API key (active, not expired)
    2. Validates portfolio (weights must sum to 1.0)
    3. Runs Monte Carlo simulation (10,000 paths default)
    4. Returns comprehensive risk metrics and projections
    5. Logs API call for usage tracking

    **Performance:**
    - 10,000 simulations: ~3-5 seconds
    - 50,000 simulations: ~15-25 seconds
    - 100,000 simulations: ~30-60 seconds

    **Results Include:**
    - Final portfolio value statistics (mean, median, percentiles)
    - Risk metrics (VaR, CVaR, Sharpe Ratio)
    - Probabilities (loss, positive return, doubling)
    - Sample paths for visualization

    **Example Request:**
    ```json
    {
      "portfolio": {
        "assets": [
          {"ticker": "NSEI Index", "weight": 0.6, "asset_class": "equity"},
          {"ticker": "GIND10YR Index", "weight": 0.4, "asset_class": "bonds"}
        ]
      },
      "parameters": {
        "initial_investment": 1000000,
        "monthly_contribution": 50000,
        "time_horizon_years": 10,
        "num_simulations": 10000
      }
    }
    ```

    **Returns:**
    - Simulation results with risk metrics

    **Errors:**
    - 400: Invalid portfolio (weights don't sum to 1.0) or parameters
    - 401: Invalid, expired, or revoked API key
    - 500: Simulation error or server error
    """
)
async def run_simulation(
    request: SimulationRequest,
    api_key: ApiKey = Depends(get_current_api_key),
    db: AsyncSession = Depends(get_db)
) -> SimulationResponse:
    """
    Run Monte Carlo simulation for portfolio

    Steps:
        1. Validate API key (done by dependency)
        2. Run Monte Carlo simulation
        3. Log API call
        4. Return results

    Args:
        request: Simulation request with portfolio and parameters
        api_key: Validated API key (from dependency)
        db: Database session

    Returns:
        SimulationResponse with comprehensive results
    """
    start_time = time.time()
    simulation_id = f"sim_{uuid.uuid4().hex[:12]}"

    try:
        # Run Monte Carlo simulation
        results = await MonteCarloService.run_simulation(request)

        # Calculate execution time
        execution_time = time.time() - start_time

        # Log API call (successful)
        log_entry = ApiCallLog(
            user_id=api_key.user_id,
            api_key=api_key.key,
            endpoint="/api/v1/simulate",
            method="POST",
            status_code=200,
            execution_time_ms=execution_time * 1000,  # Convert to milliseconds
            error_message=None,
            created_at=datetime.now(timezone.utc)
        )
        db.add(log_entry)
        await db.commit()

        # Return simulation results
        return SimulationResponse(
            simulation_id=simulation_id,
            status="completed",
            created_at=datetime.now(timezone.utc),
            execution_time_seconds=execution_time,
            results=results
        )

    except HTTPException:
        # Re-raise HTTP exceptions
        raise

    except Exception as e:
        # Log failed API call
        execution_time = time.time() - start_time

        log_entry = ApiCallLog(
            user_id=api_key.user_id,
            api_key=api_key.key,
            endpoint="/api/v1/simulate",
            method="POST",
            status_code=500,
            execution_time_ms=execution_time * 1000,
            error_message=str(e),
            created_at=datetime.now(timezone.utc)
        )
        db.add(log_entry)
        await db.commit()

        # Return error response
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Simulation failed: {str(e)}"
        )


@router.get(
    "/health",
    summary="Health check",
    description="""
    Health check endpoint for simulation service.

    **No Authentication Required**

    **Returns:**
    - Service status
    - API version
    - Timestamp

    Useful for monitoring and load balancer health checks.
    """
)
async def health_check() -> dict:
    """
    Health check endpoint

    Returns basic service information without requiring authentication
    """
    return {
        "status": "healthy",
        "service": "Monte Carlo Simulation API",
        "version": "1.0.0",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }
