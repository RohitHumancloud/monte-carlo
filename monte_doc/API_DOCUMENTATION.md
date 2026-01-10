# Monte Carlo Simulation API Documentation

**Version:** 1.0
**Base URL:** `https://api.montecarlo.example.com` (production)
**Base URL:** `http://localhost:8000` (development)

---

## 📋 Table of Contents

1. [Getting Started](#getting-started)
2. [Authentication](#authentication)
3. [API Endpoints](#api-endpoints)
4. [Request Schema](#request-schema)
5. [Response Schema](#response-schema)
6. [Error Codes](#error-codes)
7. [Code Examples](#code-examples)
8. [Best Practices](#best-practices)
9. [Rate Limits](#rate-limits)
10. [Support](#support)

---

## Getting Started

### Step 1: Sign Up

1. Visit the Monte Carlo dashboard: `https://dashboard.montecarlo.example.com`
2. Click "Sign Up" and create an account
3. Verify your email address

### Step 2: Generate API Keys

1. Login to your dashboard
2. Navigate to "API Keys" section
3. Click "Generate New API Key"
4. **IMPORTANT:** Copy and save the API key immediately (it won't be shown again)
5. Generate at least **2 API keys** (required minimum)

### Step 3: Make Your First API Call

```bash
curl -X POST https://api.montecarlo.example.com/api/v1/simulate \
  -H "X-API-Key: mk_live_your_api_key_here" \
  -H "Content-Type: application/json" \
  -d '{
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
  }'
```

---

## Authentication

### API Key Authentication

All API requests must include your API key in the `X-API-Key` header:

```
X-API-Key: mk_live_your_api_key_here
```

**Example:**

```bash
curl -X POST https://api.montecarlo.example.com/api/v1/simulate \
  -H "X-API-Key: mk_live_abc123xyz789def456ghi012"
```

### API Key Lifecycle

- **Validity Period:** 30 days from creation
- **Status:** Active, Expired, or Revoked
- **Minimum Required:** 2 active API keys per account
- **Maximum Allowed:** 10 active API keys per account

**Important Notes:**
- ⚠️ API keys expire after 30 days (free trial period)
- ⚠️ You cannot reactivate a revoked API key
- ⚠️ You must maintain at least 2 active keys (cannot revoke if you have only 2)
- ✅ Generate new keys before old ones expire

---

## API Endpoints

### Health Check

**Endpoint:** `GET /health`

**Description:** Check API status

**Authentication:** Not required

**Response:**
```json
{
  "status": "healthy",
  "app": "Monte Carlo SaaS MVP",
  "version": "1.0.0"
}
```

**Example:**
```bash
curl https://api.montecarlo.example.com/health
```

---

### Run Monte Carlo Simulation

**Endpoint:** `POST /api/v1/simulate`

**Description:** Run Monte Carlo simulation for portfolio projection

**Authentication:** Required (API key)

**Headers:**
- `X-API-Key`: Your API key (required)
- `Content-Type`: `application/json` (required)

**Request Body:** See [Request Schema](#request-schema)

**Response:** See [Response Schema](#response-schema)

**Example:**
```bash
curl -X POST https://api.montecarlo.example.com/api/v1/simulate \
  -H "X-API-Key: mk_live_your_api_key_here" \
  -H "Content-Type: application/json" \
  -d @request.json
```

---

## Request Schema

### Complete Request Example

```json
{
  "portfolio": {
    "assets": [
      {
        "ticker": "NSEI Index",
        "weight": 0.6,
        "asset_class": "equity"
      },
      {
        "ticker": "GIND10YR Index",
        "weight": 0.3,
        "asset_class": "bonds"
      },
      {
        "ticker": "GOLD Commodity",
        "weight": 0.1,
        "asset_class": "commodity"
      }
    ]
  },
  "parameters": {
    "initial_investment": 1000000,
    "monthly_contribution": 50000,
    "time_horizon_years": 10,
    "num_simulations": 10000,
    "confidence_levels": [0.90, 0.95, 0.99]
  },
  "options": {
    "include_inflation": true,
    "inflation_rate": 0.06,
    "rebalancing_frequency": "quarterly"
  }
}
```

### Field Definitions

#### `portfolio` (object, required)

Portfolio configuration with asset allocation.

**Fields:**
- `assets` (array, required): List of assets in the portfolio

#### `portfolio.assets[]` (object, required)

Individual asset in the portfolio.

**Fields:**
- `ticker` (string, required): Bloomberg ticker symbol
  - Examples: `"NSEI Index"`, `"GIND10YR Index"`, `"SPX Index"`
- `weight` (float, required): Asset weight in portfolio (0.0 to 1.0)
  - Must sum to 1.0 across all assets
  - Example: `0.6` (60%)
- `asset_class` (string, required): Asset class category
  - Values: `"equity"`, `"bonds"`, `"commodity"`, `"real_estate"`, `"cash"`

**Constraints:**
- Minimum 1 asset, maximum 20 assets
- All weights must sum to 1.0 (±0.01 tolerance)

#### `parameters` (object, required)

Simulation parameters.

**Fields:**
- `initial_investment` (float, required): Starting investment amount
  - Minimum: `1000`
  - Maximum: `1000000000` (1 billion)
  - Currency: Base currency (USD, INR, etc.)
- `monthly_contribution` (float, optional): Monthly contribution amount
  - Default: `0`
  - Minimum: `0`
  - Maximum: `10000000` (10 million)
- `time_horizon_years` (integer, required): Investment time horizon in years
  - Minimum: `1`
  - Maximum: `50`
- `num_simulations` (integer, optional): Number of Monte Carlo paths to simulate
  - Default: `10000`
  - Minimum: `1000`
  - Maximum: `100000`
  - **Note:** Higher values = more accurate but slower
- `confidence_levels` (array of floats, optional): Confidence levels for percentiles
  - Default: `[0.90, 0.95, 0.99]`
  - Values must be between 0.0 and 1.0

#### `options` (object, optional)

Additional simulation options.

**Fields:**
- `include_inflation` (boolean, optional): Adjust results for inflation
  - Default: `false`
- `inflation_rate` (float, optional): Annual inflation rate (if `include_inflation` is true)
  - Default: `0.03` (3%)
  - Example: `0.06` (6% for India)
- `rebalancing_frequency` (string, optional): Portfolio rebalancing frequency
  - Values: `"never"`, `"monthly"`, `"quarterly"`, `"annually"`
  - Default: `"quarterly"`

---

## Response Schema

### Complete Response Example

```json
{
  "simulation_id": "sim_abc123xyz789",
  "status": "completed",
  "created_at": "2025-12-31T10:30:00Z",
  "execution_time_seconds": 2.34,
  "portfolio": {
    "total_weight": 1.0,
    "num_assets": 3,
    "assets": [
      {
        "ticker": "NSEI Index",
        "weight": 0.6,
        "asset_class": "equity",
        "expected_return": 0.12,
        "volatility": 0.18
      },
      {
        "ticker": "GIND10YR Index",
        "weight": 0.3,
        "asset_class": "bonds",
        "expected_return": 0.07,
        "volatility": 0.05
      },
      {
        "ticker": "GOLD Commodity",
        "weight": 0.1,
        "asset_class": "commodity",
        "expected_return": 0.08,
        "volatility": 0.15
      }
    ]
  },
  "results": {
    "final_portfolio_value": {
      "mean": 2689340.56,
      "median": 2567890.12,
      "std_deviation": 456780.23,
      "min": 1234567.89,
      "max": 5678901.23,
      "percentiles": {
        "p5": 1892340.45,
        "p10": 2043210.67,
        "p25": 2187650.34,
        "p50": 2567890.12,
        "p75": 3124560.78,
        "p90": 3398760.23,
        "p95": 3987650.45,
        "p99": 4567890.12
      }
    },
    "risk_metrics": {
      "var_90": 2043210.67,
      "var_95": 1892340.45,
      "var_99": 1654320.12,
      "cvar_95": 1784560.34,
      "sharpe_ratio": 0.82,
      "sortino_ratio": 1.12,
      "max_drawdown": 0.23
    },
    "probabilities": {
      "probability_of_loss": 0.008,
      "probability_of_doubling": 0.456,
      "probability_reaching_goal": 0.684
    },
    "annualized_returns": {
      "mean": 0.104,
      "median": 0.098,
      "std_deviation": 0.034
    }
  },
  "metadata": {
    "num_simulations": 10000,
    "time_horizon_years": 10,
    "initial_investment": 1000000,
    "monthly_contribution": 50000,
    "total_contributions": 6000000,
    "inflation_adjusted": true,
    "inflation_rate": 0.06
  }
}
```

### Field Definitions

#### Root Level

- `simulation_id` (string): Unique identifier for this simulation
- `status` (string): Simulation status (`"completed"`, `"failed"`)
- `created_at` (string): ISO 8601 timestamp
- `execution_time_seconds` (float): Time taken to run simulation

#### `portfolio` (object)

Portfolio summary with calculated statistics.

**Fields:**
- `total_weight` (float): Sum of all asset weights (should be 1.0)
- `num_assets` (integer): Number of assets in portfolio
- `assets` (array): Asset details with calculated expected returns and volatility

#### `results.final_portfolio_value` (object)

Statistics for final portfolio value after simulation period.

**Fields:**
- `mean` (float): Average final portfolio value across all simulations
- `median` (float): Median final portfolio value (50th percentile)
- `std_deviation` (float): Standard deviation of final values
- `min` (float): Minimum final value across all simulations
- `max` (float): Maximum final value across all simulations
- `percentiles` (object): Percentile values
  - `p5`: 5th percentile (worst case - only 5% of outcomes are worse)
  - `p10`: 10th percentile
  - `p25`: 25th percentile (lower quartile)
  - `p50`: 50th percentile (median)
  - `p75`: 75th percentile (upper quartile)
  - `p90`: 90th percentile
  - `p95`: 95th percentile (best case - only 5% of outcomes are better)
  - `p99`: 99th percentile

#### `results.risk_metrics` (object)

Risk-adjusted performance metrics.

**Fields:**
- `var_90` (float): Value at Risk at 90% confidence (10th percentile)
- `var_95` (float): Value at Risk at 95% confidence (5th percentile)
- `var_99` (float): Value at Risk at 99% confidence (1st percentile)
- `cvar_95` (float): Conditional Value at Risk (average of worst 5% outcomes)
- `sharpe_ratio` (float): Risk-adjusted return metric (higher is better)
  - > 1.0: Good
  - > 2.0: Very good
  - > 3.0: Excellent
- `sortino_ratio` (float): Downside risk-adjusted return (higher is better)
- `max_drawdown` (float): Maximum peak-to-trough decline (0.0 to 1.0)

#### `results.probabilities` (object)

Probability of various outcomes.

**Fields:**
- `probability_of_loss` (float): Probability of ending with less than initial investment (0.0 to 1.0)
- `probability_of_doubling` (float): Probability of at least doubling initial investment
- `probability_reaching_goal` (float): Probability of reaching a specific goal (if provided)

#### `results.annualized_returns` (object)

Annualized return statistics.

**Fields:**
- `mean` (float): Average annualized return across all simulations
- `median` (float): Median annualized return
- `std_deviation` (float): Standard deviation of annualized returns

---

## Error Codes

### HTTP Status Codes

| Status Code | Meaning | Description |
|-------------|---------|-------------|
| 200 | OK | Simulation completed successfully |
| 400 | Bad Request | Invalid request parameters |
| 401 | Unauthorized | Missing API key |
| 403 | Forbidden | Invalid, expired, or revoked API key |
| 422 | Unprocessable Entity | Validation error (weights don't sum to 1.0, etc.) |
| 429 | Too Many Requests | Rate limit exceeded (future) |
| 500 | Internal Server Error | Server error (contact support) |
| 503 | Service Unavailable | Temporary outage (try again later) |

### Error Response Format

```json
{
  "detail": "Error message describing what went wrong",
  "error_code": "ERROR_CODE",
  "timestamp": "2025-12-31T10:30:00Z"
}
```

### Common Errors

#### Missing API Key

**Status:** 401 Unauthorized

```json
{
  "detail": "Missing API key. Include 'X-API-Key' header."
}
```

**Fix:** Add `X-API-Key` header to your request.

---

#### Invalid API Key

**Status:** 403 Forbidden

```json
{
  "detail": "Invalid API key"
}
```

**Fix:** Check that your API key is correct and active in your dashboard.

---

#### Expired API Key

**Status:** 403 Forbidden

```json
{
  "detail": "API key has expired. Please generate a new key from your dashboard."
}
```

**Fix:** Generate a new API key from your dashboard (keys expire after 30 days).

---

#### Revoked API Key

**Status:** 403 Forbidden

```json
{
  "detail": "API key has been revoked"
}
```

**Fix:** Generate a new API key (revoked keys cannot be reactivated).

---

#### Invalid Portfolio Weights

**Status:** 422 Unprocessable Entity

```json
{
  "detail": "Validation error: Portfolio weights must sum to 1.0 (got 0.95)"
}
```

**Fix:** Ensure all asset weights sum to exactly 1.0.

---

#### Invalid Ticker

**Status:** 400 Bad Request

```json
{
  "detail": "Invalid Bloomberg ticker: INVALID_TICKER"
}
```

**Fix:** Use valid Bloomberg ticker symbols (e.g., `"NSEI Index"`, `"SPX Index"`).

---

## Code Examples

### Python

```python
import requests
import json

# Configuration
API_BASE_URL = "https://api.montecarlo.example.com"
API_KEY = "mk_live_your_api_key_here"

# Simulation request
request_data = {
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

# Make API request
response = requests.post(
    f"{API_BASE_URL}/api/v1/simulate",
    headers={
        "X-API-Key": API_KEY,
        "Content-Type": "application/json"
    },
    json=request_data
)

# Handle response
if response.status_code == 200:
    result = response.json()
    print(f"Mean final value: ₹{result['results']['final_portfolio_value']['mean']:,.2f}")
    print(f"Median final value: ₹{result['results']['final_portfolio_value']['median']:,.2f}")
    print(f"VaR (95%): ₹{result['results']['risk_metrics']['var_95']:,.2f}")
else:
    print(f"Error {response.status_code}: {response.json()['detail']}")
```

---

### JavaScript (Node.js)

```javascript
const axios = require('axios');

// Configuration
const API_BASE_URL = 'https://api.montecarlo.example.com';
const API_KEY = 'mk_live_your_api_key_here';

// Simulation request
const requestData = {
  portfolio: {
    assets: [
      { ticker: 'NSEI Index', weight: 0.6, asset_class: 'equity' },
      { ticker: 'GIND10YR Index', weight: 0.4, asset_class: 'bonds' }
    ]
  },
  parameters: {
    initial_investment: 1000000,
    monthly_contribution: 50000,
    time_horizon_years: 10,
    num_simulations: 10000
  }
};

// Make API request
axios.post(`${API_BASE_URL}/api/v1/simulate`, requestData, {
  headers: {
    'X-API-Key': API_KEY,
    'Content-Type': 'application/json'
  }
})
  .then(response => {
    const result = response.data;
    console.log(`Mean final value: ₹${result.results.final_portfolio_value.mean.toLocaleString()}`);
    console.log(`Median final value: ₹${result.results.final_portfolio_value.median.toLocaleString()}`);
    console.log(`VaR (95%): ₹${result.results.risk_metrics.var_95.toLocaleString()}`);
  })
  .catch(error => {
    console.error(`Error ${error.response.status}: ${error.response.data.detail}`);
  });
```

---

### Java (Spring Boot)

```java
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.ObjectMapper;

public class MonteCarloClient {

    private static final String API_BASE_URL = "https://api.montecarlo.example.com";
    private static final String API_KEY = "mk_live_your_api_key_here";

    public static void main(String[] args) {
        RestTemplate restTemplate = new RestTemplate();
        ObjectMapper objectMapper = new ObjectMapper();

        // Build request
        String requestJson = """
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
            """;

        // Set headers
        HttpHeaders headers = new HttpHeaders();
        headers.set("X-API-Key", API_KEY);
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Make request
        HttpEntity<String> request = new HttpEntity<>(requestJson, headers);
        ResponseEntity<String> response = restTemplate.postForEntity(
            API_BASE_URL + "/api/v1/simulate",
            request,
            String.class
        );

        // Handle response
        if (response.getStatusCode() == HttpStatus.OK) {
            System.out.println("Simulation completed: " + response.getBody());
        } else {
            System.err.println("Error: " + response.getStatusCode());
        }
    }
}
```

---

### C# (.NET)

```csharp
using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

public class MonteCarloClient
{
    private static readonly string API_BASE_URL = "https://api.montecarlo.example.com";
    private static readonly string API_KEY = "mk_live_your_api_key_here";

    public static async Task Main(string[] args)
    {
        using (var client = new HttpClient())
        {
            // Set headers
            client.DefaultRequestHeaders.Add("X-API-Key", API_KEY);

            // Build request
            var requestData = new
            {
                portfolio = new
                {
                    assets = new[]
                    {
                        new { ticker = "NSEI Index", weight = 0.6, asset_class = "equity" },
                        new { ticker = "GIND10YR Index", weight = 0.4, asset_class = "bonds" }
                    }
                },
                parameters = new
                {
                    initial_investment = 1000000,
                    monthly_contribution = 50000,
                    time_horizon_years = 10,
                    num_simulations = 10000
                }
            };

            var json = JsonConvert.SerializeObject(requestData);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            // Make request
            var response = await client.PostAsync($"{API_BASE_URL}/api/v1/simulate", content);

            // Handle response
            if (response.IsSuccessStatusCode)
            {
                var result = await response.Content.ReadAsStringAsync();
                Console.WriteLine($"Simulation completed: {result}");
            }
            else
            {
                var error = await response.Content.ReadAsStringAsync();
                Console.WriteLine($"Error {response.StatusCode}: {error}");
            }
        }
    }
}
```

---

### cURL

```bash
#!/bin/bash

API_BASE_URL="https://api.montecarlo.example.com"
API_KEY="mk_live_your_api_key_here"

# Make request
curl -X POST "$API_BASE_URL/api/v1/simulate" \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
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
  }' | jq .
```

---

## Best Practices

### 1. API Key Management

✅ **DO:**
- Store API keys in environment variables (never hardcode)
- Generate separate keys for development and production
- Rotate keys every 30 days (before expiration)
- Revoke compromised keys immediately

❌ **DON'T:**
- Commit API keys to version control (Git, SVN, etc.)
- Share API keys via email or messaging apps
- Use the same key across multiple applications
- Expose API keys in client-side code (JavaScript, mobile apps)

**Example (Python):**
```python
import os
from dotenv import load_dotenv

load_dotenv()  # Load from .env file
API_KEY = os.getenv("MONTE_CARLO_API_KEY")
```

---

### 2. Error Handling

Always handle errors gracefully:

```python
try:
    response = requests.post(url, headers=headers, json=data)
    response.raise_for_status()  # Raise exception for 4xx/5xx
    result = response.json()
except requests.exceptions.HTTPError as e:
    if e.response.status_code == 403:
        print("API key expired - please generate a new key")
    elif e.response.status_code == 422:
        print(f"Validation error: {e.response.json()['detail']}")
    else:
        print(f"HTTP error: {e}")
except requests.exceptions.RequestException as e:
    print(f"Network error: {e}")
```

---

### 3. Simulation Size

- For **quick testing**: Use 1,000-5,000 simulations
- For **production use**: Use 10,000-50,000 simulations
- For **research/accuracy**: Use 50,000-100,000 simulations

**Trade-off:**
- More simulations = More accurate results, but slower execution
- Fewer simulations = Faster execution, but less accurate

---

### 4. Caching Results

If you run the same simulation multiple times, consider caching results:

```python
import hashlib
import json

def get_cache_key(request_data):
    """Generate cache key from request data"""
    request_json = json.dumps(request_data, sort_keys=True)
    return hashlib.sha256(request_json.encode()).hexdigest()

# Check cache before making API call
cache_key = get_cache_key(request_data)
if cache_key in cache:
    result = cache[cache_key]
else:
    result = make_api_call(request_data)
    cache[cache_key] = result
```

---

### 5. Monitoring API Key Expiry

Check API key expiry dates regularly:

```python
from datetime import datetime, timedelta

# Get API key details from dashboard API
api_key_info = get_api_key_info()  # Your dashboard API call
expires_at = datetime.fromisoformat(api_key_info['expires_at'])
days_until_expiry = (expires_at - datetime.now()).days

if days_until_expiry <= 7:
    print(f"⚠️  API key expires in {days_until_expiry} days - generate a new key!")
```

---

## Rate Limits

**Current Limits (MVP):**
- ✅ **No rate limits** (unlimited API calls)
- ✅ **No usage quotas**

**Future Limits (Post-MVP):**
- Free tier: 100 simulations/month
- Pro tier: 1,000 simulations/month
- Enterprise: Unlimited

**Rate Limit Headers (Future):**
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 85
X-RateLimit-Reset: 1672531200
```

---

## SDKs (Future)

We're working on official SDKs for popular languages:

- 🚧 **Python SDK** - In development
- 🚧 **JavaScript/TypeScript SDK** - Planned
- 🚧 **Java SDK** - Planned
- 🚧 **C# SDK** - Planned

For now, use the HTTP API with your preferred HTTP client.

---

## Support

### Help & Documentation

- 📖 **API Documentation:** This document
- 💬 **Community Forum:** `https://community.montecarlo.example.com`
- 📧 **Email Support:** `support@montecarlo.example.com`
- 🐛 **Bug Reports:** `https://github.com/montecarlo/issues`

### Response Times

- Community forum: 24-48 hours
- Email support: 48-72 hours (business days)
- Critical issues: 12-24 hours

### Common Questions

**Q: How accurate are the simulations?**
A: With 10,000+ simulations, results are typically accurate to within ±2% of the true statistical distribution.

**Q: Can I run simulations in parallel?**
A: Yes! Each API call is independent and can be run concurrently.

**Q: What data sources do you use?**
A: We use Bloomberg Terminal data for institutional-grade accuracy. Historical data covers 10+ years.

**Q: Do you support custom asset classes?**
A: Currently we support: equity, bonds, commodity, real_estate, cash. Custom asset classes are planned.

**Q: Can I download historical simulation results?**
A: Not in the MVP. This feature is planned for future releases.

---

## Changelog

### Version 1.0 (2025-12-31)
- Initial API release
- Monte Carlo simulation endpoint
- API key authentication
- 30-day free trial

---

**Document Version:** 1.0
**Last Updated:** December 31, 2025
**API Version:** 1.0.0
**Author:** Friday (AI Assistant for Tony)
