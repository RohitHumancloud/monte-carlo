# Monte Carlo Service - Integration Guide
## How to Integrate with Any System

**Version:** 2.0 (SaaS MVP)
**Created:** December 31, 2025
**Last Updated:** December 31, 2025
**Purpose:** Guide for integrating Monte Carlo SaaS platform with your application

---

## Table of Contents

1. [Overview](#overview)
2. [Getting Started (Self-Service)](#getting-started-self-service)
3. [Service Architecture](#service-architecture)
4. [API Specification](#api-specification)
5. [Integration Patterns](#integration-patterns)
6. [Language-Specific Examples](#language-specific-examples)
7. [Integration with GBA System](#integration-with-gba-system)
8. [Error Handling](#error-handling)
9. [Best Practices](#best-practices)

---

## Overview

### What is Monte Carlo Service?

A **SaaS platform** that provides Monte Carlo simulations for portfolio analysis via RESTful API.

**Key Characteristics:**
- 🌐 **Self-Service** - Sign up, login, manage API keys via web dashboard
- 🔌 **API-First** - RESTful API, consumes/produces JSON
- 🔑 **Dual Auth** - JWT for dashboard, API keys for programmatic access
- 📊 **Bloomberg Data** - Uses xbbg for institutional-grade market data
- ⚡ **Fast** - Numba-optimized (10-100x faster than pure Python)
- 🎯 **30-Day Trial** - API keys valid for 30 days (no billing in MVP)
- 🐳 **Containerized** - Docker + PostgreSQL deployment

**Service Endpoints:**
```
Dashboard:  https://montecarlo.example.com
API:        https://api.montecarlo.example.com/api/v1/simulate
```

---

## Getting Started (Self-Service)

### Step 1: Sign Up for Account

1. Visit the Monte Carlo dashboard: `https://montecarlo.example.com`
2. Click "Sign Up"
3. Provide:
   - Email address
   - Password (min 8 chars, must contain uppercase, lowercase, digit)
   - Full name (optional)
   - Company (optional)
4. Click "Create Account"

**Note:** No email verification required for MVP (instant access)

### Step 2: Login to Dashboard

1. Visit `https://montecarlo.example.com/login`
2. Enter your email and password
3. Click "Login"
4. You'll receive a JWT token (valid for 24 hours)

### Step 3: Generate API Keys

**Important:** You must create at least 2 API keys.

1. Navigate to Dashboard → "API Keys"
2. Click "Generate New API Key"
3. Enter a descriptive name (e.g., "Production Key", "Development Key")
4. Click "Generate"
5. **COPY THE KEY IMMEDIATELY** - it will only be shown once!
6. Repeat to create your second key (minimum 2 required)

**API Key Format:**
```
mk_live_abc123xyz789def456ghi012
```

**API Key Properties:**
- ✅ Valid for 30 days from creation
- ✅ Can be revoked at any time
- ✅ Each key tracks its own usage
- ✅ Last 4 characters visible in dashboard

### Step 4: Use API Key for Integration

Include your API key in the `X-API-Key` header of all API requests:

```bash
curl -X POST https://api.montecarlo.example.com/api/v1/simulate \
  -H "X-API-Key: mk_live_abc123xyz789def456ghi012" \
  -H "Content-Type: application/json" \
  -d '{
    "portfolio": { ... },
    "parameters": { ... }
  }'
```

### Step 5: Monitor Usage

1. Visit Dashboard → "API Calls"
2. View usage statistics:
   - Total API calls
   - Execution times
   - Success/error rates
   - Per-key usage breakdown

### API Key Lifecycle

```
Day 1:  Create API key → Status: active, Expires: Day 30
Day 15: Key still valid → Status: active
Day 30: Key expires → Status: expired
        Generate new key required
```

**What Happens When Key Expires?**
- API calls return `403 Forbidden`
- Error message: "API key expired. Please generate a new key from your dashboard."
- Generate a new key from the dashboard (free, instant)

**Revoking a Key:**
1. Dashboard → "API Keys"
2. Find the key to revoke
3. Click "Revoke"
4. Confirm
5. Key immediately becomes invalid

**Minimum 2 Keys Requirement:**
- You cannot revoke a key if you have less than 2 active keys
- This ensures you always have a backup key
- Generate a new key before revoking an old one

---

## Service Architecture

### Deployment Model

```
┌─────────────────────────────────────────────────────────────┐
│                  YOUR APPLICATION                            │
│  (Java / Python / Node.js / .NET / Any Language)            │
│                                                              │
│  - Business Logic (Goals, Portfolios, Customers)            │
│  - Database (PostgreSQL, MongoDB, etc.)                      │
│  - Authentication (JWT, OAuth2, etc.)                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ HTTPS REST API
                         │ POST /api/v1/simulate
                         │ Header: X-API-Key: your_key
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│          MONTE CARLO MICROSERVICE (Docker)                   │
│                                                              │
│  Port: 8000                                                  │
│  Tech: Python 3.11 + FastAPI + NumPy + Numba               │
│  Data: Bloomberg API (xbbg)                                  │
│                                                              │
│  Input:  JSON (portfolio + parameters)                       │
│  Output: JSON (simulation results)                           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ Bloomberg API
                         ▼
                  ┌──────────────┐
                  │  Bloomberg   │
                  │  Terminal    │
                  └──────────────┘
```

### Key Benefits

✅ **Language Independent** - Any language that can make HTTP requests
✅ **Stateless** - No shared state, scales horizontally
✅ **Focused** - Does ONE thing well (Monte Carlo simulation)
✅ **Fast** - Optimized for financial calculations
✅ **Maintainable** - Separate deployment from your main application

---

## API Specification

### Endpoint

```
POST /api/v1/simulate
```

### Authentication

```http
X-API-Key: your_api_key_here
```

### Request Format

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

### Response Format

```json
{
  "simulation_id": "sim_abc123",
  "status": "completed",
  "created_at": "2025-12-31T10:30:00Z",
  "execution_time_seconds": 2.34,
  "results": {
    "final_portfolio_value": {
      "mean": 2689340,
      "median": 2567890,
      "std_deviation": 456780,
      "percentiles": {
        "p5": 1892340,
        "p10": 2043210,
        "p25": 2187650,
        "p50": 2567890,
        "p75": 3124560,
        "p90": 3398760,
        "p95": 3987650
      }
    },
    "risk_metrics": {
      "var_90": 2043210,
      "var_95": 1892340,
      "var_99": 1654320,
      "cvar_95": 1784560,
      "sharpe_ratio": 0.82,
      "sortino_ratio": 1.12
    },
    "probabilities": {
      "probability_of_loss": 0.008,
      "probability_of_doubling": 0.456,
      "probability_reaching_goal": 0.684
    },
    "path_data": {
      "sample_paths": [
        [1000000, 1120000, 1245000, ...],
        [1000000, 980000, 1050000, ...]
      ],
      "percentile_paths": {
        "p5": [1000000, 1050000, 1098000, ...],
        "p50": [1000000, 1100000, 1210000, ...],
        "p95": [1000000, 1180000, 1392000, ...]
      }
    }
  }
}
```

### Health Check

```
GET /health
```

Response:
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2025-12-31T10:30:00Z"
}
```

---

## Integration Patterns

### Pattern 1: Synchronous Request (Simple)

**When to use:** Fast simulations (<5 seconds), simple workflows

```
Client → POST /api/v1/simulate → Wait for response → Use results
```

**Pros:**
- ✅ Simple implementation
- ✅ No polling needed
- ✅ Immediate results

**Cons:**
- ❌ Client must wait (blocks request)
- ❌ Not suitable for large simulations (100k+ paths)

---

### Pattern 2: Asynchronous + Polling (Recommended)

**When to use:** Long-running simulations, better user experience

```
Step 1: Client → POST /api/v1/simulate → Returns simulation_id
Step 2: Client → Poll GET /api/v1/simulate/{id}/status
Step 3: When status = "completed" → GET /api/v1/simulate/{id}/results
```

**Pros:**
- ✅ Non-blocking
- ✅ Can show progress to user
- ✅ Handles long simulations

**Cons:**
- ⚠️ Requires polling logic (future: add webhooks)

---

### Pattern 3: Message Queue Integration (Future)

**When to use:** High-volume, distributed systems

```
Client → Publish to Queue → Monte Carlo Service consumes → Results to Queue
```

**Note:** Not in MVP scope, but planned for Phase 2

---

## Language-Specific Examples

### Java (Spring Boot)

```java
@Service
public class MonteCarloService {

    @Value("${monte-carlo.api.url}")
    private String apiUrl;

    @Value("${monte-carlo.api.key}")
    private String apiKey;

    private final RestTemplate restTemplate;

    public MonteCarloResult runSimulation(SimulationRequest request) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("X-API-Key", apiKey);

        HttpEntity<SimulationRequest> entity = new HttpEntity<>(request, headers);

        ResponseEntity<MonteCarloResult> response = restTemplate.postForEntity(
            apiUrl + "/api/v1/simulate",
            entity,
            MonteCarloResult.class
        );

        return response.getBody();
    }
}
```

**Configuration (application.yml):**
```yaml
monte-carlo:
  api:
    url: http://monte-carlo-service:8000
    key: ${MONTE_CARLO_API_KEY}
```

---

### Python (FastAPI / Django)

```python
import httpx
import os

class MonteCarloClient:
    def __init__(self):
        self.api_url = os.getenv("MONTE_CARLO_API_URL", "http://monte-carlo-service:8000")
        self.api_key = os.getenv("MONTE_CARLO_API_KEY")

    async def run_simulation(self, portfolio: dict, parameters: dict) -> dict:
        """Call Monte Carlo service asynchronously"""

        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.api_url}/api/v1/simulate",
                json={
                    "portfolio": portfolio,
                    "parameters": parameters
                },
                headers={"X-API-Key": self.api_key},
                timeout=30.0
            )

            response.raise_for_status()
            return response.json()

# Usage
monte_carlo = MonteCarloClient()

result = await monte_carlo.run_simulation(
    portfolio={
        "assets": [
            {"ticker": "NSEI Index", "weight": 0.6, "asset_class": "equity"},
            {"ticker": "GIND10YR Index", "weight": 0.4, "asset_class": "bonds"}
        ]
    },
    parameters={
        "initial_investment": 1000000,
        "monthly_contribution": 50000,
        "time_horizon_years": 10,
        "num_simulations": 10000
    }
)

print(f"Base case: ₹{result['results']['final_portfolio_value']['median']:,.0f}")
```

---

### Node.js (Express)

```javascript
const axios = require('axios');

class MonteCarloService {
  constructor() {
    this.apiUrl = process.env.MONTE_CARLO_API_URL || 'http://monte-carlo-service:8000';
    this.apiKey = process.env.MONTE_CARLO_API_KEY;
  }

  async runSimulation(portfolio, parameters) {
    try {
      const response = await axios.post(
        `${this.apiUrl}/api/v1/simulate`,
        {
          portfolio,
          parameters
        },
        {
          headers: {
            'X-API-Key': this.apiKey,
            'Content-Type': 'application/json'
          },
          timeout: 30000
        }
      );

      return response.data;
    } catch (error) {
      console.error('Monte Carlo simulation failed:', error.message);
      throw error;
    }
  }
}

// Usage
const monteCarloService = new MonteCarloService();

const result = await monteCarloService.runSimulation(
  {
    assets: [
      { ticker: 'NSEI Index', weight: 0.6, asset_class: 'equity' },
      { ticker: 'GIND10YR Index', weight: 0.4, asset_class: 'bonds' }
    ]
  },
  {
    initial_investment: 1000000,
    monthly_contribution: 50000,
    time_horizon_years: 10,
    num_simulations: 10000
  }
);

console.log(`Base case: ₹${result.results.final_portfolio_value.median.toLocaleString()}`);
```

---

### .NET (C#)

```csharp
using System.Net.Http;
using System.Net.Http.Json;

public class MonteCarloService
{
    private readonly HttpClient _httpClient;
    private readonly string _apiKey;

    public MonteCarloService(IConfiguration configuration, HttpClient httpClient)
    {
        _httpClient = httpClient;
        _apiKey = configuration["MonteCarloApi:ApiKey"];
        _httpClient.BaseAddress = new Uri(configuration["MonteCarloApi:BaseUrl"]);
    }

    public async Task<MonteCarloResult> RunSimulationAsync(SimulationRequest request)
    {
        var httpRequest = new HttpRequestMessage(HttpMethod.Post, "/api/v1/simulate")
        {
            Content = JsonContent.Create(request)
        };
        httpRequest.Headers.Add("X-API-Key", _apiKey);

        var response = await _httpClient.SendAsync(httpRequest);
        response.EnsureSuccessStatusCode();

        return await response.Content.ReadFromJsonAsync<MonteCarloResult>();
    }
}

// Configuration (appsettings.json)
{
  "MonteCarloApi": {
    "BaseUrl": "http://monte-carlo-service:8000",
    "ApiKey": "your_api_key_here"
  }
}
```

---

## Integration with GBA System

### Specific Integration Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    GBA SYSTEM (Java/Spring)                  │
│                                                              │
│  Step 1: Customer completes portfolio matching              │
│          → Selected portfolio: 60% Equity / 40% Bonds       │
│                                                              │
│  Step 2: GBA calls Monte Carlo Service                      │
│          → POST /api/v1/simulate                             │
│          → Pass: Portfolio allocation + Goal parameters      │
│                                                              │
│  Step 3: Monte Carlo returns results                        │
│          → Worst (P10): ₹45 lakhs                           │
│          → Base (P50): ₹89 lakhs                            │
│          → Best (P90): ₹1.2 Cr                              │
│          → Success probability: 68.4%                        │
│                                                              │
│  Step 4: GBA stores results                                 │
│          → Insert into monte_carlo_simulations table         │
│          → Link to goal_id and portfolio_id                  │
│                                                              │
│  Step 5: Display to RM/Customer                             │
│          → Show charts with Best/Base/Worst scenarios        │
│          → Show probability of reaching goal                 │
└─────────────────────────────────────────────────────────────┘
```

### GBA Backend Integration Code

```java
@Service
@Slf4j
public class SimulationService {

    @Autowired
    private MonteCarloClient monteCarloClient;

    @Autowired
    private SimulationRepository simulationRepository;

    @Autowired
    private GoalRepository goalRepository;

    @Autowired
    private PortfolioRepository portfolioRepository;

    public MonteCarloSimulation runSimulationForGoal(Long goalId, Long portfolioId) {
        // 1. Fetch goal and portfolio from GBA database
        Goal goal = goalRepository.findById(goalId)
            .orElseThrow(() -> new ResourceNotFoundException("Goal not found"));

        ModernPortfolio portfolio = portfolioRepository.findById(portfolioId)
            .orElseThrow(() -> new ResourceNotFoundException("Portfolio not found"));

        // 2. Build request for Monte Carlo service
        MonteCarloRequest request = MonteCarloRequest.builder()
            .portfolio(buildPortfolioRequest(portfolio))
            .parameters(SimulationParameters.builder()
                .initialInvestment(goal.getInitialInvestment())
                .monthlyContribution(goal.getMonthlySip())
                .timeHorizonYears(goal.getTimeHorizonYears())
                .numSimulations(10000)
                .build())
            .build();

        // 3. Call Monte Carlo service
        log.info("Calling Monte Carlo service for goal {} with portfolio {}", goalId, portfolioId);
        MonteCarloResponse response = monteCarloClient.runSimulation(request);

        // 4. Map results to GBA database schema
        MonteCarloSimulation simulation = MonteCarloSimulation.builder()
            .goalId(goalId)
            .portfolioId(portfolioId)
            .worstCase(response.getResults().getPercentiles().getP10())
            .baseCase(response.getResults().getPercentiles().getP50())
            .bestCase(response.getResults().getPercentiles().getP90())
            .iterations(10000)
            .status("COMPLETED")
            .chartData(convertToChartData(response.getResults().getPathData()))
            .probabilityOfSuccess(response.getResults().getProbabilities().getProbabilityReachingGoal())
            .build();

        // 5. Save to GBA database
        simulation = simulationRepository.save(simulation);

        log.info("Simulation completed. Base case: ₹{}", simulation.getBaseCase());
        return simulation;
    }

    private PortfolioRequest buildPortfolioRequest(ModernPortfolio portfolio) {
        return PortfolioRequest.builder()
            .assets(portfolio.getAllocations().stream()
                .map(allocation -> AssetRequest.builder()
                    .ticker(allocation.getBloombergTicker())
                    .weight(allocation.getPercentage() / 100.0)
                    .assetClass(allocation.getAssetClass().toLowerCase())
                    .build())
                .collect(Collectors.toList()))
            .build();
    }
}
```

### GBA Database Mapping

```sql
-- GBA stores results from Monte Carlo service
INSERT INTO monte_carlo_simulations (
    goal_id,
    portfolio_id,
    worst_case,      -- From Monte Carlo: percentiles.p10
    base_case,       -- From Monte Carlo: percentiles.p50
    best_case,       -- From Monte Carlo: percentiles.p90
    iterations,      -- 10000
    status,          -- 'COMPLETED'
    chart_data,      -- From Monte Carlo: path_data (JSONB)
    simulation_date
) VALUES (
    25,              -- GBA goal ID
    10,              -- GBA portfolio ID
    1892340,         -- Monte Carlo P10
    2567890,         -- Monte Carlo P50
    3987650,         -- Monte Carlo P90
    10000,
    'COMPLETED',
    '{"p5": [...], "p50": [...], "p95": [...]}'::jsonb,
    CURRENT_TIMESTAMP
);
```

---

## Error Handling

### HTTP Status Codes

| Status | Meaning | Action |
|--------|---------|--------|
| **200** | Success | Process results normally |
| **400** | Bad Request | Check request format, validation errors in response |
| **401** | Unauthorized | Invalid or missing API key |
| **403** | Forbidden | API key valid but lacks permissions |
| **422** | Validation Error | Invalid portfolio weights or parameters |
| **500** | Server Error | Retry with exponential backoff |
| **503** | Service Unavailable | Bloomberg API down, retry later |

### Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Portfolio weights must sum to 1.0",
    "details": {
      "field": "portfolio.assets",
      "provided_sum": 0.95,
      "expected_sum": 1.0
    }
  }
}
```

### Retry Strategy

```java
@Retryable(
    value = { HttpServerErrorException.class },
    maxAttempts = 3,
    backoff = @Backoff(delay = 2000, multiplier = 2)
)
public MonteCarloResult runSimulation(SimulationRequest request) {
    // Call Monte Carlo service
}
```

---

## Best Practices

### 1. API Key Management

**❌ DON'T:**
```java
// Hardcoded API key (NEVER DO THIS!)
headers.set("X-API-Key", "key_abc123");
```

**✅ DO:**
```java
// Use environment variables
@Value("${monte-carlo.api.key}")
private String apiKey;
```

```bash
# In .env or Kubernetes secrets
MONTE_CARLO_API_KEY=key_abc123
```

---

### 2. Timeout Configuration

**Recommended timeouts:**
- Simple simulation (1,000 paths): 5 seconds
- Standard (10,000 paths): 30 seconds
- Large (100,000 paths): 2 minutes

```java
// Configure appropriate timeouts
RestTemplate restTemplate = new RestTemplate();
HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
factory.setConnectTimeout(5000);
factory.setReadTimeout(30000);
restTemplate.setRequestFactory(factory);
```

---

### 3. Caching Results

**Cache simulation results** if the same portfolio + parameters are requested multiple times:

```java
@Cacheable(value = "monte-carlo-results", key = "#goalId + '-' + #portfolioId")
public MonteCarloSimulation getSimulation(Long goalId, Long portfolioId) {
    // Check database first, then call service if not found
}
```

---

### 4. Monitoring & Logging

**Log all Monte Carlo service calls:**

```java
log.info("Monte Carlo request: goalId={}, portfolioId={}, timeHorizon={}",
    goalId, portfolioId, timeHorizonYears);

log.info("Monte Carlo response: executionTime={}s, baseCase={}",
    response.getExecutionTimeSeconds(), response.getResults().getMedian());
```

**Monitor metrics:**
- Request success rate
- Average execution time
- Error rate
- API key usage

---

### 5. Graceful Degradation

**Fallback if Monte Carlo service is unavailable:**

```java
try {
    return monteCarloClient.runSimulation(request);
} catch (Exception e) {
    log.error("Monte Carlo service unavailable, using fallback calculation", e);
    return calculateSimpleProjection(goal);  // Simple compound interest
}
```

---

## Summary

### Integration Checklist

- [ ] **Setup**
  - [ ] Monte Carlo service deployed (Docker)
  - [ ] API key generated and stored securely
  - [ ] Service URL configured in application

- [ ] **Code Integration**
  - [ ] HTTP client configured (RestTemplate/HttpClient/Axios)
  - [ ] Request/Response models defined
  - [ ] Error handling implemented
  - [ ] Timeout configuration set

- [ ] **Testing**
  - [ ] Health check endpoint verified
  - [ ] Successful simulation call tested
  - [ ] Error scenarios tested (invalid API key, bad request)
  - [ ] Performance tested (execution time)

- [ ] **Production**
  - [ ] Monitoring configured
  - [ ] Logging implemented
  - [ ] Retry logic added
  - [ ] Caching strategy defined

---

**You're ready to integrate!** 🚀

The Monte Carlo SaaS platform is designed to work seamlessly with ANY system. Sign up for an account, generate API keys from the dashboard, and integrate programmatically.

**Questions?** Check the other documentation files:
- `SAAS_MVP_ARCHITECTURE.md` - Complete SaaS platform architecture
- `DATABASE_SCHEMA.md` - Database schema for users and API keys
- `SAAS_IMPLEMENTATION_GUIDE.md` - Full-stack implementation code
- `API_DOCUMENTATION.md` - Public API documentation for end users
- `TECH_STACK_ARCHITECTURE.md` - Technology stack decisions
- `PROJECT_ROADMAP.md` - Implementation timeline

---

**Document Version:** 2.0 (SaaS MVP)
**Last Updated:** December 31, 2025
**Author:** Friday (AI Assistant for Tony)
