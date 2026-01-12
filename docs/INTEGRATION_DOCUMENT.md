# Monte Carlo Simulation - Integration Document

## Section 1: What You Send To Us (Simulation Request)

When you want to run a portfolio simulation, you need to send us the following information:

**Request Structure:**

```
{
  "goalId": Number,
  "portfolio": {
    "portfolioCode": String,
    "portfolioName": String,
    "expectedReturn": Number,
    "volatilityPercentage": Number,
    "allocations": [
      {
        "assetClassCode": String,
        "assetClassName": String,
        "parentAssetClass": String,
        "targetAllocationPercentage": Number,
        "expectedReturn": Number,
        "expectedRisk": Number
      }
    ]
  },
  "initialInvestment": Number,
  "monthlyInvestment": Number,
  "years": Number,
  "iterations": Number
}
```

### Field Descriptions

| Field             | Data Type | What It Means                          |
| ----------------- | --------- | -------------------------------------- |
| goalId            | Number    | Customer's financial goal ID           |
| initialInvestment | Number    | One-time investment amount (in INR)    |
| monthlyInvestment | Number    | Monthly SIP amount (in INR)            |
| years             | Number    | How many years to invest               |
| iterations        | Number    | Number of simulations (default: 10000) |

### Portfolio Details

| Field                | Data Type | What It Means                 |
| -------------------- | --------- | ----------------------------- |
| portfolioCode        | String    | Unique code for the portfolio |
| portfolioName        | String    | Name of the portfolio         |
| expectedReturn       | Number    | Overall expected return %     |
| volatilityPercentage | Number    | Overall portfolio risk %      |
| allocations          | Array     | List of asset allocations     |

### Allocation Details (For Each Asset Class)

| Field                      | Data Type | What It Means                              |
| -------------------------- | --------- | ------------------------------------------ |
| assetClassCode             | String    | Unique code for asset class                |
| assetClassName             | String    | Name of the asset class                    |
| parentAssetClass           | String    | Category (Equity, Debt, Commodities, Cash) |
| targetAllocationPercentage | Number    | Allocation percentage (%)                  |
| expectedReturn             | Number    | Expected return for this asset %           |
| expectedRisk               | Number    | Risk/volatility for this asset %           |

**Important:** Total of all targetAllocationPercentage must equal 100%

### Parent Asset Classes

| Parent Class      | What It Includes                                   |
| ----------------- | -------------------------------------------------- |
| Equity            | Large Cap, Mid Cap, Small Cap, International       |
| Debt/Fixed Income | Short Term Debt, Medium Term Debt, Corporate Bonds |
| Commodities       | Gold ETF, Silver ETF                               |
| Cash/Money Market | Liquid Funds                                       |

---

## Section 2: What You Get Back (Simulation Results)

After running the simulation, you will receive the following results:

**Response Structure:**

```
{
  "success": Boolean,
  "message": String,
  "data": {
    "simulationId": Number,
    "goalId": Number,
    "portfolioName": String,
    "simulationDate": String,
    "targetCorpus": Number,
    "scenarios": {
      "worstCase": {
        "finalValue": Number,
        "percentile": Number,
        "annualizedReturn": Number,
        "meetsGoal": Boolean,
        "shortfall": Number
      },
      "baseCase": {
        "finalValue": Number,
        "percentile": Number,
        "annualizedReturn": Number,
        "meetsGoal": Boolean,
        "surplus": Number
      },
      "bestCase": {
        "finalValue": Number,
        "percentile": Number,
        "annualizedReturn": Number,
        "meetsGoal": Boolean,
        "surplus": Number
      }
    },
    "probabilityOfSuccess": Number,
    "confidenceLevel": String,
    "chartData": {
      "months": Array of Numbers,
      "worstCase": Array of Numbers,
      "baseCase": Array of Numbers,
      "bestCase": Array of Numbers
    }
  }
}
```

### Response Field Descriptions

| Field                | Data Type | What It Means                             |
| -------------------- | --------- | ----------------------------------------- |
| success              | Boolean   | True if simulation completed              |
| message              | String    | Status message                            |
| simulationId         | Number    | Unique ID for this simulation             |
| targetCorpus         | Number    | The goal amount customer wants to achieve |
| probabilityOfSuccess | Number    | Percentage chance of reaching the goal    |
| confidenceLevel      | String    | LOW, MODERATE, HIGH, VERY_HIGH            |

### Scenario Fields (worstCase, baseCase, bestCase)

| Field            | Data Type | What It Means                         |
| ---------------- | --------- | ------------------------------------- |
| finalValue       | Number    | Projected final amount                |
| percentile       | Number    | 10 (worst), 50 (base), 90 (best)      |
| annualizedReturn | Number    | Yearly return percentage              |
| meetsGoal        | Boolean   | True if target achieved               |
| shortfall        | Number    | Amount below target (if goal not met) |
| surplus          | Number    | Amount above target (if goal met)     |

### Chart Data

