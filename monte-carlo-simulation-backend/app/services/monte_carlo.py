"""
Monte Carlo Simulation Service
Numba-optimized portfolio simulation engine
"""

import numpy as np
from numba import jit, prange
from typing import Dict, List
from app.schemas.simulation import SimulationRequest
import time
import uuid


class MonteCarloService:
    """
    Monte Carlo simulation engine with Numba optimization

    Performance:
        - 10,000 paths in ~2-5 seconds (Numba JIT compilation)
        - 100,000 paths in ~20-50 seconds
        - 10-100x faster than pure Python

    Methods:
        - run_simulation: Main entry point for portfolio simulation
        - simulate_gbm_paths: Numba-optimized GBM path simulation
        - calculate_statistics: Compute risk metrics from simulation results
    """

    @staticmethod
    @jit(nopython=True, parallel=True)
    def simulate_gbm_paths(
        S0: float,
        mu: float,
        sigma: float,
        T: int,
        dt: float,
        num_paths: int,
        seed: int = 42
    ) -> np.ndarray:
        """
        Simulate stock price paths using Geometric Brownian Motion (Numba-optimized)

        Formula:
            dS = μ * S * dt + σ * S * dW
            S(t+dt) = S(t) * exp((μ - 0.5σ²)dt + σ√dt * Z)

        Args:
            S0: Initial portfolio value
            mu: Expected return (drift) - annual
            sigma: Volatility - annual
            T: Time horizon in years
            dt: Time step (1/252 for daily)
            num_paths: Number of simulation paths
            seed: Random seed for reproducibility

        Returns:
            Array of shape (num_paths, num_steps + 1) with simulated prices
        """
        np.random.seed(seed)
        num_steps = int(T / dt)
        paths = np.zeros((num_paths, num_steps + 1))
        paths[:, 0] = S0

        drift = (mu - 0.5 * sigma**2) * dt
        vol = sigma * np.sqrt(dt)

        # Parallel loop over paths (Numba optimization)
        for i in prange(num_paths):
            for t in range(1, num_steps + 1):
                Z = np.random.standard_normal()
                paths[i, t] = paths[i, t-1] * np.exp(drift + vol * Z)

        return paths

    @staticmethod
    async def run_simulation(request: SimulationRequest) -> Dict:
        """
        Run Monte Carlo simulation for portfolio

        Steps:
            1. Extract portfolio and parameters
            2. Calculate portfolio mu and sigma (weighted average for MVP)
            3. Run GBM simulation
            4. Calculate statistics (percentiles, VaR, CVaR, probabilities)
            5. Return comprehensive results

        Args:
            request: SimulationRequest with portfolio and parameters

        Returns:
            Dictionary with simulation results
        """
        start_time = time.time()

        # Extract parameters
        S0 = request.parameters.initial_investment
        monthly_contribution = request.parameters.monthly_contribution
        T = request.parameters.time_horizon_years
        num_simulations = request.parameters.num_simulations

        # For MVP: Use simplified portfolio statistics
        # In production: Fetch real data from Bloomberg service
        mu, sigma = MonteCarloService._calculate_portfolio_stats(request)

        # Run GBM simulation (daily steps)
        dt = 1/252  # Daily time steps (252 trading days per year)
        paths = MonteCarloService.simulate_gbm_paths(
            S0=S0,
            mu=mu,
            sigma=sigma,
            T=T,
            dt=dt,
            num_paths=num_simulations,
            seed=int(time.time()) % 10000  # Different seed each time
        )

        # Add monthly contributions (simplified - no compounding in this MVP version)
        if monthly_contribution > 0:
            total_contributions = monthly_contribution * 12 * T
            paths[:, -1] += total_contributions

        # Extract final values
        final_values = paths[:, -1]

        # Calculate statistics
        results = MonteCarloService._calculate_statistics(
            final_values=final_values,
            initial_investment=S0,
            paths=paths[:5]  # Store first 5 paths for visualization
        )

        execution_time = time.time() - start_time
        results['execution_time_seconds'] = execution_time

        return results

    @staticmethod
    def _calculate_portfolio_stats(request: SimulationRequest) -> tuple[float, float]:
        """
        Calculate portfolio expected return and volatility

        For MVP: Use simplified assumptions
        For Production: Fetch real data from Bloomberg

        Args:
            request: SimulationRequest

        Returns:
            Tuple of (mu, sigma) - annual return and volatility
        """
        # Simplified assumptions for MVP (replace with Bloomberg data in production)
        asset_returns = {
            'equity': 0.12,    # 12% annual return
            'bonds': 0.06,     # 6% annual return
            'commodity': 0.08, # 8% annual return
            'cash': 0.03       # 3% annual return
        }

        asset_volatility = {
            'equity': 0.18,    # 18% volatility
            'bonds': 0.05,     # 5% volatility
            'commodity': 0.15, # 15% volatility
            'cash': 0.01       # 1% volatility
        }

        # Weighted average return
        mu = sum(
            asset.weight * asset_returns.get(asset.asset_class.lower(), 0.08)
            for asset in request.portfolio.assets
        )

        # Weighted average volatility (simplified - doesn't account for correlation)
        sigma = sum(
            asset.weight * asset_volatility.get(asset.asset_class.lower(), 0.15)
            for asset in request.portfolio.assets
        )

        return mu, sigma

    @staticmethod
    def _calculate_statistics(
        final_values: np.ndarray,
        initial_investment: float,
        paths: np.ndarray
    ) -> Dict:
        """
        Calculate comprehensive statistics from simulation results

        Args:
            final_values: Array of final portfolio values
            initial_investment: Initial investment amount
            paths: Sample paths for visualization (first 5)

        Returns:
            Dictionary with statistics
        """
        # Basic statistics
        mean_value = float(np.mean(final_values))
        median_value = float(np.median(final_values))
        std_deviation = float(np.std(final_values))
        min_value = float(np.min(final_values))
        max_value = float(np.max(final_values))

        # Percentiles
        percentiles = {
            'p1': float(np.percentile(final_values, 1)),
            'p5': float(np.percentile(final_values, 5)),
            'p10': float(np.percentile(final_values, 10)),
            'p25': float(np.percentile(final_values, 25)),
            'p50': float(np.percentile(final_values, 50)),
            'p75': float(np.percentile(final_values, 75)),
            'p90': float(np.percentile(final_values, 90)),
            'p95': float(np.percentile(final_values, 95)),
            'p99': float(np.percentile(final_values, 99)),
        }

        # Risk metrics
        var_95 = float(np.percentile(final_values, 5))  # Value at Risk (95% confidence)
        var_99 = float(np.percentile(final_values, 1))  # Value at Risk (99% confidence)
        cvar_95 = float(np.mean(final_values[final_values <= var_95]))  # Conditional VaR
        cvar_99 = float(np.mean(final_values[final_values <= var_99]))

        # Calculate Sharpe Ratio (simplified)
        annual_return = (mean_value / initial_investment) ** (1/10) - 1  # Assume 10 year horizon
        risk_free_rate = 0.03  # 3% risk-free rate
        excess_return = annual_return - risk_free_rate
        sharpe_ratio = excess_return / (std_deviation / mean_value) if std_deviation > 0 else 0.0

        # Probabilities
        prob_loss = float(np.mean(final_values < initial_investment))
        prob_doubling = float(np.mean(final_values >= initial_investment * 2))
        prob_positive_return = float(np.mean(final_values > initial_investment))

        # Convert paths to list for JSON serialization
        sample_paths_list = [path.tolist() for path in paths]

        return {
            'final_portfolio_value': {
                'mean': mean_value,
                'median': median_value,
                'std_deviation': std_deviation,
                'min': min_value,
                'max': max_value,
                'percentiles': percentiles
            },
            'risk_metrics': {
                'var_95': var_95,
                'var_99': var_99,
                'cvar_95': cvar_95,
                'cvar_99': cvar_99,
                'sharpe_ratio': float(sharpe_ratio),
                'volatility': std_deviation / mean_value if mean_value > 0 else 0.0
            },
            'probabilities': {
                'probability_of_loss': prob_loss,
                'probability_of_positive_return': prob_positive_return,
                'probability_of_doubling': prob_doubling
            },
            'sample_paths': sample_paths_list  # First 5 paths for charting
        }
