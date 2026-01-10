"""
Simulation Schemas
Pydantic models for Monte Carlo simulation requests and responses
"""

from pydantic import BaseModel, Field, field_validator
from typing import List, Optional, Dict, Any
from datetime import datetime


class Asset(BaseModel):
    """
    Schema for a single asset in the portfolio

    Examples:
        - Equity: ticker="NSEI Index", weight=0.6, asset_class="equity"
        - Bonds: ticker="GIND10YR Index", weight=0.4, asset_class="bonds"
        - Gold: ticker="GOLD Commodity", weight=0.2, asset_class="commodity"
    """
    ticker: str = Field(
        ...,
        min_length=1,
        max_length=50,
        description="Bloomberg ticker or asset identifier",
        examples=["NSEI Index", "GIND10YR Index", "GOLD Commodity"]
    )

    weight: float = Field(
        ...,
        ge=0.0,
        le=1.0,
        description="Asset weight in portfolio (0.0 to 1.0)",
        examples=[0.6, 0.4]
    )

    asset_class: str = Field(
        ...,
        description="Asset class (equity, bonds, commodity, cash)",
        examples=["equity", "bonds", "commodity"]
    )

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "ticker": "NSEI Index",
                "weight": 0.6,
                "asset_class": "equity"
            }]
        }
    }


class Portfolio(BaseModel):
    """
    Schema for portfolio composition

    Validation Rules:
        - Must have at least 1 asset
        - Total weights must sum to 1.0 (±1% tolerance)
    """
    assets: List[Asset] = Field(
        ...,
        min_length=1,
        max_length=20,
        description="List of assets in the portfolio"
    )

    @field_validator('assets')
    @classmethod
    def validate_weights(cls, v: List[Asset]) -> List[Asset]:
        """
        Validate that portfolio weights sum to 1.0 (with 1% tolerance)

        Args:
            v: List of assets

        Returns:
            Validated assets list

        Raises:
            ValueError: If weights don't sum to ~1.0
        """
        total_weight = sum(asset.weight for asset in v)
        if not (0.99 <= total_weight <= 1.01):  # 1% tolerance
            raise ValueError(
                f'Portfolio weights must sum to 1.0 (got {total_weight:.4f}). '
                f'Adjust asset weights to equal exactly 1.0.'
            )
        return v

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "assets": [
                    {"ticker": "NSEI Index", "weight": 0.6, "asset_class": "equity"},
                    {"ticker": "GIND10YR Index", "weight": 0.4, "asset_class": "bonds"}
                ]
            }]
        }
    }


class SimulationParameters(BaseModel):
    """
    Schema for simulation parameters

    Constraints:
        - initial_investment: Must be positive
        - monthly_contribution: Non-negative (0 means no contributions)
        - time_horizon_years: 1-50 years
        - num_simulations: 1,000-100,000 (balance between accuracy and performance)
    """
    initial_investment: float = Field(
        ...,
        gt=0,
        description="Initial portfolio value (must be positive)",
        examples=[1000000, 500000]
    )

    monthly_contribution: float = Field(
        default=0,
        ge=0,
        description="Monthly contribution amount (0 for no contributions)",
        examples=[50000, 0]
    )

    time_horizon_years: int = Field(
        ...,
        ge=1,
        le=50,
        description="Investment time horizon in years (1-50)",
        examples=[10, 20]
    )

    num_simulations: int = Field(
        default=10000,
        ge=1000,
        le=100000,
        description="Number of Monte Carlo simulation paths (1,000-100,000)",
        examples=[10000, 50000]
    )

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "initial_investment": 1000000,
                "monthly_contribution": 50000,
                "time_horizon_years": 10,
                "num_simulations": 10000
            }]
        }
    }


class SimulationRequest(BaseModel):
    """
    Complete simulation request schema
    Combines portfolio and parameters
    """
    portfolio: Portfolio = Field(..., description="Portfolio composition")
    parameters: SimulationParameters = Field(..., description="Simulation parameters")

    model_config = {
        "json_schema_extra": {
            "examples": [{
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
            }]
        }
    }


class SimulationResponse(BaseModel):
    """
    Simulation results response schema

    Contains:
        - simulation_id: Unique identifier for this simulation
        - status: 'completed', 'failed', or 'pending'
        - execution_time_seconds: How long the simulation took
        - results: Detailed simulation results with percentiles, risk metrics, etc.
    """
    simulation_id: str = Field(..., description="Unique simulation identifier")
    status: str = Field(..., description="Simulation status (completed/failed/pending)")
    created_at: datetime = Field(..., description="Timestamp when simulation was run")
    execution_time_seconds: float = Field(..., description="Simulation execution time")
    results: Dict[str, Any] = Field(..., description="Simulation results")

    model_config = {
        "json_schema_extra": {
            "examples": [{
                "simulation_id": "sim_abc123def456",
                "status": "completed",
                "created_at": "2024-01-01T12:00:00",
                "execution_time_seconds": 3.45,
                "results": {
                    "final_portfolio_value": {
                        "mean": 2500000,
                        "median": 2350000,
                        "std_deviation": 450000,
                        "percentiles": {
                            "p5": 1800000,
                            "p50": 2350000,
                            "p95": 3400000
                        }
                    },
                    "risk_metrics": {
                        "var_95": 1800000,
                        "cvar_95": 1650000,
                        "sharpe_ratio": 0.85
                    },
                    "probabilities": {
                        "probability_of_loss": 0.05,
                        "probability_of_doubling": 0.75
                    }
                }
            }]
        }
    }
