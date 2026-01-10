# Monte Carlo Simulation for Model Portfolio - Comprehensive Research Document

## Executive Summary

This document provides comprehensive research on implementing Monte Carlo simulation for model portfolios in the financial industry, based on IEEE research papers, academic publications, and industry best practices. The system integrates Bloomberg for historical data to calculate future value growth projections.

---

## Table of Contents

1. [Top 10 IEEE & Academic Research Papers](#1-top-10-ieee--academic-research-papers)
2. [Monte Carlo Simulation Core Concepts](#2-monte-carlo-simulation-core-concepts)
3. [Bloomberg Integration for Historical Data](#3-bloomberg-integration-for-historical-data)
4. [Recommended Technology Stack](#4-recommended-technology-stack)
5. [Mathematical Models & Algorithms](#5-mathematical-models--algorithms)
6. [Variance Reduction Techniques](#6-variance-reduction-techniques)
7. [Implementation Architecture](#7-implementation-architecture)
8. [Performance Optimization](#8-performance-optimization)
9. [Frontend Visualization](#9-frontend-visualization)
10. [Testing & Validation](#10-testing--validation)

---

## 1. Top 10 IEEE & Academic Research Papers

### Paper 1: Sector-Wise Portfolio Risk Assessment - Monte Carlo Simulation of NIFTY 50 Stocks
**Source:** [IEEE Xplore](https://ieeexplore.ieee.org/document/11005178/)

**Key Findings:**
- Presents an innovative approach based on the Mean-Value at Risk (VaR) model
- Merges mean-variance optimization with advanced risk metrics including VaR and CVaR (Conditional Value at Risk)
- Uses historical data for stock prices to derive sector-wise expected returns
- Provides comprehensive tail risk assessment using CVaR methodology

**Methodology:**
- Historical price data analysis for sector classification
- Standard deviation calculations for volatility measurement
- Value at Risk for downside risk quantification
- CVaR for extreme event probability assessment

---

### Paper 2: Introduction to Financial Risk Assessment Using Monte Carlo Simulation
**Source:** [IEEE Xplore](https://ieeexplore.ieee.org/document/5429323)

**Key Findings:**
- Fundamental principles of financial risk assessment using simulation
- Primary emphasis on evaluating and comparing alternative investments
- Covers stand-alone risk assessment for capital-budgeting problems
- Demonstrates Value-at-Risk (VAR) analysis for portfolios

**Key Metrics Covered:**
| Metric | Description |
|--------|-------------|
| NPV | Net Present Value |
| IRR | Internal Rate of Return |
| MIRR | Modified Internal Rate of Return |
| VAR | Value at Risk for single/multi-asset portfolios |

---

### Paper 3: The Application of Monte Carlo Computer Simulation in Investment Risk Analysis
**Source:** [IEEE Xplore](https://ieeexplore.ieee.org/document/5691779)

**Key Findings:**
- Demonstrates efficient processing of randomness and uncertainties in investment decisions
- Addresses deficiencies of traditional deterministic approaches
- Constructs suitable models for Monte Carlo simulation methods
- Provides framework for risk decision-making under uncertainty

---

### Paper 4: Model Contest and Portfolio Performance - Black-Litterman versus Factor Models
**Source:** [IEEE Xplore](https://ieeexplore.ieee.org/document/6586329)

**Key Findings:**
- Compares four models: Single Index, Fama-French Three-Factor, Carhart Four-Factor, and Black-Litterman
- Tests on 20 largest capitalization stocks on NASDAQ and NYSE
- **Result:** Black-Litterman model was superior to all other models
- Achieved Sharpe Ratio of **0.4437** - highest among compared models

**Performance Comparison:**
| Model | Relative Return | Relative Risk | Sharpe Ratio |
|-------|-----------------|---------------|--------------|
| Black-Litterman | Highest | Lowest | 0.4437 |
| Carhart Four-Factor | High | Medium | ~0.35 |
| Fama-French Three-Factor | Medium | Medium | ~0.30 |
| Single Index Model | Lower | Higher | ~0.25 |

---

### Paper 5: Application of Feedforward Neural Network in Portfolio Optimization and GBM in Stock Price Prediction
**Source:** [IEEE Xplore](https://ieeexplore.ieee.org/document/10193046)

**Key Findings:**
- Integrates Geometric Brownian Motion (GBM) with Neural Networks
- Predicts stock price movement using GBM model
- Optimizes portfolio using Feed Forward Neural Network
- Combines quantitative finance with machine learning approaches

---

### Paper 6: Prediction of Stock Prices Using Markov Chain Monte Carlo
**Source:** [IEEE Xplore](https://ieeexplore.ieee.org/document/9297965/)

**Key Findings:**
- Applies Bayesian inference to create prediction models
- Uses MCMC to generate predicted data
- Addresses computational challenges in mathematical stock price prediction
- Provides framework for probabilistic forecasting

---

### Paper 7: Financial Risk Assessment For Power Plant Investment Under Uncertainty
**Source:** [IEEE Xplore](https://ieeexplore.ieee.org/document/9102631)

**Key Findings:**
- Demonstrates NPV@risk using Monte Carlo Simulation
- Addresses uncertainty factors like exchange rate fluctuations
- Compares deterministic vs stochastic financial analysis
- Applicable methodology for any investment risk assessment

---

### Paper 8: Portfolio Optimization Using Machine Learning Method and Monte Carlo Simulation
**Source:** [ResearchGate](https://www.researchgate.net/publication/385000245_Portfolio_Optimization_Using_Machine_Learning_Method_and_Monte_Carlo_Simulation) (2024)

**Key Findings:**
- Uses sliding window approach with linear regression for return prediction
- Calculates variance-covariance matrix for optimal portfolio weights
- Two strategies: Max Sharpe Ratio and Min Risk

**Results:**
| Strategy | Cumulative Return | Benchmark (CSI 300) |
|----------|-------------------|---------------------|
| Max Sharpe Ratio | +9.09% | -3.48% |
| Outperformance | **+12.57%** | - |

---

### Paper 9: Risk-Adjusted Portfolio Optimization - Monte Carlo Simulation and Rebalancing
**Source:** [AABFJ Journal](https://www.researchgate.net/publication/385527804_Risk-Adjusted_Portfolio_Optimization_Monte_Carlo_Simulation_and_Rebalancing) (2024)

**Key Findings:**
- Evaluates risk-adjusted performance in Indian financial market (2011-2021)
- Incorporates Nifty 50 stocks and new-age assets
- Integrates Black-Litterman model for comparative analysis
- **Result:** Rebalanced portfolio demonstrates higher cumulative returns despite transaction costs

---

### Paper 10: Black-Litterman Portfolio Optimization with Dynamic CAPM via ABC-MCMC
**Source:** [ResearchGate](https://www.researchgate.net/publication/396512386_Black-Litterman_Portfolio_Optimization_with_Dynamic_CAPM_via_ABC-MCMC) (2025)

**Key Findings:**
- Integrates Black-Litterman model with dynamic CAPM simulations
- Uses conditional betas estimated via Approximate Bayesian Computation MCMC
- Captures asset sensitivity to market in different volatility regimes
- Advanced methodology for regime-switching market conditions

---

## 2. Monte Carlo Simulation Core Concepts

### 2.1 Geometric Brownian Motion (GBM)

The foundation of Monte Carlo simulation in finance is the Geometric Brownian Motion model:

```
dS = μSdt + σSdW

Where:
- S = Stock price
- μ = Drift (expected return)
- σ = Volatility
- dW = Wiener process (random walk)
```

**Discrete Approximation:**
```
S(t+Δt) = S(t) × exp[(μ - σ²/2)Δt + σ√Δt × Z]

Where Z ~ N(0,1)
```

### 2.2 Key Metrics

| Metric | Formula | Purpose |
|--------|---------|---------|
| **Expected Return** | E[R] = (1/n)Σᵢrᵢ | Average return estimation |
| **Volatility** | σ = √[(1/n)Σᵢ(rᵢ - E[R])²] | Risk measurement |
| **Sharpe Ratio** | (Rₚ - Rᶠ) / σₚ | Risk-adjusted return |
| **VaR (95%)** | Percentile(5%, Returns) | Maximum expected loss |
| **CVaR** | E[R | R ≤ VaR] | Tail risk average |

### 2.3 Simulation Parameters

```python
RECOMMENDED_PARAMETERS = {
    "num_simulations": 10000,        # Number of paths to simulate
    "time_horizon_years": 30,        # Investment horizon
    "time_steps_per_year": 252,      # Trading days
    "confidence_levels": [0.90, 0.95, 0.99],
    "rebalancing_frequency": "quarterly",
    "inflation_adjustment": True,
    "tax_consideration": True
}
```

---

## 3. Bloomberg Integration for Historical Data

### 3.1 Bloomberg API Overview

Bloomberg provides comprehensive financial data through multiple APIs:

| API Type | Description | Use Case |
|----------|-------------|----------|
| **B-PIPE** | Real-time streaming | Live market data |
| **SAPI** | Server API | Backend integration |
| **DAPI** | Desktop API | Terminal-connected apps |

### 3.2 Python Libraries for Bloomberg

#### Primary Library: blpapi (Official)
```bash
python -m pip install --index-url=https://blpapi.bloomberg.com/repository/releases/python/simple/ blpapi
```

**Supported Versions:** Python 3.10, 3.11, 3.12, 3.13, 3.14 (universal wheel)

#### Wrapper Libraries

| Library | Description | Link |
|---------|-------------|------|
| **xbbg** | Async reference and historical data functions | [PyPI](https://pypi.org/project/xbbg/) |
| **pdblp** | Pandas + Bloomberg integration | [PyPI](https://pypi.org/project/pdblp/) |
| **polars-bloomberg** | Polars DataFrame interface | [PyPI](https://pypi.org/project/polars-bloomberg/) |
| **bbg-fetch** | Data fetching wrapper (2024) | [PyPI](https://pypi.org/project/bbg-fetch/) |

### 3.3 Historical Data Retrieval Example

```python
from xbbg import blp
import pandas as pd

# Historical Price Data
def get_historical_data(tickers: list, start_date: str, end_date: str):
    """
    Fetch historical data from Bloomberg

    Args:
        tickers: List of Bloomberg tickers (e.g., ['AAPL US Equity'])
        start_date: Start date (YYYY-MM-DD)
        end_date: End date (YYYY-MM-DD)

    Returns:
        DataFrame with historical prices
    """
    hist = blp.bdh(
        tickers=tickers,
        flds=['PX_LAST', 'PX_OPEN', 'PX_HIGH', 'PX_LOW', 'PX_VOLUME'],
        start_date=start_date,
        end_date=end_date
    )
    return hist

# Portfolio Data
def get_portfolio_data(portfolio_name: str):
    """Fetch portfolio weights from Bloomberg"""
    return blp.getPortfolio(portfolio_name, 'PORTFOLIO_MWEIGHT')

# Currency Adjustment
def adjust_for_currency(hist_data: pd.DataFrame, target_ccy: str = 'USD'):
    """Convert historical data to target currency"""
    return blp.adjust_ccy(hist_data, ccy=target_ccy)

# Reference Data
def get_reference_data(tickers: list, fields: list):
    """Get static reference data"""
    return blp.bdp(tickers=tickers, flds=fields)
```

### 3.4 Key Bloomberg Fields for Monte Carlo

```python
BLOOMBERG_FIELDS = {
    # Price Fields
    "PX_LAST": "Last Price",
    "PX_OPEN": "Opening Price",
    "PX_HIGH": "High Price",
    "PX_LOW": "Low Price",
    "PX_VOLUME": "Volume",

    # Return Fields
    "TOT_RETURN_INDEX_GROSS_DVDS": "Total Return Index",
    "CHG_PCT_1D": "1-Day Change %",
    "CHG_PCT_YTD": "Year-to-Date Change %",

    # Risk Fields
    "VOLATILITY_30D": "30-Day Volatility",
    "VOLATILITY_90D": "90-Day Volatility",
    "VOLATILITY_260D": "260-Day Volatility",
    "BETA_ADJ_OVERRIDABLE": "Adjusted Beta",

    # Fundamental Fields
    "PE_RATIO": "Price/Earnings Ratio",
    "PX_TO_BOOK_RATIO": "Price/Book Ratio",
    "DIVIDEND_YIELD": "Dividend Yield",

    # Portfolio Analytics
    "PORT_PRCH_SHARPE_RATIO": "Portfolio Sharpe Ratio",
    "PORT_PRCH_VAR": "Portfolio VaR"
}
```

---

## 4. Recommended Technology Stack

### 4.1 Backend Architecture

#### Option A: Hybrid Polyglot Architecture (Recommended)

```
┌─────────────────────────────────────────────────────────────────┐
│                     API Gateway (Kong/AWS)                       │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│   Java/Spring │     │ Python/FastAPI│     │   Node.js     │
│     Boot      │     │               │     │   Express     │
│               │     │               │     │               │
│ • Auth/Security│     │ • Monte Carlo │     │ • Real-time   │
│ • Transactions │     │ • ML Models   │     │ • WebSocket   │
│ • Compliance   │     │ • Bloomberg   │     │ • Notifications│
│ • Core Banking │     │ • Analytics   │     │               │
└───────────────┘     └───────────────┘     └───────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              ▼
                    ┌───────────────┐
                    │  Message Bus  │
                    │ Apache Kafka  │
                    └───────────────┘
```

#### Backend Technology Comparison

| Aspect | Java/Spring Boot | Python/FastAPI | Node.js |
|--------|------------------|----------------|---------|
| **Best For** | Enterprise, Security, Transactions | ML/AI, Analytics, Simulations | Real-time, I/O-bound |
| **Performance** | CPU-bound operations | Data science workloads | High concurrency |
| **Security** | Built-in SQL injection, XSS protection | Requires manual setup | Medium |
| **Ecosystem** | Mature, banking integrations | NumPy, SciPy, Pandas | Large npm ecosystem |
| **Scalability** | Vertical + Horizontal | Async for I/O, distributed for CPU | Horizontal |

### 4.2 Monte Carlo Simulation Stack (Python)

```python
# Core Dependencies
PYTHON_DEPENDENCIES = {
    # Numerical Computing
    "numpy": ">=1.24.0",           # Array operations, random generation
    "scipy": ">=1.11.0",           # Statistical functions, optimization
    "pandas": ">=2.0.0",           # Data manipulation, time series

    # Monte Carlo Specific
    "numba": ">=0.57.0",           # JIT compilation for speed
    "multiprocessing": "builtin",  # Parallel processing
    "joblib": ">=1.3.0",           # Parallel computing utilities

    # Bloomberg Integration
    "blpapi": "latest",            # Official Bloomberg API
    "xbbg": ">=0.7.0",             # Bloomberg wrapper
    "pdblp": ">=0.1.8",            # Pandas Bloomberg interface

    # Distributed Computing
    "celery": ">=5.3.0",           # Distributed task queue
    "redis": ">=4.5.0",            # Message broker
    "dask": ">=2023.0",            # Parallel computing framework

    # API Framework
    "fastapi": ">=0.100.0",        # High-performance API
    "uvicorn": ">=0.22.0",         # ASGI server
    "pydantic": ">=2.0.0",         # Data validation

    # Database
    "sqlalchemy": ">=2.0.0",       # ORM
    "asyncpg": ">=0.28.0",         # Async PostgreSQL driver
    "alembic": ">=1.11.0",         # Database migrations
}
```

### 4.3 Database Layer

#### Primary Database: PostgreSQL

```sql
-- Recommended PostgreSQL Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";      -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pg_trgm";        -- Text similarity
CREATE EXTENSION IF NOT EXISTS "btree_gist";     -- Efficient indexing
CREATE EXTENSION IF NOT EXISTS "timescaledb";    -- Time-series optimization
```

#### Caching Layer: Redis

```python
REDIS_CONFIGURATION = {
    "simulation_cache": {
        "host": "redis-cluster",
        "port": 6379,
        "db": 0,
        "ttl": 3600,  # 1 hour cache
        "use_case": "Cache simulation results"
    },
    "task_queue": {
        "host": "redis-cluster",
        "port": 6379,
        "db": 1,
        "use_case": "Celery message broker"
    },
    "session_store": {
        "host": "redis-cluster",
        "port": 6379,
        "db": 2,
        "use_case": "User session management"
    }
}
```

### 4.4 Frontend Stack

#### Angular 19 (As per your existing documentation)

```typescript
// Technology Stack from FRONTEND_COMPONENTS.md
const FRONTEND_STACK = {
  framework: "Angular 19 (Standalone Components)",
  language: "TypeScript 5.7 (Strict Mode)",
  state: "Angular Signals",
  routing: "Angular Router",
  forms: "Reactive Forms",
  http: "HttpClient",
  styling: "Tailwind CSS v4",
  ssr: "Angular Universal (SSR)",
  testing: "Jasmine + Karma"
};
```

#### Charting Libraries for Monte Carlo Visualization

| Library | Use Case | Integration |
|---------|----------|-------------|
| **D3.js** | Custom probability distributions, fan charts | Direct DOM manipulation |
| **Chart.js** | Standard charts (line, bar, pie) | Angular wrapper available |
| **Recharts** | React-based (if needed) | D3 under the hood |
| **Highcharts** | Professional financial charts | Angular component |
| **ApexCharts** | Modern responsive charts | Angular wrapper |

### 4.5 Infrastructure Stack

```yaml
# Docker Compose for Development
services:
  # Backend Services
  api-gateway:
    image: kong:latest
    ports: ["8000:8000", "8443:8443"]

  spring-boot-app:
    build: ./backend/java
    ports: ["8080:8080"]

  fastapi-simulation:
    build: ./backend/python
    ports: ["8001:8000"]

  # Databases
  postgres:
    image: timescale/timescaledb:latest-pg15
    ports: ["5432:5432"]
    volumes: ["pgdata:/var/lib/postgresql/data"]

  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]

  # Message Queue
  kafka:
    image: confluentinc/cp-kafka:latest
    ports: ["9092:9092"]

  zookeeper:
    image: confluentinc/cp-zookeeper:latest
    ports: ["2181:2181"]

  # Monitoring
  prometheus:
    image: prom/prometheus:latest
    ports: ["9090:9090"]

  grafana:
    image: grafana/grafana:latest
    ports: ["3000:3000"]
```

---

## 5. Mathematical Models & Algorithms

### 5.1 Geometric Brownian Motion Implementation

```python
import numpy as np
from numba import jit, prange
from typing import Tuple

@jit(nopython=True, parallel=True)
def simulate_gbm_paths(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    dt: float,
    num_paths: int,
    seed: int = 42
) -> np.ndarray:
    """
    Simulate stock price paths using Geometric Brownian Motion

    Args:
        S0: Initial stock price
        mu: Expected return (drift)
        sigma: Volatility
        T: Time horizon (years)
        dt: Time step (1/252 for daily)
        num_paths: Number of simulation paths
        seed: Random seed for reproducibility

    Returns:
        Array of shape (num_paths, num_steps) with simulated prices
    """
    np.random.seed(seed)
    num_steps = int(T / dt)
    paths = np.zeros((num_paths, num_steps + 1))
    paths[:, 0] = S0

    # Pre-compute constants
    drift = (mu - 0.5 * sigma**2) * dt
    vol = sigma * np.sqrt(dt)

    for i in prange(num_paths):
        for t in range(1, num_steps + 1):
            Z = np.random.standard_normal()
            paths[i, t] = paths[i, t-1] * np.exp(drift + vol * Z)

    return paths


def calculate_portfolio_simulation(
    weights: np.ndarray,
    returns_matrix: np.ndarray,
    cov_matrix: np.ndarray,
    initial_value: float,
    num_simulations: int = 10000,
    time_horizon: int = 252 * 10  # 10 years
) -> Tuple[np.ndarray, dict]:
    """
    Monte Carlo simulation for portfolio future value

    Returns:
        paths: Simulated portfolio value paths
        statistics: Dictionary with VaR, CVaR, percentiles
    """
    # Portfolio expected return and volatility
    portfolio_return = np.dot(weights, returns_matrix.mean())
    portfolio_volatility = np.sqrt(
        np.dot(weights.T, np.dot(cov_matrix, weights))
    )

    # Simulate paths
    paths = simulate_gbm_paths(
        S0=initial_value,
        mu=portfolio_return,
        sigma=portfolio_volatility,
        T=time_horizon / 252,
        dt=1/252,
        num_paths=num_simulations
    )

    # Calculate statistics
    final_values = paths[:, -1]
    statistics = {
        "mean": np.mean(final_values),
        "median": np.median(final_values),
        "std": np.std(final_values),
        "var_95": np.percentile(final_values, 5),
        "var_99": np.percentile(final_values, 1),
        "cvar_95": np.mean(final_values[final_values <= np.percentile(final_values, 5)]),
        "percentile_10": np.percentile(final_values, 10),
        "percentile_25": np.percentile(final_values, 25),
        "percentile_50": np.percentile(final_values, 50),
        "percentile_75": np.percentile(final_values, 75),
        "percentile_90": np.percentile(final_values, 90),
        "probability_doubling": np.mean(final_values >= 2 * initial_value),
        "probability_loss": np.mean(final_values < initial_value)
    }

    return paths, statistics
```

### 5.2 Black-Litterman Model Integration

```python
import numpy as np
from scipy import linalg

def black_litterman_model(
    market_weights: np.ndarray,
    cov_matrix: np.ndarray,
    risk_aversion: float,
    P: np.ndarray,  # View matrix
    Q: np.ndarray,  # View returns
    omega: np.ndarray,  # View uncertainty
    tau: float = 0.05
) -> Tuple[np.ndarray, np.ndarray]:
    """
    Black-Litterman model for portfolio optimization

    Based on IEEE paper findings showing superior Sharpe Ratio (0.4437)
    compared to factor models.

    Args:
        market_weights: Market capitalization weights
        cov_matrix: Asset covariance matrix
        risk_aversion: Risk aversion parameter
        P: Pick matrix (views on assets)
        Q: Expected returns for views
        omega: Diagonal matrix of view uncertainties
        tau: Scalar for uncertainty in equilibrium

    Returns:
        expected_returns: Black-Litterman expected returns
        posterior_cov: Posterior covariance matrix
    """
    # Equilibrium excess returns (implied from market)
    pi = risk_aversion * np.dot(cov_matrix, market_weights)

    # Scaling factor
    tau_sigma = tau * cov_matrix

    # Black-Litterman formula
    # E[R] = [(τΣ)^-1 + P'Ω^-1P]^-1 × [(τΣ)^-1π + P'Ω^-1Q]

    inv_tau_sigma = linalg.inv(tau_sigma)
    inv_omega = linalg.inv(omega)

    # Posterior precision
    posterior_precision = inv_tau_sigma + np.dot(P.T, np.dot(inv_omega, P))
    posterior_cov = linalg.inv(posterior_precision)

    # Posterior mean
    expected_returns = np.dot(
        posterior_cov,
        np.dot(inv_tau_sigma, pi) + np.dot(P.T, np.dot(inv_omega, Q))
    )

    return expected_returns, posterior_cov


def optimize_portfolio_black_litterman(
    expected_returns: np.ndarray,
    cov_matrix: np.ndarray,
    risk_aversion: float,
    constraints: dict = None
) -> np.ndarray:
    """
    Optimize portfolio weights using Black-Litterman returns

    Returns:
        Optimal portfolio weights
    """
    from scipy.optimize import minimize

    n_assets = len(expected_returns)

    def objective(weights):
        port_return = np.dot(weights, expected_returns)
        port_variance = np.dot(weights.T, np.dot(cov_matrix, weights))
        # Maximize utility: return - (risk_aversion/2) * variance
        return -(port_return - (risk_aversion / 2) * port_variance)

    # Constraints
    constraints_list = [
        {'type': 'eq', 'fun': lambda w: np.sum(w) - 1}  # Weights sum to 1
    ]

    # Bounds (no short selling by default)
    bounds = [(0, 1) for _ in range(n_assets)]

    # Initial guess (equal weights)
    x0 = np.array([1/n_assets] * n_assets)

    result = minimize(
        objective,
        x0,
        method='SLSQP',
        bounds=bounds,
        constraints=constraints_list
    )

    return result.x
```

### 5.3 Value at Risk (VaR) and CVaR Calculation

```python
import numpy as np
from scipy import stats

def calculate_var_cvar(
    returns: np.ndarray,
    confidence_levels: list = [0.90, 0.95, 0.99],
    method: str = 'historical'
) -> dict:
    """
    Calculate Value at Risk and Conditional Value at Risk

    Based on IEEE paper methodologies for risk assessment.

    Args:
        returns: Array of portfolio returns
        confidence_levels: List of confidence levels
        method: 'historical', 'parametric', or 'monte_carlo'

    Returns:
        Dictionary with VaR and CVaR at each confidence level
    """
    results = {}

    for conf in confidence_levels:
        alpha = 1 - conf

        if method == 'historical':
            var = np.percentile(returns, alpha * 100)
            cvar = np.mean(returns[returns <= var])

        elif method == 'parametric':
            mu = np.mean(returns)
            sigma = np.std(returns)
            var = mu + sigma * stats.norm.ppf(alpha)
            # Parametric CVaR for normal distribution
            cvar = mu - sigma * stats.norm.pdf(stats.norm.ppf(alpha)) / alpha

        elif method == 'monte_carlo':
            # Fit distribution and simulate
            mu, sigma = np.mean(returns), np.std(returns)
            simulated = np.random.normal(mu, sigma, 100000)
            var = np.percentile(simulated, alpha * 100)
            cvar = np.mean(simulated[simulated <= var])

        results[f'VaR_{int(conf*100)}'] = var
        results[f'CVaR_{int(conf*100)}'] = cvar

    return results
```

---

## 6. Variance Reduction Techniques

Based on academic research, implement these techniques for improved simulation efficiency:

### 6.1 Antithetic Variates

```python
@jit(nopython=True)
def simulate_with_antithetic(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    dt: float,
    num_paths: int
) -> np.ndarray:
    """
    Monte Carlo simulation with antithetic variates

    Reduces variance by using negatively correlated paths.
    Research shows this can reduce variance by up to 50%.
    """
    num_steps = int(T / dt)
    half_paths = num_paths // 2

    paths = np.zeros((num_paths, num_steps + 1))
    paths[:, 0] = S0

    drift = (mu - 0.5 * sigma**2) * dt
    vol = sigma * np.sqrt(dt)

    for i in range(half_paths):
        for t in range(1, num_steps + 1):
            Z = np.random.standard_normal()

            # Original path
            paths[i, t] = paths[i, t-1] * np.exp(drift + vol * Z)

            # Antithetic path (using -Z)
            paths[i + half_paths, t] = paths[i + half_paths, t-1] * np.exp(drift + vol * (-Z))

    return paths
```

### 6.2 Control Variates

```python
def simulate_with_control_variate(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    num_simulations: int,
    strike: float = None
) -> Tuple[float, float]:
    """
    Monte Carlo with control variate variance reduction

    Uses stock price as control variate (known expected value).
    Can reduce variance significantly for option pricing.
    """
    # Simulate paths
    paths = simulate_gbm_paths(S0, mu, sigma, T, 1/252, num_simulations)
    final_prices = paths[:, -1]

    # Control variate: final stock price
    # Known expected value: S0 * exp(mu * T)
    expected_control = S0 * np.exp(mu * T)

    # Calculate payoffs (example: call option)
    if strike:
        payoffs = np.maximum(final_prices - strike, 0) * np.exp(-mu * T)
    else:
        payoffs = final_prices

    # Optimal beta coefficient
    cov_xy = np.cov(payoffs, final_prices)[0, 1]
    var_x = np.var(final_prices)
    beta = cov_xy / var_x

    # Adjusted estimate
    adjusted_payoffs = payoffs - beta * (final_prices - expected_control)

    estimate = np.mean(adjusted_payoffs)
    std_error = np.std(adjusted_payoffs) / np.sqrt(num_simulations)

    return estimate, std_error
```

### 6.3 Importance Sampling

```python
def importance_sampling_var(
    portfolio_value: float,
    mu: float,
    sigma: float,
    var_level: float,  # e.g., 0.05 for 95% VaR
    num_simulations: int = 10000
) -> Tuple[float, float]:
    """
    Importance sampling for rare event (tail risk) estimation

    Shifts distribution to focus sampling on tail events,
    improving accuracy for VaR/CVaR calculations.
    """
    # Shift parameter (to tail)
    shift = stats.norm.ppf(var_level) * sigma

    # Sample from shifted distribution
    Z_shifted = np.random.normal(shift, sigma, num_simulations)

    # Calculate returns under shifted measure
    returns = mu + Z_shifted

    # Likelihood ratio (Radon-Nikodym derivative)
    likelihood_ratio = np.exp(
        -shift * Z_shifted / sigma + 0.5 * (shift/sigma)**2
    )

    # Indicator for tail events
    threshold = mu + stats.norm.ppf(var_level) * sigma
    indicators = (returns <= threshold).astype(float)

    # Weighted estimate
    var_estimate = np.sum(returns * indicators * likelihood_ratio) / np.sum(indicators * likelihood_ratio)

    return var_estimate, np.std(returns * likelihood_ratio) / np.sqrt(num_simulations)
```

---

## 7. Implementation Architecture

### 7.1 System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              FRONTEND (Angular 19)                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │ Dashboard   │  │ Simulation  │  │ Portfolio   │  │ Charts & Visualization  │ │
│  │ Component   │  │ Form        │  │ Results     │  │ (D3.js / Chart.js)      │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────┬───────────────────────────────────────────┘
                                      │ HTTPS
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              API GATEWAY (Kong)                                  │
│  • Rate Limiting  • Authentication  • Load Balancing  • SSL Termination         │
└─────────────────────────────────────┬───────────────────────────────────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              ▼                       ▼                       ▼
┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│   JAVA/SPRING BOOT   │  │   PYTHON/FASTAPI     │  │    NODE.JS           │
│   Core Services      │  │   Simulation Engine  │  │    Real-time         │
│                      │  │                      │  │                      │
│ • User Management    │  │ • Monte Carlo Engine │  │ • WebSocket Server   │
│ • Authentication     │  │ • Bloomberg Client   │  │ • Notifications      │
│ • Authorization      │  │ • Portfolio Optimizer│  │ • Live Updates       │
│ • Goal Management    │  │ • Risk Calculator    │  │ • Event Streaming    │
│ • Transaction Log    │  │ • ML Models          │  │                      │
│ • Audit Trail        │  │ • Report Generator   │  │                      │
└──────────┬───────────┘  └──────────┬───────────┘  └──────────┬───────────┘
           │                         │                         │
           └─────────────────────────┼─────────────────────────┘
                                     ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                            MESSAGE BUS (Apache Kafka)                            │
│  Topics: simulation.requests | simulation.results | market.data | notifications │
└─────────────────────────────────────┬───────────────────────────────────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              ▼                       ▼                       ▼
┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│   PostgreSQL         │  │   Redis Cluster      │  │   Bloomberg          │
│   (TimescaleDB)      │  │                      │  │   Terminal           │
│                      │  │ • Session Cache      │  │                      │
│ • User Data          │  │ • Simulation Cache   │  │ • Historical Prices  │
│ • Portfolios         │  │ • Task Queue         │  │ • Reference Data     │
│ • Goals              │  │ • Rate Limiting      │  │ • Real-time Feeds    │
│ • Simulation Results │  │ • Pub/Sub            │  │ • Analytics          │
│ • Time-series Data   │  │                      │  │                      │
└──────────────────────┘  └──────────────────────┘  └──────────────────────┘
```

### 7.2 Simulation Service API Design

```python
# FastAPI Simulation Service
from fastapi import FastAPI, BackgroundTasks, HTTPException
from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime
import uuid

app = FastAPI(
    title="Monte Carlo Simulation Service",
    description="Portfolio simulation engine with Bloomberg integration",
    version="1.0.0"
)

# Request/Response Models
class AssetAllocation(BaseModel):
    ticker: str
    weight: float = Field(..., ge=0, le=1)
    expected_return: Optional[float] = None
    volatility: Optional[float] = None

class SimulationRequest(BaseModel):
    portfolio_id: str
    customer_id: str
    allocations: List[AssetAllocation]
    initial_investment: float = Field(..., gt=0)
    monthly_contribution: float = Field(default=0, ge=0)
    time_horizon_years: int = Field(..., ge=1, le=50)
    num_simulations: int = Field(default=10000, ge=1000, le=100000)
    confidence_levels: List[float] = Field(default=[0.90, 0.95, 0.99])
    include_inflation: bool = True
    inflation_rate: float = Field(default=0.03, ge=0, le=0.20)
    rebalancing_frequency: str = Field(default="quarterly")

class SimulationResult(BaseModel):
    simulation_id: str
    created_at: datetime
    status: str

    # Summary Statistics
    expected_final_value: float
    median_final_value: float
    std_deviation: float

    # Risk Metrics
    var_90: float
    var_95: float
    var_99: float
    cvar_95: float

    # Probability Metrics
    probability_reaching_goal: float
    probability_of_loss: float
    probability_doubling: float

    # Percentile Distribution
    percentile_distribution: dict

    # Path Data (for visualization)
    sample_paths: List[List[float]]
    percentile_paths: dict

# API Endpoints
@app.post("/api/v1/simulations", response_model=SimulationResult)
async def create_simulation(
    request: SimulationRequest,
    background_tasks: BackgroundTasks
):
    """
    Run Monte Carlo simulation for portfolio future value projection
    """
    simulation_id = str(uuid.uuid4())

    # Fetch historical data from Bloomberg
    historical_data = await fetch_bloomberg_data(request.allocations)

    # Calculate returns and covariance
    returns, cov_matrix = calculate_statistics(historical_data)

    # Run simulation
    result = run_monte_carlo_simulation(
        allocations=request.allocations,
        returns=returns,
        cov_matrix=cov_matrix,
        initial_value=request.initial_investment,
        monthly_contribution=request.monthly_contribution,
        time_horizon=request.time_horizon_years,
        num_simulations=request.num_simulations,
        inflation_rate=request.inflation_rate if request.include_inflation else 0
    )

    # Store result
    await store_simulation_result(simulation_id, result)

    return result

@app.get("/api/v1/simulations/{simulation_id}")
async def get_simulation(simulation_id: str):
    """Retrieve simulation results by ID"""
    result = await fetch_simulation_result(simulation_id)
    if not result:
        raise HTTPException(status_code=404, detail="Simulation not found")
    return result

@app.post("/api/v1/simulations/{simulation_id}/rerun")
async def rerun_simulation(simulation_id: str, num_simulations: int = 10000):
    """Rerun existing simulation with more iterations"""
    pass

@app.get("/api/v1/portfolios/{portfolio_id}/efficient-frontier")
async def get_efficient_frontier(portfolio_id: str, num_points: int = 100):
    """Calculate efficient frontier for portfolio assets"""
    pass
```

### 7.3 Celery Task Configuration for Distributed Simulation

```python
# celery_config.py
from celery import Celery, chord
from celery.result import AsyncResult
import numpy as np

app = Celery(
    'monte_carlo',
    broker='redis://localhost:6379/0',
    backend='redis://localhost:6379/1'
)

app.conf.update(
    task_serializer='pickle',
    accept_content=['pickle', 'json'],
    result_serializer='pickle',
    timezone='UTC',
    enable_utc=True,
    task_track_started=True,
    task_time_limit=600,  # 10 minutes max
    worker_prefetch_multiplier=1,
    worker_concurrency=4,  # Adjust based on CPU cores
)

@app.task(bind=True)
def run_simulation_chunk(
    self,
    chunk_id: int,
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    dt: float,
    num_paths: int
) -> np.ndarray:
    """
    Run a chunk of Monte Carlo simulations

    Distributed across workers for parallel processing
    """
    self.update_state(state='RUNNING', meta={'chunk_id': chunk_id})

    paths = simulate_gbm_paths(S0, mu, sigma, T, dt, num_paths)
    final_values = paths[:, -1]

    return final_values

@app.task
def aggregate_results(results: list) -> dict:
    """
    Aggregate results from all simulation chunks
    """
    all_values = np.concatenate(results)

    return {
        'mean': float(np.mean(all_values)),
        'median': float(np.median(all_values)),
        'std': float(np.std(all_values)),
        'var_95': float(np.percentile(all_values, 5)),
        'cvar_95': float(np.mean(all_values[all_values <= np.percentile(all_values, 5)])),
        'percentiles': {
            str(p): float(np.percentile(all_values, p))
            for p in [1, 5, 10, 25, 50, 75, 90, 95, 99]
        }
    }

def run_distributed_simulation(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    total_simulations: int = 100000,
    num_workers: int = 10
) -> AsyncResult:
    """
    Distribute Monte Carlo simulation across multiple workers

    Example: 100,000 simulations across 10 workers = 10,000 each
    """
    simulations_per_worker = total_simulations // num_workers
    dt = 1/252

    # Create chord: parallel tasks + aggregation callback
    simulation_tasks = [
        run_simulation_chunk.s(
            chunk_id=i,
            S0=S0,
            mu=mu,
            sigma=sigma,
            T=T,
            dt=dt,
            num_paths=simulations_per_worker
        )
        for i in range(num_workers)
    ]

    # Execute chord
    result = chord(simulation_tasks)(aggregate_results.s())

    return result
```

---

## 8. Performance Optimization

### 8.1 Numba JIT Compilation

```python
from numba import jit, prange, float64
import numpy as np

@jit(float64[:,:](float64, float64, float64, float64, float64, int64),
     nopython=True, parallel=True, cache=True)
def optimized_gbm_simulation(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    dt: float,
    num_paths: int
) -> np.ndarray:
    """
    Highly optimized GBM simulation using Numba

    Performance improvements:
    - JIT compilation: 10-100x faster than pure Python
    - Parallel execution: Linear speedup with cores
    - Memory pre-allocation: Reduced GC overhead
    - Cache: Faster subsequent calls
    """
    num_steps = int(T / dt)
    paths = np.empty((num_paths, num_steps + 1), dtype=np.float64)
    paths[:, 0] = S0

    drift = (mu - 0.5 * sigma * sigma) * dt
    vol = sigma * np.sqrt(dt)

    for i in prange(num_paths):
        for t in range(1, num_steps + 1):
            Z = np.random.randn()
            paths[i, t] = paths[i, t-1] * np.exp(drift + vol * Z)

    return paths
```

### 8.2 Vectorized Operations

```python
import numpy as np

def vectorized_simulation(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    dt: float,
    num_paths: int
) -> np.ndarray:
    """
    Fully vectorized Monte Carlo simulation

    Avoids Python loops entirely using NumPy broadcasting.
    2-5x faster than loop-based approaches for moderate sizes.
    """
    num_steps = int(T / dt)

    # Generate all random numbers at once
    Z = np.random.standard_normal((num_paths, num_steps))

    # Calculate increments
    drift = (mu - 0.5 * sigma**2) * dt
    vol = sigma * np.sqrt(dt)
    increments = drift + vol * Z

    # Cumulative sum of log returns
    log_returns = np.cumsum(increments, axis=1)

    # Add initial price and convert from log space
    paths = np.zeros((num_paths, num_steps + 1))
    paths[:, 0] = S0
    paths[:, 1:] = S0 * np.exp(log_returns)

    return paths
```

### 8.3 Memory-Efficient Streaming Simulation

```python
from typing import Generator
import numpy as np

def streaming_simulation(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    dt: float,
    batch_size: int = 1000
) -> Generator[np.ndarray, None, None]:
    """
    Memory-efficient streaming simulation

    Yields batches of final values without storing full paths.
    Ideal for very large simulations (millions of paths).
    """
    num_steps = int(T / dt)
    drift = (mu - 0.5 * sigma**2) * dt
    vol = sigma * np.sqrt(dt)

    while True:
        # Generate batch
        Z = np.random.standard_normal((batch_size, num_steps))
        increments = drift + vol * Z
        log_returns = np.sum(increments, axis=1)
        final_values = S0 * np.exp(log_returns)

        yield final_values

def run_streaming_simulation(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    total_simulations: int,
    batch_size: int = 10000
) -> dict:
    """
    Run large-scale simulation with streaming aggregation
    """
    gen = streaming_simulation(S0, mu, sigma, T, 1/252, batch_size)

    # Online statistics computation
    n = 0
    mean = 0.0
    M2 = 0.0
    all_values = []

    for _ in range(total_simulations // batch_size):
        batch = next(gen)
        all_values.extend(batch)

        # Welford's online algorithm for mean and variance
        for x in batch:
            n += 1
            delta = x - mean
            mean += delta / n
            delta2 = x - mean
            M2 += delta * delta2

    variance = M2 / (n - 1)
    all_values = np.array(all_values)

    return {
        'mean': mean,
        'std': np.sqrt(variance),
        'var_95': np.percentile(all_values, 5),
        'median': np.median(all_values)
    }
```

### 8.4 GPU Acceleration (Optional)

```python
import cupy as cp  # GPU-accelerated NumPy

def gpu_monte_carlo(
    S0: float,
    mu: float,
    sigma: float,
    T: float,
    dt: float,
    num_paths: int
) -> cp.ndarray:
    """
    GPU-accelerated Monte Carlo simulation using CuPy

    Requires NVIDIA GPU with CUDA support.
    10-50x faster than CPU for large simulations.
    """
    num_steps = int(T / dt)

    # All operations on GPU
    Z = cp.random.standard_normal((num_paths, num_steps), dtype=cp.float32)

    drift = (mu - 0.5 * sigma**2) * dt
    vol = sigma * cp.sqrt(dt)
    increments = drift + vol * Z

    log_returns = cp.cumsum(increments, axis=1)

    paths = cp.zeros((num_paths, num_steps + 1), dtype=cp.float32)
    paths[:, 0] = S0
    paths[:, 1:] = S0 * cp.exp(log_returns)

    return paths

# Convert back to CPU for further processing
# cpu_paths = cp.asnumpy(gpu_paths)
```

---

## 9. Frontend Visualization

### 9.1 Monte Carlo Fan Chart Component

```typescript
// simulation-fan-chart.component.ts
import { Component, ChangeDetectionStrategy, input, computed, inject } from '@angular/core';
import { CommonModule } from '@angular/common';

interface SimulationData {
  percentiles: {
    p5: number[];
    p10: number[];
    p25: number[];
    p50: number[];
    p75: number[];
    p90: number[];
    p95: number[];
  };
  timePoints: number[];
  finalDistribution: number[];
}

@Component({
  selector: 'app-simulation-fan-chart',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="simulation-chart-container">
      <h3 class="text-xl font-semibold mb-4">Portfolio Projection - Monte Carlo Simulation</h3>

      <!-- Chart will be rendered by D3 -->
      <div #chartContainer class="chart-container w-full h-96"></div>

      <!-- Legend -->
      <div class="flex justify-center gap-6 mt-4 text-sm">
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 bg-blue-200 rounded"></div>
          <span>90% Confidence Band</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 bg-blue-400 rounded"></div>
          <span>50% Confidence Band</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-3 h-0.5 bg-blue-700"></div>
          <span>Median Path</span>
        </div>
      </div>

      <!-- Statistics Panel -->
      @if (statistics()) {
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-6">
          <div class="stat-card p-4 bg-gray-50 rounded-lg">
            <p class="text-sm text-gray-600">Expected Value</p>
            <p class="text-2xl font-bold text-green-600">
              {{ statistics().expectedValue | currency:'INR':'symbol':'1.0-0' }}
            </p>
          </div>
          <div class="stat-card p-4 bg-gray-50 rounded-lg">
            <p class="text-sm text-gray-600">5th Percentile (Worst Case)</p>
            <p class="text-2xl font-bold text-red-600">
              {{ statistics().p5 | currency:'INR':'symbol':'1.0-0' }}
            </p>
          </div>
          <div class="stat-card p-4 bg-gray-50 rounded-lg">
            <p class="text-sm text-gray-600">95th Percentile (Best Case)</p>
            <p class="text-2xl font-bold text-blue-600">
              {{ statistics().p95 | currency:'INR':'symbol':'1.0-0' }}
            </p>
          </div>
          <div class="stat-card p-4 bg-gray-50 rounded-lg">
            <p class="text-sm text-gray-600">Probability of Goal</p>
            <p class="text-2xl font-bold text-purple-600">
              {{ statistics().probabilityOfGoal | percent:'1.1-1' }}
            </p>
          </div>
        </div>
      }
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SimulationFanChartComponent {
  readonly data = input.required<SimulationData>();
  readonly goalAmount = input<number>(0);

  readonly statistics = computed(() => {
    const d = this.data();
    if (!d) return null;

    const finalValues = d.finalDistribution;
    return {
      expectedValue: this.mean(finalValues),
      p5: this.percentile(finalValues, 5),
      p50: this.percentile(finalValues, 50),
      p95: this.percentile(finalValues, 95),
      probabilityOfGoal: this.goalAmount() > 0
        ? finalValues.filter(v => v >= this.goalAmount()).length / finalValues.length
        : 0
    };
  });

  private mean(arr: number[]): number {
    return arr.reduce((a, b) => a + b, 0) / arr.length;
  }

  private percentile(arr: number[], p: number): number {
    const sorted = [...arr].sort((a, b) => a - b);
    const idx = Math.ceil((p / 100) * sorted.length) - 1;
    return sorted[idx];
  }
}
```

### 9.2 D3.js Fan Chart Implementation

```typescript
// d3-fan-chart.service.ts
import { Injectable } from '@angular/core';
import * as d3 from 'd3';

@Injectable({
  providedIn: 'root'
})
export class D3FanChartService {

  createFanChart(
    container: HTMLElement,
    data: {
      timePoints: number[];
      percentiles: Record<string, number[]>;
    },
    options: {
      width?: number;
      height?: number;
      margin?: { top: number; right: number; bottom: number; left: number };
      colors?: Record<string, string>;
    } = {}
  ): void {
    const {
      width = 800,
      height = 400,
      margin = { top: 20, right: 30, bottom: 50, left: 80 },
      colors = {
        p5_p95: '#e0e7ff',  // Light blue
        p10_p90: '#c7d2fe',
        p25_p75: '#a5b4fc',
        median: '#4f46e5'   // Indigo
      }
    } = options;

    // Clear previous chart
    d3.select(container).selectAll('*').remove();

    const innerWidth = width - margin.left - margin.right;
    const innerHeight = height - margin.top - margin.bottom;

    // Create SVG
    const svg = d3.select(container)
      .append('svg')
      .attr('width', width)
      .attr('height', height)
      .append('g')
      .attr('transform', `translate(${margin.left},${margin.top})`);

    // Scales
    const xScale = d3.scaleLinear()
      .domain([0, d3.max(data.timePoints)!])
      .range([0, innerWidth]);

    const allValues = Object.values(data.percentiles).flat();
    const yScale = d3.scaleLinear()
      .domain([0, d3.max(allValues)! * 1.1])
      .range([innerHeight, 0]);

    // Create area generators for confidence bands
    const createArea = (lowerKey: string, upperKey: string) => {
      return d3.area<number>()
        .x((_, i) => xScale(data.timePoints[i]))
        .y0((_, i) => yScale(data.percentiles[lowerKey][i]))
        .y1((_, i) => yScale(data.percentiles[upperKey][i]))
        .curve(d3.curveMonotoneX);
    };

    // Draw confidence bands (outer to inner)
    svg.append('path')
      .datum(data.timePoints)
      .attr('fill', colors.p5_p95)
      .attr('d', createArea('p5', 'p95'));

    svg.append('path')
      .datum(data.timePoints)
      .attr('fill', colors.p10_p90)
      .attr('d', createArea('p10', 'p90'));

    svg.append('path')
      .datum(data.timePoints)
      .attr('fill', colors.p25_p75)
      .attr('d', createArea('p25', 'p75'));

    // Draw median line
    const line = d3.line<number>()
      .x((_, i) => xScale(data.timePoints[i]))
      .y((_, i) => yScale(data.percentiles['p50'][i]))
      .curve(d3.curveMonotoneX);

    svg.append('path')
      .datum(data.timePoints)
      .attr('fill', 'none')
      .attr('stroke', colors.median)
      .attr('stroke-width', 2.5)
      .attr('d', line);

    // Axes
    const xAxis = d3.axisBottom(xScale)
      .ticks(10)
      .tickFormat(d => `Year ${d}`);

    const yAxis = d3.axisLeft(yScale)
      .ticks(8)
      .tickFormat(d => d3.format(',.0f')(d as number));

    svg.append('g')
      .attr('transform', `translate(0,${innerHeight})`)
      .call(xAxis)
      .append('text')
      .attr('x', innerWidth / 2)
      .attr('y', 40)
      .attr('fill', '#374151')
      .attr('text-anchor', 'middle')
      .text('Investment Horizon');

    svg.append('g')
      .call(yAxis)
      .append('text')
      .attr('transform', 'rotate(-90)')
      .attr('x', -innerHeight / 2)
      .attr('y', -60)
      .attr('fill', '#374151')
      .attr('text-anchor', 'middle')
      .text('Portfolio Value (INR)');

    // Add interactive tooltip
    this.addTooltip(svg, data, xScale, yScale, innerHeight);
  }

  private addTooltip(
    svg: d3.Selection<SVGGElement, unknown, null, undefined>,
    data: any,
    xScale: d3.ScaleLinear<number, number>,
    yScale: d3.ScaleLinear<number, number>,
    height: number
  ): void {
    const tooltip = d3.select('body')
      .append('div')
      .attr('class', 'tooltip')
      .style('position', 'absolute')
      .style('visibility', 'hidden')
      .style('background', 'white')
      .style('border', '1px solid #ccc')
      .style('padding', '10px')
      .style('border-radius', '4px')
      .style('box-shadow', '0 2px 4px rgba(0,0,0,0.1)');

    const verticalLine = svg.append('line')
      .attr('stroke', '#6b7280')
      .attr('stroke-width', 1)
      .attr('stroke-dasharray', '4')
      .style('visibility', 'hidden');

    svg.append('rect')
      .attr('width', xScale.range()[1])
      .attr('height', height)
      .attr('fill', 'transparent')
      .on('mousemove', (event) => {
        const [mouseX] = d3.pointer(event);
        const yearIndex = Math.round(xScale.invert(mouseX));

        if (yearIndex >= 0 && yearIndex < data.timePoints.length) {
          verticalLine
            .attr('x1', xScale(yearIndex))
            .attr('x2', xScale(yearIndex))
            .attr('y1', 0)
            .attr('y2', height)
            .style('visibility', 'visible');

          tooltip
            .style('visibility', 'visible')
            .style('left', `${event.pageX + 15}px`)
            .style('top', `${event.pageY - 10}px`)
            .html(`
              <strong>Year ${yearIndex}</strong><br/>
              95th: ₹${d3.format(',.0f')(data.percentiles.p95[yearIndex])}<br/>
              75th: ₹${d3.format(',.0f')(data.percentiles.p75[yearIndex])}<br/>
              <strong>Median: ₹${d3.format(',.0f')(data.percentiles.p50[yearIndex])}</strong><br/>
              25th: ₹${d3.format(',.0f')(data.percentiles.p25[yearIndex])}<br/>
              5th: ₹${d3.format(',.0f')(data.percentiles.p5[yearIndex])}
            `);
        }
      })
      .on('mouseout', () => {
        tooltip.style('visibility', 'hidden');
        verticalLine.style('visibility', 'hidden');
      });
  }
}
```

---

## 10. Testing & Validation

### 10.1 Unit Tests for Simulation Engine

```python
# test_monte_carlo.py
import pytest
import numpy as np
from monte_carlo_engine import (
    simulate_gbm_paths,
    calculate_var_cvar,
    black_litterman_model
)

class TestGBMSimulation:
    """Test suite for Geometric Brownian Motion simulation"""

    def test_initial_value(self):
        """Verify all paths start at initial value"""
        paths = simulate_gbm_paths(
            S0=100, mu=0.1, sigma=0.2, T=1, dt=1/252, num_paths=1000
        )
        assert np.allclose(paths[:, 0], 100)

    def test_path_shape(self):
        """Verify correct output shape"""
        T, dt, num_paths = 1, 1/252, 1000
        paths = simulate_gbm_paths(
            S0=100, mu=0.1, sigma=0.2, T=T, dt=dt, num_paths=num_paths
        )
        expected_steps = int(T / dt) + 1
        assert paths.shape == (num_paths, expected_steps)

    def test_positive_prices(self):
        """GBM should produce only positive prices"""
        paths = simulate_gbm_paths(
            S0=100, mu=0.1, sigma=0.5, T=5, dt=1/252, num_paths=10000
        )
        assert np.all(paths > 0)

    def test_expected_return(self):
        """Test that mean return approximates drift"""
        np.random.seed(42)
        S0, mu, sigma, T = 100, 0.10, 0.20, 1
        num_simulations = 100000

        paths = simulate_gbm_paths(
            S0=S0, mu=mu, sigma=sigma, T=T, dt=1/252, num_paths=num_simulations
        )

        final_values = paths[:, -1]
        expected_final = S0 * np.exp(mu * T)
        simulated_mean = np.mean(final_values)

        # Should be within 2% of expected
        assert abs(simulated_mean - expected_final) / expected_final < 0.02

    def test_volatility(self):
        """Test that simulated volatility matches input"""
        np.random.seed(42)
        S0, mu, sigma, T = 100, 0.08, 0.25, 1

        paths = simulate_gbm_paths(
            S0=S0, mu=mu, sigma=sigma, T=T, dt=1/252, num_paths=50000
        )

        # Calculate log returns
        log_returns = np.log(paths[:, -1] / paths[:, 0]) / T
        simulated_volatility = np.std(log_returns) * np.sqrt(1)

        # Should be within 5% of input volatility
        assert abs(simulated_volatility - sigma) / sigma < 0.05


class TestVaRCVaR:
    """Test suite for Value at Risk calculations"""

    def test_var_ordering(self):
        """VaR should increase with confidence level"""
        np.random.seed(42)
        returns = np.random.normal(-0.01, 0.02, 10000)

        result = calculate_var_cvar(returns, [0.90, 0.95, 0.99])

        # More confident VaR should be more negative (larger loss)
        assert result['VaR_90'] > result['VaR_95'] > result['VaR_99']

    def test_cvar_worse_than_var(self):
        """CVaR should always be worse (more negative) than VaR"""
        np.random.seed(42)
        returns = np.random.normal(-0.01, 0.02, 10000)

        result = calculate_var_cvar(returns, [0.95])

        assert result['CVaR_95'] < result['VaR_95']

    def test_var_percentage(self):
        """Approximately correct % of returns should exceed VaR"""
        np.random.seed(42)
        returns = np.random.normal(0, 0.02, 100000)

        result = calculate_var_cvar(returns, [0.95])
        var_95 = result['VaR_95']

        # About 5% should be below VaR
        pct_below = np.mean(returns < var_95)
        assert abs(pct_below - 0.05) < 0.01


class TestBlackLitterman:
    """Test suite for Black-Litterman model"""

    def test_no_views_equals_equilibrium(self):
        """With no views, returns should equal equilibrium returns"""
        # Setup
        weights = np.array([0.4, 0.3, 0.3])
        cov = np.array([
            [0.04, 0.01, 0.02],
            [0.01, 0.03, 0.015],
            [0.02, 0.015, 0.05]
        ])
        risk_aversion = 2.5

        # Empty views (identity)
        P = np.eye(3)
        Q = risk_aversion * np.dot(cov, weights)  # Equilibrium
        omega = np.eye(3) * 1e-10  # Very low uncertainty

        expected_returns, _ = black_litterman_model(
            weights, cov, risk_aversion, P, Q, omega, tau=0.05
        )

        equilibrium = risk_aversion * np.dot(cov, weights)

        # Should be close to equilibrium
        assert np.allclose(expected_returns, equilibrium, rtol=0.1)


class TestPerformanceBenchmarks:
    """Performance benchmarks for simulation engine"""

    @pytest.mark.benchmark
    def test_simulation_speed(self, benchmark):
        """Benchmark simulation performance"""
        result = benchmark(
            simulate_gbm_paths,
            S0=100, mu=0.1, sigma=0.2, T=1, dt=1/252, num_paths=10000
        )

        # Should complete 10K simulations in under 1 second
        assert benchmark.stats['mean'] < 1.0

    @pytest.mark.benchmark
    def test_large_scale_simulation(self, benchmark):
        """Benchmark large-scale simulation"""
        result = benchmark(
            simulate_gbm_paths,
            S0=100, mu=0.1, sigma=0.2, T=1, dt=1/252, num_paths=100000
        )

        # Should complete 100K simulations in under 5 seconds
        assert benchmark.stats['mean'] < 5.0
```

### 10.2 Integration Tests

```python
# test_integration.py
import pytest
from fastapi.testclient import TestClient
from main import app
import json

client = TestClient(app)

class TestSimulationAPI:
    """Integration tests for simulation API endpoints"""

    def test_create_simulation(self):
        """Test creating a new simulation"""
        request_data = {
            "portfolio_id": "test-portfolio-001",
            "customer_id": "test-customer-001",
            "allocations": [
                {"ticker": "NIFTY50 Index", "weight": 0.6},
                {"ticker": "GSEC 10Y", "weight": 0.4}
            ],
            "initial_investment": 1000000,
            "monthly_contribution": 10000,
            "time_horizon_years": 10,
            "num_simulations": 1000,
            "confidence_levels": [0.90, 0.95],
            "include_inflation": True,
            "inflation_rate": 0.06
        }

        response = client.post("/api/v1/simulations", json=request_data)

        assert response.status_code == 200
        data = response.json()
        assert "simulation_id" in data
        assert "expected_final_value" in data
        assert "var_95" in data

    def test_get_simulation(self):
        """Test retrieving simulation results"""
        # First create a simulation
        create_response = client.post("/api/v1/simulations", json={...})
        simulation_id = create_response.json()["simulation_id"]

        # Then retrieve it
        response = client.get(f"/api/v1/simulations/{simulation_id}")

        assert response.status_code == 200
        assert response.json()["simulation_id"] == simulation_id

    def test_invalid_weights(self):
        """Test validation of portfolio weights"""
        request_data = {
            "portfolio_id": "test-portfolio-001",
            "allocations": [
                {"ticker": "NIFTY50", "weight": 0.8},
                {"ticker": "GSEC", "weight": 0.5}  # Weights sum > 1
            ],
            "initial_investment": 1000000,
            "time_horizon_years": 10
        }

        response = client.post("/api/v1/simulations", json=request_data)

        assert response.status_code == 422  # Validation error
```

### 10.3 Validation Against Historical Data

```python
# test_backtest.py
import numpy as np
import pandas as pd
from typing import Tuple

def backtest_simulation(
    historical_data: pd.DataFrame,
    simulation_params: dict,
    lookback_years: int = 10,
    forward_years: int = 5
) -> dict:
    """
    Validate Monte Carlo simulation against historical outcomes

    Methodology:
    1. Use first `lookback_years` to estimate parameters
    2. Simulate `forward_years` ahead
    3. Compare with actual historical outcomes
    4. Calculate accuracy metrics
    """
    # Split data
    split_date = historical_data.index[-1] - pd.DateOffset(years=forward_years)
    train_data = historical_data[historical_data.index <= split_date].tail(lookback_years * 252)
    test_data = historical_data[historical_data.index > split_date]

    # Estimate parameters from training data
    returns = train_data.pct_change().dropna()
    mu = returns.mean() * 252  # Annualized
    sigma = returns.std() * np.sqrt(252)  # Annualized
    S0 = train_data.iloc[-1]

    # Run simulation
    paths = simulate_gbm_paths(
        S0=float(S0),
        mu=float(mu),
        sigma=float(sigma),
        T=forward_years,
        dt=1/252,
        num_paths=10000
    )

    # Actual outcome
    actual_final = float(test_data.iloc[-1])

    # Simulated distribution
    simulated_final = paths[:, -1]

    # Calculate metrics
    percentile_rank = np.mean(simulated_final <= actual_final) * 100

    return {
        "actual_final_value": actual_final,
        "simulated_mean": np.mean(simulated_final),
        "simulated_median": np.median(simulated_final),
        "simulated_5th_percentile": np.percentile(simulated_final, 5),
        "simulated_95th_percentile": np.percentile(simulated_final, 95),
        "actual_percentile_rank": percentile_rank,
        "within_90_confidence": 5 <= percentile_rank <= 95,
        "mape": abs(actual_final - np.mean(simulated_final)) / actual_final * 100
    }
```

---

## Appendix A: References

### IEEE Papers
1. [Sector-Wise Portfolio Risk Assessment: Monte Carlo Simulation of NIFTY 50 Stocks](https://ieeexplore.ieee.org/document/11005178/)
2. [Introduction to Financial Risk Assessment Using Monte Carlo Simulation](https://ieeexplore.ieee.org/document/5429323)
3. [The Application of Monte Carlo Computer Simulation in Investment Risk Analysis](https://ieeexplore.ieee.org/document/5691779)
4. [Model Contest and Portfolio Performance: Black-Litterman versus Factor Models](https://ieeexplore.ieee.org/document/6586329)
5. [Application of Feedforward Neural Network in Portfolio Optimization and GBM](https://ieeexplore.ieee.org/document/10193046)
6. [Prediction of Stock Prices Using Markov Chain Monte Carlo](https://ieeexplore.ieee.org/document/9297965/)
7. [Financial Risk Assessment For Power Plant Investment Under Uncertainty](https://ieeexplore.ieee.org/document/9102631)

### Academic Papers
8. [Portfolio Optimization Using Machine Learning Method and Monte Carlo Simulation (2024)](https://www.researchgate.net/publication/385000245_Portfolio_Optimization_Using_Machine_Learning_Method_and_Monte_Carlo_Simulation)
9. [Risk-Adjusted Portfolio Optimization: Monte Carlo Simulation and Rebalancing (2024)](https://www.researchgate.net/publication/385527804_Risk-Adjusted_Portfolio_Optimization_Monte_Carlo_Simulation_and_Rebalancing)
10. [Black-Litterman Portfolio Optimization with Dynamic CAPM via ABC-MCMC (2025)](https://www.researchgate.net/publication/396512386_Black-Litterman_Portfolio_Optimization_with_Dynamic_CAPM_via_ABC-MCMC)

### Bloomberg Integration
- [xbbg - Intuitive Bloomberg API (GitHub)](https://github.com/alpha-xone/xbbg)
- [pdblp - Pandas Bloomberg Integration (PyPI)](https://pypi.org/project/pdblp/)
- [Bloomberg API Library](https://www.bloomberg.com/professional/support/api-library/)

### Technology Stack Resources
- [Best Fintech Technology Stack 2025 (Svitla Systems)](https://svitla.com/blog/best-fintech-technology-stack-for-2025/)
- [Building a Fintech App: Best Tech Stacks (DEV Community)](https://dev.to/lucas_wade_0596/building-a-fintech-app-in-2025-best-tech-stacks-and-architecture-choices-4n85)
- [Distributed Monte Carlo with Celery Chords](https://celery.school/distributed-monte-carlo-celery-chords)

### Visualization
- [D3.js Official Documentation](https://d3js.org/)
- [Top 10 React Chart Libraries for Data Visualization](https://medium.com/dhiwise/top-10-amazing-chart-libraries-in-react-322cb91fad62)

---

## Document Information

| Field | Value |
|-------|-------|
| **Version** | 1.0 |
| **Created** | December 29, 2025 |
| **Author** | Research & Development Team |
| **Project** | Monte Carlo Finance Simulator |
| **Framework** | GBA System (Goal-Based Advice) |
| **Backend** | Java Spring Boot + Python FastAPI |
| **Frontend** | Angular 19 |
| **Data Source** | Bloomberg Terminal/API |

---

**End of Document**
