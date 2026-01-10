# Bloomberg API Integration Guide
## Complete Guide for Monte Carlo Simulation Data Requirements

**Version:** 1.0
**Created:** December 31, 2025
**Purpose:** Understanding Bloomberg Terminal and API integration for financial simulations

---

## Table of Contents

1. [What is Bloomberg Terminal?](#1-what-is-bloomberg-terminal)
2. [Why Bloomberg for Monte Carlo?](#2-why-bloomberg-for-monte-carlo)
3. [Bloomberg API Overview](#3-bloomberg-api-overview)
4. [Data Requirements for Monte Carlo](#4-data-requirements-for-monte-carlo)
5. [Python Integration - Step by Step](#5-python-integration---step-by-step)
6. [Essential Bloomberg Fields](#6-essential-bloomberg-fields)
7. [Real Examples with Code](#7-real-examples-with-code)
8. [Cost and Licensing](#8-cost-and-licensing)
9. [Alternatives for Development](#9-alternatives-for-development)
10. [Best Practices](#10-best-practices)

---

## 1. What is Bloomberg Terminal?

Bloomberg Terminal is the industry-standard professional financial data platform used by banks, hedge funds, and asset managers worldwide.

**Key Features:**
- Real-time and historical market data for 350+ million securities
- Corporate action adjustments (splits, dividends, mergers)
- Total return indices (includes dividend reinvestment)
- Multi-asset class coverage (stocks, bonds, commodities, FX, derivatives)
- API access for programmatic data retrieval

---

## 2. Why Bloomberg for Monte Carlo?

### The Data Quality Problem

**Scenario: Running Monte Carlo without quality data**

```
Problem 1: Missing Data
─────────────────────────────────────────────────────
Yahoo Finance data for "XYZ Corp":
Date         Close    Volume
2020-01-05   45.67    1,234,567
2020-01-06   46.12    1,456,789
2020-01-07   NULL     NULL        ← Missing!
2020-01-08   NULL     NULL        ← Missing!
2020-01-09   42.34    987,654

Impact on Monte Carlo:
❌ Can't calculate returns for missing days
❌ Volatility calculation is wrong
❌ Simulation results unreliable
```

```
Problem 2: Corporate Actions Not Adjusted
─────────────────────────────────────────────────────
Stock "ABC Inc" did 2:1 stock split on 2022-06-15

Unadjusted data (Yahoo sometimes):
2022-06-14   $100    ← Before split
2022-06-15   $50     ← After split
→ Looks like -50% crash!
→ Volatility calculation: WRONG
→ Monte Carlo simulation: GARBAGE

Bloomberg adjusted data:
2022-06-14   $50     ← Retroactively adjusted
2022-06-15   $50     ← Actual price
→ No artificial price change
→ Correct volatility
→ Accurate simulation
```

```
Problem 3: Dividend Data Missing
─────────────────────────────────────────────────────
Total Return = Price appreciation + Dividends

Without dividend data:
- Underestimate historical returns
- Wrong expected return (μ) in simulation
- Client gets pessimistic projections

Example:
Stock XYZ (10 years):
Price return:       +80%
Total return:       +120% (including dividends)
Difference:         40% WRONG!
```

### Bloomberg Solves These Problems

```
✅ Complete Data Coverage
   - No gaps in historical data
   - Fills missing values intelligently
   - Quality checks automated

✅ Corporate Action Adjustments
   - Stock splits automatically adjusted
   - Dividend adjustments included
   - Mergers & acquisitions handled

✅ Total Return Indices
   - Includes dividend reinvestment
   - Shows true investor returns
   - Critical for accurate simulations

✅ Multi-Asset Class Support
   - Stocks: Global coverage
   - Bonds: Government, corporate, muni
   - Commodities: Gold, oil, metals
   - FX: All currency pairs
   - Derivatives: Options, futures
```

---

## 3. Bloomberg API Overview

Bloomberg provides Python API access through the `blpapi` library. For our MVP, we'll use the **xbbg** wrapper library which simplifies Bloomberg API integration.

**Setup:**
- Backend FastAPI service connects to Bloomberg Platform
- Retrieves historical and real-time market data
- Processes data for Monte Carlo simulation inputs

---

## 4. Data Requirements for Monte Carlo

### Essential Data Points

```
For accurate Monte Carlo simulation, we need:

1. HISTORICAL PRICES
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Field: PX_LAST (Last Price)
   Frequency: Daily
   Period: Minimum 10 years, ideally 20+ years
   Why: Calculate historical returns and volatility

2. TOTAL RETURN INDEX
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Field: TOT_RETURN_INDEX_GROSS_DVDS
   Why: Includes dividend reinvestment
        Shows true investor returns

3. VOLATILITY
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Fields: VOLATILITY_30D, VOLATILITY_90D, VOLATILITY_260D
   Why: Can use Bloomberg's calculated volatility
        Or calculate from price data

4. CORRELATION DATA
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Why: For multi-asset portfolios
   Calculate: From historical returns of all assets

5. RISK-FREE RATE
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Field: Government bond yields
   Example: GIND10YR Index (10-year Indian Government)
   Why: For Sharpe ratio, discounting

6. CORPORATE ACTIONS
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Automatically handled: Bloomberg adjusts prices
   Includes: Splits, dividends, mergers
```

### Data Requirements by Asset Class

```
┌─────────────────────┬──────────────────────────────────┐
│   Asset Class       │   Bloomberg Tickers / Fields     │
├─────────────────────┼──────────────────────────────────┤
│ Indian Equities     │ NIFTY Index                      │
│                     │ - Individual stocks: RELIANCE IN │
│                     │ - Nifty 50: NSEI Index           │
│                     │ - Sensex: SENSEX Index           │
├─────────────────────┼──────────────────────────────────┤
│ US Equities         │ S&P 500: SPX Index               │
│                     │ Individual: AAPL US Equity       │
├─────────────────────┼──────────────────────────────────┤
│ Government Bonds    │ India: GIND10YR Index            │
│                     │ US: USGG10YR Index               │
├─────────────────────┼──────────────────────────────────┤
│ Corporate Bonds     │ India Corporate: ICRR Index      │
│                     │ Rating-specific indices          │
├─────────────────────┼──────────────────────────────────┤
│ Gold                │ GOLD Commodity                   │
│                     │ Or: GOLDBEES IN Equity (ETF)     │
├─────────────────────┼──────────────────────────────────┤
│ Currency            │ USDINR Curncy                    │
│                     │ EURINR Curncy                    │
└─────────────────────┴──────────────────────────────────┘
```

---

## 5. Python Integration - Step by Step

### Step 1: Installation

```bash
# Official Bloomberg API
python -m pip install --index-url=https://blpapi.bloomberg.com/repository/releases/python/simple/ blpapi

# Recommended wrapper (xbbg)
pip install xbbg

# Alternative: pandas integration
pip install pdblp  # Note: No longer actively maintained
```

### Step 2: Authentication & Connection

```python
# Method 1: Desktop API (if Terminal is running on same machine)
from xbbg import blp

# No authentication needed - connects to local Terminal
# Just ensure Bloomberg Terminal is running and logged in
```

```python
# Method 2: Server API (Production setup)
import blpapi

# Configuration
session_options = blpapi.SessionOptions()
session_options.setServerHost('localhost')  # Or Bloomberg server IP
session_options.setServerPort(8194)

# Create session
session = blpapi.Session(session_options)

# Start session
if not session.start():
    print("Failed to start session")
    exit()

# Open service
if not session.openService("//blp/refdata"):
    print("Failed to open //blp/refdata")
    exit()

print("✅ Connected to Bloomberg!")
```

### Step 3: Basic Data Retrieval

```python
from xbbg import blp
import pandas as pd
from datetime import datetime, timedelta

# Get historical prices for Nifty 50
ticker = 'NSEI Index'
end_date = datetime.today()
start_date = end_date - timedelta(days=365*10)  # 10 years

# Fetch data
historical_data = blp.bdh(
    tickers=ticker,
    flds=['PX_LAST', 'PX_VOLUME'],  # Fields to retrieve
    start_date=start_date.strftime('%Y%m%d'),
    end_date=end_date.strftime('%Y%m%d')
)

print(historical_data.head())
```

**Output:**
```
              PX_LAST  PX_VOLUME
date
2015-01-01   8284.00   234567890
2015-01-02   8322.50   198765432
2015-01-05   8420.75   287654321
2015-01-06   8456.20   256789012
2015-01-07   8398.30   245678901
```

### Step 4: Multi-Asset Data Retrieval

```python
# Get data for multiple assets
tickers = [
    'NSEI Index',      # Nifty 50
    'GIND10YR Index',  # 10-year Government Bond
    'GOLD Commodity',  # Gold
    'USDINR Curncy'    # USD/INR
]

# Fetch historical prices
portfolio_data = blp.bdh(
    tickers=tickers,
    flds='PX_LAST',
    start_date='20200101',
    end_date='20251231'
)

print(portfolio_data.head())
```

**Output:**
```
           NSEI Index  GIND10YR Index  GOLD Commodity  USDINR Curncy
date
2020-01-01    12119.00           6.57         1520.10          71.38
2020-01-02    12282.20           6.59         1528.30          71.42
2020-01-03    12256.80           6.61         1552.60          71.36
```

---

## 6. Essential Bloomberg Fields

### Price & Returns

```python
BLOOMBERG_PRICE_FIELDS = {
    # Current Prices
    'PX_LAST':          'Last Price',
    'PX_OPEN':          'Opening Price',
    'PX_HIGH':          'High Price',
    'PX_LOW':           'Low Price',
    'PX_VOLUME':        'Volume',

    # Adjusted Prices
    'PX_LAST_EOD':      'End of Day Price (Corporate action adjusted)',

    # Total Return
    'TOT_RETURN_INDEX_GROSS_DVDS': 'Total Return Index (includes dividends)',

    # Returns
    'CHG_PCT_1D':       '1-Day % Change',
    'CHG_PCT_YTD':      'Year-to-Date % Change',
    'RETURN_COM_EQY':   'Total Return',
}
```

### Volatility & Risk

```python
BLOOMBERG_RISK_FIELDS = {
    # Historical Volatility
    'VOLATILITY_30D':   '30-Day Historical Volatility',
    'VOLATILITY_90D':   '90-Day Historical Volatility',
    'VOLATILITY_260D':  '260-Day (1-year) Historical Volatility',

    # Implied Volatility (for options)
    'IVOL_SURFACE':     'Implied Volatility Surface',

    # Beta
    'BETA_ADJ_OVERRIDABLE': 'Adjusted Beta (vs market)',

    # Correlation
    'CORRELATION_260D': '260-Day Correlation',

    # Value at Risk
    'HIST_VAR_95':      'Historical VaR (95%)',
    'HIST_VAR_99':      'Historical VaR (99%)',
}
```

### Fundamental Data

```python
BLOOMBERG_FUNDAMENTAL_FIELDS = {
    # Valuation
    'PE_RATIO':             'Price/Earnings Ratio',
    'PX_TO_BOOK_RATIO':     'Price/Book Ratio',
    'DIVIDEND_YIELD':       'Dividend Yield',
    'EARN_YLD':             'Earnings Yield',

    # Dividends
    'DVD_HIST':             'Dividend History',
    'DVD_PAYOUT_RATIO':     'Dividend Payout Ratio',

    # Financial Metrics
    'TRAIL_12M_EPS':        'Trailing 12-Month EPS',
    'CUR_MKT_CAP':          'Current Market Cap',
    'BOOK_VAL_PER_SH':      'Book Value per Share',
}
```

### Portfolio Analytics

```python
BLOOMBERG_PORTFOLIO_FIELDS = {
    # Portfolio-level metrics
    'PORT_PRCH_SHARPE_RATIO':    'Portfolio Sharpe Ratio',
    'PORT_PRCH_RETURN':          'Portfolio Return',
    'PORT_PRCH_VAR':             'Portfolio VaR',
    'PORT_PRCH_TRACKING_ERR':    'Tracking Error',

    # Holdings
    'PORTFOLIO_MWEIGHT':         'Portfolio Weights',
    'PORTFOLIO_HOLDINGS':        'Portfolio Holdings',
}
```

---

## 7. Real Examples with Code

### Example 1: Fetch Data for Monte Carlo

```python
"""
Complete example: Fetch and prepare data for Monte Carlo simulation
"""

from xbbg import blp
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

class BloombergDataFetcher:
    """Fetch Bloomberg data for Monte Carlo simulation"""

    def __init__(self):
        self.data = None
        self.returns = None
        self.stats = {}

    def fetch_historical_data(self, tickers, years=10):
        """
        Fetch historical price data

        Args:
            tickers: List of Bloomberg tickers
            years: Number of years of history

        Returns:
            DataFrame with historical prices
        """
        end_date = datetime.today()
        start_date = end_date - timedelta(days=365*years)

        print(f"📊 Fetching {years} years of data for {len(tickers)} assets...")

        # Fetch total return index (includes dividends)
        self.data = blp.bdh(
            tickers=tickers,
            flds='TOT_RETURN_INDEX_GROSS_DVDS',
            start_date=start_date.strftime('%Y%m%d'),
            end_date=end_date.strftime('%Y%m%d'),
            adjust='all'  # Adjust for corporate actions
        )

        print(f"✅ Fetched {len(self.data)} days of data")
        print(f"📅 From {self.data.index[0]} to {self.data.index[-1]}")

        return self.data

    def calculate_returns(self):
        """Calculate daily returns from prices"""
        if self.data is None:
            raise ValueError("No data available. Call fetch_historical_data() first")

        # Calculate log returns (better for long periods)
        self.returns = np.log(self.data / self.data.shift(1))
        self.returns = self.returns.dropna()

        print(f"✅ Calculated returns for {len(self.returns)} days")

        return self.returns

    def calculate_statistics(self):
        """Calculate mean, volatility, correlation for Monte Carlo"""
        if self.returns is None:
            raise ValueError("No returns available. Call calculate_returns() first")

        # Annualize returns (252 trading days per year)
        annual_returns = self.returns.mean() * 252
        annual_volatility = self.returns.std() * np.sqrt(252)

        # Correlation matrix
        correlation_matrix = self.returns.corr()

        # Covariance matrix (needed for portfolio simulation)
        covariance_matrix = self.returns.cov() * 252  # Annualized

        self.stats = {
            'returns': annual_returns,
            'volatility': annual_volatility,
            'correlation': correlation_matrix,
            'covariance': covariance_matrix
        }

        print("\n📈 Statistical Summary:")
        print("="*60)
        for ticker in annual_returns.index:
            print(f"{ticker:30s} Return: {annual_returns[ticker]:7.2%}  "
                  f"Vol: {annual_volatility[ticker]:6.2%}")
        print("="*60)

        return self.stats

    def get_simulation_inputs(self):
        """Return data formatted for Monte Carlo simulation"""
        return {
            'expected_returns': self.stats['returns'].values,
            'volatility': self.stats['volatility'].values,
            'correlation_matrix': self.stats['correlation'].values,
            'covariance_matrix': self.stats['covariance'].values,
            'asset_names': self.stats['returns'].index.tolist()
        }


# Usage Example
if __name__ == "__main__":
    # Define portfolio
    portfolio_tickers = [
        'NSEI Index',      # Indian Equities (Nifty 50)
        'GIND10YR Index',  # Indian Government Bonds
        'GOLD Commodity',  # Gold
    ]

    # Fetch data
    fetcher = BloombergDataFetcher()
    data = fetcher.fetch_historical_data(portfolio_tickers, years=10)

    # Calculate returns
    returns = fetcher.calculate_returns()

    # Calculate statistics
    stats = fetcher.calculate_statistics()

    # Get simulation inputs
    sim_inputs = fetcher.get_simulation_inputs()

    print("\n🎯 Ready for Monte Carlo simulation!")
    print(f"Assets: {sim_inputs['asset_names']}")
    print(f"Expected Returns: {sim_inputs['expected_returns']}")
    print(f"Volatilities: {sim_inputs['volatility']}")
```

**Output:**
```
📊 Fetching 10 years of data for 3 assets...
✅ Fetched 2520 days of data
📅 From 2015-01-01 to 2024-12-31

✅ Calculated returns for 2519 days

📈 Statistical Summary:
============================================================
NSEI Index                     Return:  12.34%  Vol:  18.50%
GIND10YR Index                 Return:   6.80%  Vol:   7.20%
GOLD Commodity                 Return:   9.50%  Vol:  15.30%
============================================================

🎯 Ready for Monte Carlo simulation!
Assets: ['NSEI Index', 'GIND10YR Index', 'GOLD Commodity']
Expected Returns: [0.1234 0.0680 0.0950]
Volatilities: [0.1850 0.0720 0.1530]
```


---

## 8. Cost and Licensing

**Bloomberg Terminal Pricing:**
- Standard License: ~$24,000 - $27,000 per year per terminal
- Server API: Additional licensing for production use
- Institutional-grade data quality justifies cost for production systems

---

## 9. Alternatives for Development/POC

**For development and testing without Bloomberg access:**

**Yahoo Finance (yfinance):**
- Free, no authentication required
- Good for major stocks and indices
- 15-minute delayed data
- ✅ Use for: Initial development and testing Monte Carlo engine
- ❌ Not for: Production or regulatory compliance

**Example Code:**
```python
import yfinance as yf
import numpy as np

# Fetch data for development
def fetch_yahoo_data(tickers, period='10y'):
    """Fetch data from Yahoo Finance (development only)"""
    data = yf.download(
        tickers=tickers,
        period=period,
        auto_adjust=True,  # Adjust for splits and dividends
        progress=False
    )['Close']
    return data

# Example usage
tickers = ['^NSEI', 'GC=F']  # Nifty 50, Gold
data = fetch_yahoo_data(tickers, period='10y')

# Calculate returns (same process as Bloomberg)
returns = np.log(data / data.shift(1)).dropna()
annual_returns = returns.mean() * 252
annual_vol = returns.std() * np.sqrt(252)
```

**Note:** Use Yahoo Finance only for development. Bloomberg data required for production.

---

## 10. Best Practices

### Data Quality Validation

```python
def validate_bloomberg_data(data):
    """Validate Bloomberg data before Monte Carlo simulation"""
    issues = []

    # Check missing values
    missing_pct = data.isnull().sum() / len(data) * 100
    if (missing_pct > 5).any():
        issues.append(f"⚠️ Missing data: {missing_pct[missing_pct > 5]}")

    # Check suspicious returns
    returns = data.pct_change()
    if (abs(returns) > 0.5).any().any():
        issues.append("⚠️ Suspicious large daily returns detected")

    # Check data gaps
    dates = pd.to_datetime(data.index)
    gaps = dates.diff().dt.days
    if (gaps > 5).any():
        issues.append(f"⚠️ Data gaps detected: max {gaps.max()} days")

    if issues:
        print("❌ Data Quality Issues:")
        for issue in issues:
            print(f"   {issue}")
        return False
    else:
        print("✅ Data quality checks passed")
        return True
```

### Error Handling

```python
from xbbg import blp
import time

def safe_bloomberg_request(func, max_retries=3, delay=5):
    """Wrapper for Bloomberg requests with retry logic"""
    for attempt in range(max_retries):
        try:
            return func()
        except Exception as e:
            print(f"❌ Attempt {attempt + 1} failed: {e}")
            if attempt < max_retries - 1:
                print(f"⏳ Retrying in {delay} seconds...")
                time.sleep(delay)
            else:
                raise

# Usage
data = safe_bloomberg_request(
    lambda: blp.bdh(tickers='NSEI Index', flds='PX_LAST',
                    start_date='20200101', end_date='20241231')
)
```

---

## Summary

### Key Takeaways

✅ Bloomberg provides institutional-grade financial data essential for production Monte Carlo simulations

✅ Python integration via **xbbg** library simplifies Bloomberg API access

✅ Critical data fields: **TOT_RETURN_INDEX_GROSS_DVDS** (includes dividends), historical prices, volatility

✅ Data quality and corporate action adjustments are critical for accurate simulations

✅ Yahoo Finance available as free alternative for development and testing

✅ Always validate data quality before running simulations (missing values, gaps, suspicious returns)

---

**Next Steps:**

1. ✅ **Understand Bloomberg's role** (This document)
2. ➡️ **Read Next:** `TECH_STACK_ARCHITECTURE.md` - See how Bloomberg integrates with FastAPI and Monte Carlo engine
3. **Then:** `IMPLEMENTATION_GUIDE.md` - Complete code examples and implementation steps

**Document Version:** 1.0 (MVP)
**Last Updated:** December 31, 2025