| Field     | Data Type | What It Means                     |
| --------- | --------- | --------------------------------- |
| months    | Array     | List of months (0, 12, 24, ...)   |
| worstCase | Array     | Monthly values for worst scenario |
| baseCase  | Array     | Monthly values for base scenario  |
| bestCase  | Array     | Monthly values for best scenario  |

---

## Section 3: Historical Price Data (You Provide To Us)

We need past price data for all investments. This helps us understand how investments performed in the past.

**What We Need:** Daily closing prices

**File Name Example:** HISTORICAL_PRICES_20260110_001.csv

### Sample Data Format

| DATE       | TICKER         | ASSET_CLASS | PX_OPEN  | PX_HIGH  | PX_LOW   | PX_LAST  | PX_VOLUME | CURRENCY |
| ---------- | -------------- | ----------- | -------- | -------- | -------- | -------- | --------- | -------- |
| 2026-01-10 | NSEI Index     | equity      | 23145.50 | 23289.75 | 23098.25 | 23256.80 | 125000000 | INR      |
| 2026-01-10 | SENSEX Index   | equity      | 76543.21 | 77012.45 | 76321.00 | 76892.35 | 89000000  | INR      |
| 2026-01-10 | GIND10YR Index | bonds       | 101.25   | 101.45   | 101.10   | 101.35   | 5000000   | INR      |
| 2026-01-09 | NSEI Index     | equity      | 23012.30 | 23198.50 | 22987.60 | 23145.50 | 118000000 | INR      |
| 2026-01-09 | SENSEX Index   | equity      | 75890.45 | 76678.90 | 75765.20 | 76543.21 | 92000000  | INR      |

### Column Descriptions

| Column      | Required? | What It Means                           |
| ----------- | --------- | --------------------------------------- |
| DATE        | Yes       | Date of trading (Format: YYYY-MM-DD)    |
| TICKER      | Yes       | Unique code for the investment          |
| ASSET_CLASS | Yes       | Type: equity, bonds, commodity, or cash |
| PX_OPEN     | Optional  | Price when market opened                |
| PX_HIGH     | Optional  | Highest price of the day                |
| PX_LOW      | Optional  | Lowest price of the day                 |
| PX_LAST     | Yes       | Closing price (most important)          |
| PX_VOLUME   | Optional  | How many units were traded              |
| CURRENCY    | Yes       | INR or USD                              |

---

## Section 4: Current Day Closing Price (You Provide Daily)

We need today's closing price after the market closes each day.

**What We Need:** Today's closing prices for all investments

**File Name Example:** CURRENT_PRICES_20260110_001.csv

### Sample Data Format

| DATE       | TICKER         | ASSET_CLASS | PX_LAST  | PX_PREV_CLOSE | CHG_PCT | CURRENCY | LAST_UPDATE         |
| ---------- | -------------- | ----------- | -------- | ------------- | ------- | -------- | ------------------- |
| 2026-01-10 | NSEI Index     | equity      | 23256.80 | 23145.50      | 0.0048  | INR      | 2026-01-10T15:30:00 |
| 2026-01-10 | SENSEX Index   | equity      | 76892.35 | 76543.21      | 0.0046  | INR      | 2026-01-10T15:30:00 |
| 2026-01-10 | GIND10YR Index | bonds       | 101.35   | 101.25        | 0.0010  | INR      | 2026-01-10T17:00:00 |

### Column Descriptions

| Column        | Required? | What It Means                           |
| ------------- | --------- | --------------------------------------- |
| DATE          | Yes       | Today's date (Format: YYYY-MM-DD)       |
| TICKER        | Yes       | Unique code for the investment          |
| ASSET_CLASS   | Yes       | Type: equity, bonds, commodity, or cash |
| PX_LAST       | Yes       | Today's closing price                   |
| PX_PREV_CLOSE | Optional  | Yesterday's closing price               |
| CHG_PCT       | Optional  | How much price changed (0.01 = 1%)      |
| CURRENCY      | Yes       | INR or USD                              |
| LAST_UPDATE   | Yes       | When the price was last updated         |

---

## Section 5: Asset Master List (You Provide Once)

We need a list of all investments with their basic details.

**File Name Example:** ASSET_MASTER_20260110_001.csv

### Sample Data Format

| TICKER               | NAME                          | ASSET_CLASS | EXCHANGE | CURRENCY | COUNTRY |
| -------------------- | ----------------------------- | ----------- | -------- | -------- | ------- |
| NSEI Index           | Nifty 50 Index                | equity      | NSE      | INR      | IN      |
| SENSEX Index         | S&P BSE Sensex Index          | equity      | BSE      | INR      | IN      |
| GIND10YR Index       | India 10-Year Government Bond | bonds       | NSE      | INR      | IN      |
| GOLDBEES IN Equity   | Nippon India ETF Gold BeES    | commodity   | NSE      | INR      | IN      |
| LIQUIDBEES IN Equity | Nippon India ETF Liquid BeES  | cash        | NSE      | INR      | IN      |

### Column Descriptions

| Column      | Required? | What It Means                           |
| ----------- | --------- | --------------------------------------- |
| TICKER      | Yes       | Unique code for the investment          |
| NAME        | Yes       | Full name of the investment             |
| ASSET_CLASS | Yes       | Type: equity, bonds, commodity, or cash |
| EXCHANGE    | Yes       | Where it is traded (NSE, BSE)           |
| CURRENCY    | Yes       | Currency (INR, USD)                     |
| COUNTRY     | Yes       | Country code (IN for India)             |

---

## Section 6: Summary - What You Need To Provide

| Data Type         | How Often                      | What It Contains                |
| ----------------- | ------------------------------ | ------------------------------- |
| Historical Prices | One time (at start)            | Past 5-10 years of daily prices |
| Current Prices    | Every day                      | Today's closing prices          |
| Asset Master      | When new investments are added | List of all investments         |

### File Format Requirements

| Requirement     | Details                          |
| --------------- | -------------------------------- |
| File Type       | CSV (Excel can save as CSV)      |
| Date Format     | YYYY-MM-DD (Example: 2026-01-10) |
| Delivery Time   | Daily by 6:00 PM IST             |
| Delivery Method | SFTP (Secure File Transfer)      |

---

## Section 7: Complete Example (International Market)

### Example Request

```
{
  "goalId": 101,
  "portfolio": {
    "portfolioCode": "GLOBAL_GROWTH_001",
    "portfolioName": "Global Growth Portfolio",
    "expectedReturn": 12.5,
    "volatilityPercentage": 14.0,
    "allocations": [
      {
        "assetClassCode": "US_LARGE_CAP",
        "assetClassName": "US Large Cap (S&P 500)",
        "parentAssetClass": "Equity",
        "targetAllocationPercentage": 25,
        "expectedReturn": 10,
        "expectedRisk": 15
      },
      {
        "assetClassCode": "EUROPE_EQUITY",
        "assetClassName": "European Equity",
        "parentAssetClass": "Equity",
        "targetAllocationPercentage": 15,
        "expectedReturn": 8,
        "expectedRisk": 16
      },
      {
        "assetClassCode": "EMERGING_MARKETS",
        "assetClassName": "Emerging Markets",
        "parentAssetClass": "Equity",
        "targetAllocationPercentage": 20,
        "expectedReturn": 12,
        "expectedRisk": 20
      },
      {
        "assetClassCode": "GLOBAL_BONDS",
        "assetClassName": "Global Bonds",
        "parentAssetClass": "Debt/Fixed Income",
        "targetAllocationPercentage": 25,
        "expectedReturn": 5,
        "expectedRisk": 6
      },
      {
        "assetClassCode": "GOLD_ETF",
        "assetClassName": "Gold ETF",
        "parentAssetClass": "Commodities",
        "targetAllocationPercentage": 10,
        "expectedReturn": 7,
        "expectedRisk": 12
      },
      {
        "assetClassCode": "CASH_USD",
        "assetClassName": "USD Money Market",
        "parentAssetClass": "Cash/Money Market",
        "targetAllocationPercentage": 5,
        "expectedReturn": 4,
        "expectedRisk": 1
      }
    ]
  },
  "initialInvestment": 500000,
  "monthlyInvestment": 25000,
  "years": 15,
  "iterations": 10000
}
```

### Example Response

```
{
  "success": true,
  "message": "Simulation completed successfully.",
  "data": {
    "simulationId": 1001,
    "goalId": 101,
    "portfolioName": "Global Growth Portfolio",
    "simulationDate": "2026-01-10",
    "targetCorpus": 25000000,
    "scenarios": {
      "worstCase": {
        "finalValue": 18500000,
        "percentile": 10,
        "annualizedReturn": 8.5,
        "meetsGoal": false,
        "shortfall": 6500000
      },
      "baseCase": {
        "finalValue": 28000000,
        "percentile": 50,
        "annualizedReturn": 12.5,
        "meetsGoal": true,
        "surplus": 3000000
      },
      "bestCase": {
        "finalValue": 42000000,
        "percentile": 90,
        "annualizedReturn": 16.8,
        "meetsGoal": true,
        "surplus": 17000000
      }
    },
    "probabilityOfSuccess": 72.5,
    "confidenceLevel": "HIGH",
    "chartData": {
      "months": [0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 144, 156, 168, 180],
      "worstCase": [500000, 820000, 1180000, 1580000, 2020000, 2500000, 3020000, 3580000, 4180000, 4820000, 5500000, 6220000, 6980000, 7780000, 8620000, 18500000],
      "baseCase": [500000, 880000, 1320000, 1820000, 2380000, 3000000, 3680000, 4420000, 5220000, 6080000, 7000000, 7980000, 9020000, 10120000, 11280000, 28000000],
      "bestCase": [500000, 950000, 1480000, 2100000, 2820000, 3650000, 4600000, 5680000, 6900000, 8280000, 9820000, 11540000, 13460000, 15600000, 17980000, 42000000]
    }
  }
}
```

---

**End of Document**
