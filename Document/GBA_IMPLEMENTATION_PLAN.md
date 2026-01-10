```
You have to foucs only on @GBS-backend/ and @frontend/ becuase we have to build a product ok first understand the requriement we will not do the implementation. First we will foucs on databased design , backend apis what all logic , frontend logic changes based on the backend.

First i will explain what is the product and we have to build:
RM (relationship Manager) who will do the sign up in the account we will have the list of customer basically the end users rm should be able to create the new customer/user
then RM will select the users then on next page we will have create new goal and revise goal. RM select the new goal RM give the goal name then we ask risk profile questionniare based on that we have to generate risk score to understand user in which categories follows below.
08 - 11 - Secure
12 - 16 - Conservative
17 - 21 - Income
22 - 26 - Balance
27 - 31 - Aggressive
32 - 35 - Speculative
next page we have suitablility questionniare (here i want to understand how we can use the suitablility questionniare anwers given by user to show modern portfolio as you have read the pdf which i have shared above) after giving all the answers then we have on next page
financial calculator where RM enter based on user put the goal amount tenure and rate of influation the we will calculate corpus amount, on next step of financial calculator RM enter based on user initial amount, monthly amount and tenure then we have calculate using some mathmetical formula we have to compare with based on the risk score ,suitablility questionniare all the calculate if all condition match then we show the modern portfolio to the users then on next page  we show number of strategy to the RM based on that RM select best strategy for customer, on next page we show the amount allocation in table formate to the RM distribution of amount to respective modern portfolio strategy which have (bond,cash, mutual fund, gold,equity etc it can be more assest class). then its goes to monte carlo stimulation then RM puch the order client see the excel sheet do the MFA then order place rm redirect to the dashbord he will see the customer calls.

above is the high level idea how the product will work their may point to discussed to make configurable on each step and easy to integrate with ui by following all standard of coding as well as banking standard of data exchanges ok.

First: i want to understand what is risk profile and suitablility.
Second: i want to understand what is risk score how risk score is generate or calculate on what based we calculate on risk profile or suitablility or both.
Third: what is modern portfolio how they are created what are differnt type of portfolio how we can map with risk score.
Fourth: i want to make risk profile and suitablility configurable based on the questionniare type like single select, multi select, input text or dropdown select or any to super admin based on any bank questionniare.
Fivth: i want to understand how will make the modern portfolio configurable to super admin based on any bank.
Sixth: how we will do the financial calculation what all formula we will using how we will do the matching of financial calculator , risk score and show the modern portfolio strategy to the RM.

We have to track which step from were RM is moving from create goal to risk profile or suitablility to risk score to financial calculator to show modern portfolio strategy to puch order etc kind of tracking this is just the smaple high level idea of tracking

First we will focus on create goal, risk profile, suitablility and risk score
second we will foucs on financial calculation
third we will foucs on modern portfolio strategy
Fourth on puch order and show amount distribution
Fiveth at the end we will do monte carlo stimulation

i want to create detail plan we will do step by step without loosing the focus first we will complete one flow then we will go for another before that first read my requirment suggest me point which can be to make better understand or any drawback so that we think and we are on same page

First think i want to clear the basic what is risk profile , suitablility, risk score, modern portfolio, financial calculator.

then we will go for the database design on existing @GBS-backend/ with step by step considering all points and flow

then we will go for the apis curd operation or any other operation based on the flow

then we will go for the frontend design on existing @frontend/ with step by step considering all points and flow

first do the research and make the plan if plan works then will work on it

pls do web search do not used your knowledge i want facts and result
```

# Goal-Based Advisory (GBA) System - Comprehensive Implementation Plan

**Document Version:** 1.0
**Date:** December 24, 2025
**Status:** Research & Planning Phase

---

## Table of Contents

1. [Fundamental Concepts (Research-Based)](#1-fundamental-concepts-research-based)
2. [System Requirements Analysis](#2-system-requirements-analysis)
3. [Database Design](#3-database-design)
4. [Backend API Design](#4-backend-api-design)
5. [Frontend Design](#5-frontend-design)
6. [Implementation Phases](#6-implementation-phases)
7. [Open Questions & Clarifications](#7-open-questions--clarifications)

---

## 1. Fundamental Concepts (Research-Based)

### 1.1 Risk Profile

**Definition (Source-Based):**
Risk profile refers to **risk classification, a multidimensional approach that reconciles objective and subjective factors** to establish a suitable level of risk that an investor should take. [Source: Oxford Risk](https://www.oxfordrisk.com/downloads/more-than-mere-measurement-guide-to-client-investment-suitability)

**Key Components:**
According to [CFA Institute Investment Risk Profiling Guide](https://rpc.cfainstitute.org/sites/default/files/-/media/documents/survey/investment-risk-profiling.pdf):

1. **Risk Tolerance** - Investor's willingness to accept risk (psychological/behavioral)
2. **Risk Capacity** - Investor's ability to absorb losses (financial situation)
3. **Investment Time Horizon** - Duration of investment
4. **Investment Objectives** - Goals (growth, income, preservation)

**Modern 2025 Approach:**
According to [Finexer's 2025 Wealthtech Guide](https://blog.finexer.com/risk-profiling-bank-data/):

- Traditional risk profiling depends on static forms and once-a-year reviews
- Modern wealthtech firms now use **Open Banking APIs** to gain live insights into client's income consistency, discretionary spending, and liquidity patterns
- Makes risk assessments **far more accurate and adaptive**, especially in volatile market environments

---

### 1.2 Suitability Assessment

**Definition (Source-Based):**
According to [ESMA MiFID II Guidelines](https://www.esma.europa.eu/publications-and-data/interactive-single-rulebook/mifid-ii/article-25-assessment-suitability-and):

The **suitability assessment** is one of the most important requirements for investor protection in the MiFID framework. Investment firms must obtain necessary information regarding:

1. **Client's knowledge and experience** in the investment field
2. **Financial situation** including ability to bear losses
3. **Investment objectives** including risk tolerance

**Comprehensive Scope:**
According to [CFA Institute Standard III(C)](https://www.cfainstitute.org/standards/professionals/code-ethics-standards/standards-of-practice-iii-c), the customer's investment profile includes:

- Age
- Other investments
- Financial situation and needs
- Tax status
- Investment objectives
- Investment experience
- Investment time horizon
- Liquidity needs
- Risk tolerance

**2025 Update:**
Following a 2021 European Commission delegated regulation, investment firms must also identify the client's **sustainability preferences** (ESG factors).

---

### 1.3 Difference Between Risk Profile and Suitability

**Key Distinction:**

| Aspect         | Risk Profile                                   | Suitability Assessment                                                   |
| -------------- | ---------------------------------------------- | ------------------------------------------------------------------------ |
| **Scope**      | Focused on risk tolerance + capacity           | Comprehensive evaluation                                                 |
| **Components** | Risk appetite, time horizon, capacity for loss | Risk profile + financial situation + knowledge + experience + objectives |
| **Output**     | Risk classification score                      | Overall investment recommendation                                        |
| **Purpose**    | Determine risk level                           | Determine appropriate investments                                        |

**Important Insight:**
According to [Oxford Risk](https://www.oxfordrisk.com/solutions/investor-compass-risk-suitability):

> "Isolated measures of Risk Tolerance and Risk Capacity are not much good without a robust methodology to combine them in arriving at a Suitable Risk Level."

**Therefore:** Risk Profile is **ONE INPUT** into the broader Suitability Assessment.

---

### 1.4 Risk Score Calculation

**Basic Formula:**
According to [MetricStream](https://www.metricstream.com/learn/risk-scores-for-better-risk-mgmt.html) and [Scrut.io](https://www.scrut.io/post/understanding-the-best-risk-calculation-method):

```
Risk Score = Likelihood × Impact
```

**Investment-Specific Formulas:**

#### Method 1: Weighted Scoring (Most Common in Banking)

```
Risk Score = Σ (Question Weight × Selected Answer Points)
```

Example from your requirement:

- Risk Score Range: 08-35
- Each question has: points per answer option
- Total score determines category:
  - 08-11: Secure
  - 12-16: Conservative
  - 17-21: Income
  - 22-26: Balance
  - 27-31: Aggressive
  - 32-35: Speculative

#### Method 2: Portfolio Risk Metrics

According to [Horizon Investments](https://www.horizoninvestments.com/how-to-calculate-portfolio-risk-essential-guide-to-investment-risk-assessment/):

1. **Standard Deviation** - Measures volatility of investment returns
2. **Beta Coefficient** - Evaluates portfolio sensitivity to market movements
3. **Sharpe Ratio** - Evaluates returns in relation to risk taken
4. **Value at Risk (VaR)** - Portfolio Value × (Z-score × Portfolio Standard Deviation)

**For Your System:**
You should use **Method 1 (Weighted Scoring)** for Risk Profile Questionnaire to generate the Risk Score (08-35 range).

---

### 1.5 Modern Portfolio Theory (MPT)

**Definition:**
According to [Wikipedia](https://en.wikipedia.org/wiki/Modern_portfolio_theory):

> "Modern portfolio theory (MPT) is a mathematical framework for assembling a portfolio of assets such that the expected return is maximized for a given level of risk."

**Key Insight:**
According to [Corporate Finance Institute](https://corporatefinanceinstitute.com/resources/career-map/sell-side/capital-markets/modern-portfolio-theory-mpt/):

> "An asset's risk and return should not be assessed by itself, but by how it contributes to a portfolio's overall risk and return."

**2025 Implementation:**
According to [CIBC Asset Management 2025 Report](https://www.cibc.com/content/dam/cibc-public-assets/asset-management/pdfs/2025-long-term-strategic-asset-allocation-en.pdf):

- MPT approaches follow **mean-variance optimization** to determine the right mix of assets
- Minimize portfolio volatility for a certain level of expected return
- One key drawback: overemphasizes standard deviation as measure of risk
- Can favor investments with lower long-term volatility but subject to sharp declines

**State Street Global Market Portfolio 2025:**
According to [State Street White Paper](https://www.ssga.com/library-content/assets/pdf/global/gmp/global-market-portfolio-2025.pdf):

- Originally proposed by James Tobin (1958)
- Refined by William Sharpe (1964)
- Became cornerstone of modern portfolio theory

---

### 1.6 Asset Allocation Strategies

According to [Vanguard Model Portfolio Allocation](https://investor.vanguard.com/investor-resources-education/education/model-portfolio-allocation) and [Trustnet](https://www.trustnet.com/investing/13426105/cautious-balanced-and-aggressive-asset-allocation-models):

#### Conservative Portfolio

- **Risk Tolerance:** Low
- **Time Horizon:** Short-term
- **Goal:** Capital preservation over growth
- **Asset Mix:** Higher allocation to bonds and cash equivalents, limited exposure to stocks
- **Typical Allocation:** 20% Stocks / 80% Bonds & Cash

#### Balanced Portfolio

- **Risk Tolerance:** Moderate
- **Time Horizon:** 5-10 years (intermediate)
- **Goal:** Middle ground between risk and reward
- **Asset Mix:** Equal balance between stocks and bonds
- **Typical Allocation:** 50% Stocks / 50% Bonds

#### Aggressive Portfolio

- **Risk Tolerance:** High
- **Time Horizon:** Long-term (10+ years)
- **Goal:** Capital appreciation/growth
- **Asset Mix:** Higher allocation to equities, lower to fixed income
- **Typical Allocation:** 80% Stocks / 20% Bonds

**Key Factor (Source: [Investor.gov](https://www.investor.gov/additional-resources/general-resources/publications-research/info-sheets/beginners-guide-asset)):**

> "The asset allocation that works best depends largely on your time horizon and ability to tolerate risk."

---

### 1.7 Monte Carlo Simulation

**Definition:**
According to [InvestGlass](https://www.investglass.com/mastering-monte-carlo-simulation-portfolio-optimization-for-smarter-investments/):

> "Monte Carlo simulation uses repeated random sampling to evaluate and forecast potential investment outcomes."

**Primary Uses in Wealth Management:**
According to [Portfolio Visualizer](https://www.portfoliovisualizer.com/monte-carlo-simulation):

1. **Portfolio Survival Testing**

   - Test long-term expected portfolio growth
   - Test portfolio survival based on withdrawals
   - Useful for retirement or endowment fund planning

2. **Financial Goals Planning**

   - Multiple cashflow goals based on different life stages
   - Support linear glide paths from growth to income portfolios

3. **Efficient Frontier Construction**
   - Select optimal portfolio weights
   - Calculate and plot efficient frontier for securities

**Risk Metrics:**
According to [Medium - Portfolio Optimization](https://medium.com/@beingamanforever/portfolio-optimisation-using-monte-carlo-simulation-25d88003782e):

- **Conditional Value at Risk (CVaR)** - Understanding portfolio susceptibility to losses
- **Maximum Drawdown** - Largest peak-to-trough decline
- Provides insights into advantages and dangers of different investment approaches

---

### 1.8 Financial Calculations (Corpus Calculation)

#### Future Value with Inflation

**Basic Formula:**
According to [Calculator Soup](https://www.calculatorsoup.com/calculators/financial/future-value-calculator.php):

```
FV = PV × (1 + r)^n
```

Where:

- FV = Future Value
- PV = Present Value
- r = Annual interest rate
- n = Number of years

#### Inflation-Adjusted Future Value

**Method 1: After-Tax and Inflation Adjustment**
According to [Mortgage Calculator](https://www.mortgagecalculator.org/calcs/future-value.php):

```
FV_adjusted = (((PV × (1 + r)^n) - PV) × (1 - tr) + PV) × (1 - ir)^n
```

Where:

- tr = Tax rate
- ir = Inflation rate

**Method 2: Real Rate of Return Approach**
According to [Sapling](https://www.sapling.com/2238491/calculate-future-value-money-using):

```
Real Rate of Return = ((1 + Nominal Rate) / (1 + Inflation Rate)) - 1
```

Example:

- Nominal Return: 5%
- Inflation: 2%
- Real Return = (1.05 / 1.02) - 1 = 0.029 = 2.9%

#### Goal-Based Corpus Calculation

According to [NISM Corpus Making Calculator](https://www.nism.ac.in/NISM%20Financial%20Calculators/Corpus-Making/index.html) and [DSP Wealth Planner](https://www.dspim.com/investment-calculator/wealth-planner):

**Inputs Required:**

1. Target corpus amount
2. Investment tenure (years)
3. Estimated rate of return
4. Inflation rate
5. Initial investment (lump sum)
6. Monthly SIP amount (if applicable)

**Outputs Provided:**

1. Required monthly investment
2. Total invested principal amount
3. Interest earned
4. Final corpus acquired

**Key Benefit:**
According to [ClearTax Goal Planner](https://cleartax.in/s/goal-planner):

> "Accurate financial planning that considers the impact of inflation and estimated returns to determine the exact amount needed."

---

## 2. System Requirements Analysis

### 2.1 Your Product Flow (Clarified)

Based on your description, here's the complete flow:

```
1. RM Signup/Login
   ↓
2. RM Dashboard → Customer Management
   ↓
3. RM Creates/Manages Customers (End Users)
   ↓
4. RM Selects Customer → Goal Management
   ↓
5. Create New Goal OR Revise Existing Goal
   ↓
6. [NEW GOAL PATH]
   ├─ Enter Goal Name
   ├─ Risk Profile Questionnaire → Calculate Risk Score (08-35)
   │  └─ Categories: Secure/Conservative/Income/Balance/Aggressive/Speculative
   ├─ Suitability Questionnaire → Determine Portfolio Eligibility
   ├─ Financial Calculator (2 Steps):
   │  ├─ Step 1: Goal Amount + Tenure + Inflation → Corpus Amount
   │  └─ Step 2: Initial + Monthly + Tenure → Investment Calculation
   ├─ Matching Engine: Compare Risk Score + Suitability + Financial Calc
   │  └─ If Match → Show Modern Portfolio Strategies
   ├─ RM Selects Best Strategy
   ├─ Show Asset Allocation Table (Bonds/Cash/MF/Gold/Equity/etc.)
   ├─ Monte Carlo Simulation → Show Projections
   ├─ RM Pushes Order
   ├─ Client Reviews Excel Sheet + MFA
   ├─ Order Placed
   └─ RM Redirected to Dashboard → See Customer Calls/Logs
```

---

### 2.2 Critical Questions & Clarifications Needed

#### Question 1: Risk Profile vs Suitability - Usage Clarity

**Your Requirement:**

> "we ask risk profile questionnaire based on that we have to generate risk score... next page we have suitability questionnaire (here i want to understand how we can use the suitability questionnaire answers given by user to show modern portfolio)"

**My Understanding Based on Research:**

**Risk Profile Questionnaire:**

- **Purpose:** Generate Risk Score (08-35)
- **Output:** Risk Category (Secure/Conservative/Income/Balance/Aggressive/Speculative)
- **Questions Focus:** Risk tolerance, capacity for loss, investment horizon, emotional response to volatility

**Suitability Questionnaire:**

- **Purpose:** Comprehensive assessment for regulatory compliance + portfolio eligibility
- **Output:** Determine which portfolios the client is ELIGIBLE for
- **Questions Focus:** Knowledge & experience, financial situation, investment objectives, liquidity needs, ESG preferences

**Proposed Logic:**

```
IF Risk Score = 08-11 (Secure)
   AND Suitability = "Low Knowledge" + "Capital Preservation Objective"
   THEN Show: Conservative Portfolio Options (20% Equity / 80% Bonds)

IF Risk Score = 27-31 (Aggressive)
   AND Suitability = "High Knowledge" + "Growth Objective" + "High Income"
   THEN Show: Aggressive Portfolio Options (80% Equity / 20% Bonds)

IF Risk Score = Aggressive BUT Suitability = "Low Knowledge"
   THEN BLOCK Aggressive Portfolios (Compliance Rule)
```

**Question for You:**
Is this interpretation correct? Should suitability act as:

1. A **filter** (blocks unsuitable portfolios)?
2. A **scoring modifier** (adjusts risk score)?
3. **Both**?

---

#### Question 2: Financial Calculator Matching Logic

**Your Requirement:**

> "we have to compare with based on the risk score, suitability questionnaire all the calculate if all condition match then we show the modern portfolio"

**What I Need to Understand:**

**Scenario:**

- Risk Score: 25 (Balance)
- Suitability: Approved for Balanced portfolios
- Financial Calculator Result:
  - Required Corpus: ₹50,00,000
  - Monthly SIP: ₹15,000
  - Tenure: 10 years
  - Expected Return Needed: 12%

**Matching Logic Questions:**

1. Do we check if the **expected return of the portfolio** matches the **required return from financial calculator**?
2. If portfolio expected return is LESS than required, do we:
   - Suggest higher-risk portfolio?
   - Show warning "Goal may not be achievable"?
   - Increase monthly SIP amount?
3. If portfolio expected return is MORE than required, do we:
   - Suggest lower-risk portfolio?
   - Show "Goal achievable with lower risk"?

**Please Clarify the Matching Conditions.**

---

#### Question 3: Modern Portfolio Configuration

**Your Requirement:**

> "I want to make the modern portfolio configurable to super admin based on any bank"

**What Needs to be Configurable:**

1. **Portfolio Templates:**

   - Portfolio Name (e.g., "Conservative Growth", "Balanced Income")
   - Risk Category Mapping (which risk scores can access this portfolio)
   - Expected Return Range (e.g., 8-10% p.a.)
   - Asset Classes Included
   - Default Allocation %

2. **Asset Classes:**

   - Asset Class Name (Equity, Bonds, Gold, MF, Cash, etc.)
   - Asset Class Type (Growth/Income/Defensive)
   - Liquidity Level (High/Medium/Low)
   - Risk Level (High/Medium/Low)

3. **Allocation Rules:**
   - Min/Max % per asset class
   - Compliance rules (e.g., "Bonds must be >= 40% for Conservative")

**Example Configuration Structure:**

```json
{
  "portfolio": {
    "id": "CONS_001",
    "name": "Conservative Growth",
    "risk_categories": ["Secure", "Conservative"],
    "risk_score_range": [8, 16],
    "expected_return_min": 6,
    "expected_return_max": 8,
    "allocations": [
      {
        "asset_class": "Equity",
        "min_percentage": 10,
        "max_percentage": 30,
        "default_percentage": 20
      },
      {
        "asset_class": "Bonds",
        "min_percentage": 50,
        "max_percentage": 70,
        "default_percentage": 60
      },
      {
        "asset_class": "Cash",
        "min_percentage": 10,
        "max_percentage": 30,
        "default_percentage": 20
      }
    ]
  }
}
```

**Question for You:**
Is this the level of configurability you need?

---

#### Question 4: Questionnaire Configurability

**Your Requirement:**

> "I want to make risk profile and suitability configurable based on the questionnaire type like single select, multi select, input text or dropdown select"

**Proposed Question Configuration:**

```json
{
  "questionnaire_type": "RISK_PROFILE",
  "questions": [
    {
      "id": "RP_Q1",
      "question_text": "What is your investment time horizon?",
      "question_type": "SINGLE_SELECT",
      "is_required": true,
      "display_order": 1,
      "options": [
        {
          "option_text": "Less than 1 year",
          "points": 1
        },
        {
          "option_text": "1-3 years",
          "points": 2
        },
        {
          "option_text": "3-5 years",
          "points": 3
        },
        {
          "option_text": "More than 5 years",
          "points": 4
        }
      ]
    },
    {
      "id": "RP_Q2",
      "question_text": "What is your annual income?",
      "question_type": "INPUT_NUMBER",
      "is_required": true,
      "display_order": 2,
      "scoring_rule": {
        "type": "RANGE_BASED",
        "ranges": [
          { "min": 0, "max": 500000, "points": 1 },
          { "min": 500001, "max": 1000000, "points": 2 },
          { "min": 1000001, "max": 5000000, "points": 3 },
          { "min": 5000001, "max": 999999999, "points": 4 }
        ]
      }
    },
    {
      "id": "RP_Q3",
      "question_text": "Select all that apply to your financial goals:",
      "question_type": "MULTI_SELECT",
      "is_required": false,
      "display_order": 3,
      "options": [
        {
          "option_text": "Retirement Planning",
          "points": 2
        },
        {
          "option_text": "Child Education",
          "points": 2
        },
        {
          "option_text": "Wealth Accumulation",
          "points": 3
        }
      ],
      "scoring_rule": {
        "type": "AVERAGE",
        "description": "Average points of selected options"
      }
    }
  ],
  "scoring": {
    "total_min": 8,
    "total_max": 35,
    "categories": [
      { "name": "Secure", "min": 8, "max": 11 },
      { "name": "Conservative", "min": 12, "max": 16 },
      { "name": "Income", "min": 17, "max": 21 },
      { "name": "Balance", "min": 22, "max": 26 },
      { "name": "Aggressive", "min": 27, "max": 31 },
      { "name": "Speculative", "min": 32, "max": 35 }
    ]
  }
}
```

**Question Types to Support:**

1. **SINGLE_SELECT** - Radio buttons (only one answer)
2. **MULTI_SELECT** - Checkboxes (multiple answers)
3. **INPUT_TEXT** - Free text (for names, descriptions)
4. **INPUT_NUMBER** - Numeric input (for amounts, percentages)
5. **DROPDOWN** - Dropdown select
6. **RANGE_SLIDER** - Slider for ranges (1-10 scale)
7. **DATE_PICKER** - For date selection

**Scoring Logic for Multi-Select:**

- Average of selected options?
- Sum of selected options?
- Maximum points from selected options?

**Please Confirm This Approach.**

---

#### Question 5: Tracking/Journey Management

**Your Requirement:**

> "We have to track which step from where RM is moving from create goal to risk profile or suitability to risk score to financial calculator to show modern portfolio strategy to push order"

**Proposed Tracking System:**

**Goal Journey Stages:**

```
1. GOAL_CREATED
2. RISK_PROFILE_IN_PROGRESS
3. RISK_PROFILE_COMPLETED
4. SUITABILITY_IN_PROGRESS
5. SUITABILITY_COMPLETED
6. RISK_SCORE_CALCULATED
7. FINANCIAL_CALC_STEP1_COMPLETED (Corpus Calculated)
8. FINANCIAL_CALC_STEP2_COMPLETED (Investment Calculated)
9. PORTFOLIO_MATCHING_IN_PROGRESS
10. PORTFOLIO_STRATEGIES_SHOWN
11. STRATEGY_SELECTED
12. ALLOCATION_REVIEWED
13. MONTE_CARLO_SIMULATION_COMPLETED
14. ORDER_DRAFTED
15. ORDER_PUSHED_TO_CLIENT
16. MFA_PENDING
17. MFA_COMPLETED
18. ORDER_PLACED
19. ORDER_EXECUTED
20. GOAL_ACTIVE
```

**Tracking Database Table:**

```sql
CREATE TABLE goal_journey_tracking (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL,
    stage_code VARCHAR(50) NOT NULL,
    stage_name VARCHAR(100) NOT NULL,
    started_at TIMESTAMP NOT NULL,
    completed_at TIMESTAMP,
    status VARCHAR(20) NOT NULL, -- IN_PROGRESS, COMPLETED, FAILED, SKIPPED
    metadata JSONB, -- Store stage-specific data
    created_by BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Example Tracking Entry:**

```json
{
  "goal_id": 123,
  "stage_code": "RISK_PROFILE_COMPLETED",
  "stage_name": "Risk Profile Questionnaire Completed",
  "started_at": "2025-12-24T10:00:00",
  "completed_at": "2025-12-24T10:15:00",
  "status": "COMPLETED",
  "metadata": {
    "total_questions": 12,
    "answers_provided": 12,
    "risk_score": 24,
    "risk_category": "Balance",
    "time_taken_seconds": 900
  }
}
```

**Benefits:**

- RM can resume from where they left off
- Analytics on drop-off points
- Audit trail for compliance
- Performance metrics (time per stage)

**Question for You:**
Do you need additional tracking like:

- Page navigation within stages?
- Edit history (if RM changes answers)?
- Multiple attempts tracking?

---

#### Question 6: Monte Carlo Simulation Requirements

**Your Requirement:**

> "then its goes to monte carlo simulation"

**What Needs to be Clarified:**

1. **Simulation Parameters:**

   - Number of simulations (e.g., 10,000 iterations)?
   - Time horizon (should match goal tenure)?
   - Confidence levels (90%, 95%, 99%)?

2. **Inputs:**

   - Portfolio allocation from selected strategy
   - Historical returns of each asset class
   - Volatility (standard deviation) of each asset class
   - Correlation between asset classes

3. **Outputs to Display:**

   - **Best Case** (e.g., 95th percentile)
   - **Expected Case** (median/50th percentile)
   - **Worst Case** (e.g., 5th percentile)
   - **Probability of achieving goal**
   - **Probability of shortfall**
   - **Expected final corpus range**

4. **Visualization:**
   - Line chart showing portfolio growth over time
   - Fan chart (showing range of outcomes)
   - Histogram of final portfolio values
   - Success probability meter

**Implementation Question:**

- Do we need to build Monte Carlo engine from scratch?
- Or integrate with third-party service?
- Or use a simplified projection model initially?

**For MVP (Minimum Viable Product):**
We could start with a **simplified projection** using:

```
Future Value = Initial × (1 + r)^t + Monthly × [((1 + r)^t - 1) / r]
```

With best/expected/worst case return rates.

**Your Preference?**

---

#### Question 7: Order Flow & MFA

**Your Requirement:**

> "RM push the order client see the excel sheet do the MFA then order place"

**Questions:**

1. **Excel Sheet Generation:**

   - What information goes into the Excel?
   - Portfolio allocation breakdown?
   - Transaction details?
   - Terms & conditions?

2. **MFA (Multi-Factor Authentication):**

   - Is this for the CLIENT or RM?
   - What type of MFA? (OTP, Email, Authenticator App)
   - Where is MFA validated? (Your system or external?)

3. **Order Execution:**

   - After MFA, does the order go to:
     - Avaloq (as per PDF)?
     - Trading system?
     - Manual processing?

4. **Client Portal:**
   - Do clients have their own login?
   - Or do they receive a secure link to review & approve?

**Please Clarify This Flow.**

---

## 3. Database Design

### 3.1 Existing Database Analysis

**Current Stack:**

- PostgreSQL (from pom.xml)
- Spring Data JPA
- Existing tables likely include:
  - users (for RM authentication)
  - questions (risk questionnaire)
  - question_options

**Let me check existing models first, then design new tables.**

### 3.2 Proposed Database Schema

#### 3.2.1 User Management

```sql
-- RM (Relationship Manager) - Already exists likely
CREATE TABLE relationship_managers (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    employee_id VARCHAR(50) UNIQUE,
    branch_code VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers (End Users managed by RM)
CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    rm_id BIGINT NOT NULL REFERENCES relationship_managers(id),
    customer_code VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    date_of_birth DATE,
    kyc_status VARCHAR(20), -- PENDING, VERIFIED, REJECTED
    created_by BIGINT NOT NULL REFERENCES relationship_managers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

#### 3.2.2 Questionnaire Configuration (Super Admin Managed)

```sql
-- Questionnaire Types
CREATE TABLE questionnaire_types (
    id BIGSERIAL PRIMARY KEY,
    type_code VARCHAR(50) UNIQUE NOT NULL, -- RISK_PROFILE, SUITABILITY
    type_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Questions (Configurable by Super Admin)
CREATE TABLE questionnaire_questions (
    id BIGSERIAL PRIMARY KEY,
    questionnaire_type_id BIGINT NOT NULL REFERENCES questionnaire_types(id),
    question_code VARCHAR(50) UNIQUE NOT NULL,
    question_text TEXT NOT NULL,
    question_type VARCHAR(30) NOT NULL, -- SINGLE_SELECT, MULTI_SELECT, INPUT_TEXT, INPUT_NUMBER, DROPDOWN, RANGE_SLIDER, DATE_PICKER
    is_required BOOLEAN DEFAULT TRUE,
    display_order INT NOT NULL,
    help_text TEXT,
    validation_rules JSONB, -- {"min": 0, "max": 100, "regex": "pattern"}
    scoring_config JSONB, -- For complex scoring rules
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Question Options (For SELECT types)
CREATE TABLE question_options (
    id BIGSERIAL PRIMARY KEY,
    question_id BIGINT NOT NULL REFERENCES questionnaire_questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    option_value VARCHAR(100), -- For storing programmatic value
    points NUMERIC(5,2), -- For scoring
    display_order INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Scoring Configuration
CREATE TABLE questionnaire_scoring (
    id BIGSERIAL PRIMARY KEY,
    questionnaire_type_id BIGINT NOT NULL REFERENCES questionnaire_types(id),
    total_min_score NUMERIC(5,2) NOT NULL,
    total_max_score NUMERIC(5,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Score Categories (e.g., Secure, Conservative, etc.)
CREATE TABLE score_categories (
    id BIGSERIAL PRIMARY KEY,
    scoring_id BIGINT NOT NULL REFERENCES questionnaire_scoring(id),
    category_code VARCHAR(50) NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    min_score NUMERIC(5,2) NOT NULL,
    max_score NUMERIC(5,2) NOT NULL,
    description TEXT,
    display_order INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

#### 3.2.3 Goals Management

```sql
-- Customer Goals
CREATE TABLE customer_goals (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers(id),
    goal_code VARCHAR(50) UNIQUE NOT NULL,
    goal_name VARCHAR(200) NOT NULL,
    goal_type VARCHAR(50), -- RETIREMENT, EDUCATION, WEALTH_CREATION, HOUSE_PURCHASE
    goal_status VARCHAR(30) NOT NULL, -- DRAFT, IN_PROGRESS, ACTIVE, COMPLETED, CANCELLED
    current_stage VARCHAR(50), -- Latest journey stage
    created_by BIGINT NOT NULL REFERENCES relationship_managers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Goal Journey Tracking
CREATE TABLE goal_journey_tracking (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL REFERENCES customer_goals(id),
    stage_code VARCHAR(50) NOT NULL,
    stage_name VARCHAR(100) NOT NULL,
    started_at TIMESTAMP NOT NULL,
    completed_at TIMESTAMP,
    status VARCHAR(20) NOT NULL, -- IN_PROGRESS, COMPLETED, FAILED, SKIPPED
    metadata JSONB, -- Stage-specific data
    created_by BIGINT NOT NULL REFERENCES relationship_managers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

#### 3.2.4 Questionnaire Responses

```sql
-- Risk Profile Responses
CREATE TABLE risk_profile_responses (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL REFERENCES customer_goals(id),
    question_id BIGINT NOT NULL REFERENCES questionnaire_questions(id),
    response_text TEXT, -- For text/number inputs
    response_number NUMERIC(15,2), -- For numeric inputs
    response_date DATE, -- For date inputs
    selected_option_ids BIGINT[], -- Array of selected option IDs (for multi-select)
    points_earned NUMERIC(5,2), -- Points from this answer
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    answered_by BIGINT NOT NULL REFERENCES relationship_managers(id)
);

-- Suitability Responses (Same structure)
CREATE TABLE suitability_responses (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL REFERENCES customer_goals(id),
    question_id BIGINT NOT NULL REFERENCES questionnaire_questions(id),
    response_text TEXT,
    response_number NUMERIC(15,2),
    response_date DATE,
    selected_option_ids BIGINT[],
    points_earned NUMERIC(5,2),
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    answered_by BIGINT NOT NULL REFERENCES relationship_managers(id)
);

-- Risk Score Results
CREATE TABLE risk_score_results (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL UNIQUE REFERENCES customer_goals(id),
    total_score NUMERIC(5,2) NOT NULL,
    category_id BIGINT NOT NULL REFERENCES score_categories(id),
    category_code VARCHAR(50) NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    calculated_by BIGINT NOT NULL REFERENCES relationship_managers(id)
);

-- Suitability Assessment Results
CREATE TABLE suitability_assessment_results (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL UNIQUE REFERENCES customer_goals(id),
    knowledge_level VARCHAR(30), -- LOW, MEDIUM, HIGH
    experience_level VARCHAR(30),
    financial_capacity VARCHAR(30),
    investment_objective VARCHAR(50), -- CAPITAL_PRESERVATION, INCOME, GROWTH, SPECULATION
    is_suitable_for_investment BOOLEAN DEFAULT TRUE,
    restricted_portfolio_types TEXT[], -- Array of portfolio types client cannot access
    assessment_notes TEXT,
    assessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assessed_by BIGINT NOT NULL REFERENCES relationship_managers(id)
);
```

---

#### 3.2.5 Financial Calculator

```sql
-- Financial Calculator Inputs & Results
CREATE TABLE financial_calculations (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL UNIQUE REFERENCES customer_goals(id),

    -- Step 1: Corpus Calculation
    target_amount NUMERIC(15,2) NOT NULL,
    tenure_years INT NOT NULL,
    inflation_rate NUMERIC(5,2) NOT NULL,
    calculated_corpus NUMERIC(15,2) NOT NULL,

    -- Step 2: Investment Calculation
    initial_investment NUMERIC(15,2),
    monthly_investment NUMERIC(15,2),
    investment_tenure_years INT,
    assumed_return_rate NUMERIC(5,2),
    calculated_future_value NUMERIC(15,2),

    -- Matching Results
    shortfall_surplus NUMERIC(15,2), -- calculated_future_value - calculated_corpus
    is_goal_achievable BOOLEAN,
    required_return_rate NUMERIC(5,2), -- Reverse calculated if needed

    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    calculated_by BIGINT NOT NULL REFERENCES relationship_managers(id)
);
```

---

#### 3.2.6 Modern Portfolio Configuration

```sql
-- Asset Classes (Configurable by Super Admin)
CREATE TABLE asset_classes (
    id BIGSERIAL PRIMARY KEY,
    class_code VARCHAR(50) UNIQUE NOT NULL, -- EQUITY, BONDS, GOLD, CASH, MUTUAL_FUND, REAL_ESTATE
    class_name VARCHAR(100) NOT NULL,
    class_type VARCHAR(30), -- GROWTH, INCOME, DEFENSIVE
    risk_level VARCHAR(20), -- HIGH, MEDIUM, LOW
    liquidity_level VARCHAR(20), -- HIGH, MEDIUM, LOW
    expected_return_min NUMERIC(5,2),
    expected_return_max NUMERIC(5,2),
    volatility NUMERIC(5,2), -- Standard deviation
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Portfolio Templates (Configurable by Super Admin)
CREATE TABLE portfolio_templates (
    id BIGSERIAL PRIMARY KEY,
    portfolio_code VARCHAR(50) UNIQUE NOT NULL,
    portfolio_name VARCHAR(200) NOT NULL,
    description TEXT,
    risk_category_codes TEXT[], -- ['Secure', 'Conservative']
    risk_score_min NUMERIC(5,2),
    risk_score_max NUMERIC(5,2),
    expected_return_min NUMERIC(5,2),
    expected_return_max NUMERIC(5,2),
    recommended_tenure_min_years INT,
    recommended_tenure_max_years INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Portfolio Asset Allocations
CREATE TABLE portfolio_allocations (
    id BIGSERIAL PRIMARY KEY,
    portfolio_id BIGINT NOT NULL REFERENCES portfolio_templates(id) ON DELETE CASCADE,
    asset_class_id BIGINT NOT NULL REFERENCES asset_classes(id),
    min_percentage NUMERIC(5,2) NOT NULL CHECK (min_percentage >= 0 AND min_percentage <= 100),
    max_percentage NUMERIC(5,2) NOT NULL CHECK (max_percentage >= 0 AND max_percentage <= 100),
    default_percentage NUMERIC(5,2) NOT NULL CHECK (default_percentage >= min_percentage AND default_percentage <= max_percentage),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(portfolio_id, asset_class_id)
);

-- Suitability Rules (Maps suitability results to allowed portfolios)
CREATE TABLE portfolio_suitability_rules (
    id BIGSERIAL PRIMARY KEY,
    portfolio_id BIGINT NOT NULL REFERENCES portfolio_templates(id),
    min_knowledge_level VARCHAR(30), -- LOW, MEDIUM, HIGH
    min_experience_level VARCHAR(30),
    required_financial_capacity VARCHAR(30),
    allowed_objectives TEXT[], -- ['GROWTH', 'INCOME']
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

#### 3.2.7 Portfolio Selection & Allocation

```sql
-- Eligible Portfolios for Goal (After Matching)
CREATE TABLE goal_eligible_portfolios (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL REFERENCES customer_goals(id),
    portfolio_id BIGINT NOT NULL REFERENCES portfolio_templates(id),
    eligibility_score NUMERIC(5,2), -- How well it matches (0-100)
    is_recommended BOOLEAN DEFAULT FALSE,
    reason TEXT, -- Why this portfolio is eligible
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Selected Portfolio Strategy
CREATE TABLE goal_selected_strategy (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL UNIQUE REFERENCES customer_goals(id),
    portfolio_id BIGINT NOT NULL REFERENCES portfolio_templates(id),
    selected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    selected_by BIGINT NOT NULL REFERENCES relationship_managers(id),
    selection_notes TEXT
);

-- Final Asset Allocation (Can be customized from template)
CREATE TABLE goal_asset_allocations (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL REFERENCES customer_goals(id),
    asset_class_id BIGINT NOT NULL REFERENCES asset_classes(id),
    allocated_percentage NUMERIC(5,2) NOT NULL CHECK (allocated_percentage >= 0 AND allocated_percentage <= 100),
    allocated_amount NUMERIC(15,2), -- Actual amount in currency
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(goal_id, asset_class_id)
);
```

---

#### 3.2.8 Monte Carlo Simulation

```sql
-- Monte Carlo Simulation Results
CREATE TABLE monte_carlo_simulations (
    id BIGSERIAL PRIMARY KEY,
    goal_id BIGINT NOT NULL REFERENCES customer_goals(id),

    -- Simulation Parameters
    num_iterations INT NOT NULL DEFAULT 10000,
    time_horizon_years INT NOT NULL,
    initial_investment NUMERIC(15,2),
    monthly_contribution NUMERIC(15,2),

    -- Results
    best_case_value NUMERIC(15,2), -- 95th percentile
    expected_value NUMERIC(15,2), -- 50th percentile (median)
    worst_case_value NUMERIC(15,2), -- 5th percentile
    probability_of_success NUMERIC(5,2), -- % chance of meeting goal
    probability_of_shortfall NUMERIC(5,2),

    -- Distribution Data (for charts)
    simulation_data JSONB, -- Store percentiles, histogram data

    simulated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    simulated_by BIGINT NOT NULL REFERENCES relationship_managers(id)
);
```

---

#### 3.2.9 Order Management

```sql
-- Orders
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    order_code VARCHAR(50) UNIQUE NOT NULL,
    goal_id BIGINT NOT NULL REFERENCES customer_goals(id),
    customer_id BIGINT NOT NULL REFERENCES customers(id),

    order_status VARCHAR(30) NOT NULL, -- DRAFTED, PENDING_MFA, MFA_COMPLETED, SUBMITTED, EXECUTED, REJECTED, CANCELLED

    total_investment_amount NUMERIC(15,2) NOT NULL,

    -- Excel/PDF Document
    document_url VARCHAR(500),
    document_generated_at TIMESTAMP,

    -- MFA
    mfa_required BOOLEAN DEFAULT TRUE,
    mfa_method VARCHAR(30), -- OTP, EMAIL, AUTHENTICATOR
    mfa_sent_at TIMESTAMP,
    mfa_verified_at TIMESTAMP,
    mfa_attempts INT DEFAULT 0,

    -- Order Lifecycle
    drafted_at TIMESTAMP,
    submitted_at TIMESTAMP,
    executed_at TIMESTAMP,

    created_by BIGINT NOT NULL REFERENCES relationship_managers(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order Line Items (Asset-wise breakdown)
CREATE TABLE order_line_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    asset_class_id BIGINT NOT NULL REFERENCES asset_classes(id),
    allocated_percentage NUMERIC(5,2),
    investment_amount NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order Audit Log
CREATE TABLE order_audit_log (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id),
    action VARCHAR(50) NOT NULL, -- CREATED, MODIFIED, SUBMITTED, MFA_SENT, MFA_VERIFIED, EXECUTED
    action_by BIGINT NOT NULL REFERENCES relationship_managers(id),
    action_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,
    metadata JSONB
);
```

---

#### 3.2.10 System Configuration (Super Admin)

```sql
-- Super Admin Users
CREATE TABLE super_admins (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- System Settings
CREATE TABLE system_settings (
    id BIGSERIAL PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT NOT NULL,
    setting_type VARCHAR(30), -- STRING, NUMBER, BOOLEAN, JSON
    description TEXT,
    updated_by BIGINT REFERENCES super_admins(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example settings:
-- 'monte_carlo.default_iterations' = '10000'
-- 'monte_carlo.confidence_level' = '95'
-- 'mfa.default_method' = 'OTP'
-- 'risk_score.calculation_method' = 'WEIGHTED_AVERAGE'
```

---

### 3.3 Database Indexes

```sql
-- Performance Optimization Indexes
CREATE INDEX idx_customers_rm_id ON customers(rm_id);
CREATE INDEX idx_customer_goals_customer_id ON customer_goals(customer_id);
CREATE INDEX idx_customer_goals_status ON customer_goals(goal_status);
CREATE INDEX idx_journey_tracking_goal_id ON goal_journey_tracking(goal_id);
CREATE INDEX idx_journey_tracking_stage ON goal_journey_tracking(stage_code);
CREATE INDEX idx_risk_responses_goal_id ON risk_profile_responses(goal_id);
CREATE INDEX idx_suitability_responses_goal_id ON suitability_responses(goal_id);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_questions_type ON questionnaire_questions(questionnaire_type_id);
CREATE INDEX idx_portfolio_templates_active ON portfolio_templates(is_active);
```

---

## 4. Backend API Design

### 4.1 Technology Stack (Existing)

- Spring Boot 4.0.0
- Java 21
- PostgreSQL
- Spring Security + JWT
- MapStruct for DTOs
- Swagger/OpenAPI for documentation

---

### 4.2 API Modules & Endpoints

#### Module 1: Customer Management

```java
// CustomerController.java

// 1. Get all customers for logged-in RM
GET /api/rm/customers
Response: List<CustomerDto>

// 2. Get customer by ID
GET /api/rm/customers/{customerId}
Response: CustomerDetailDto

// 3. Create new customer
POST /api/rm/customers
Request: CreateCustomerRequest
Response: CustomerDto

// 4. Update customer
PUT /api/rm/customers/{customerId}
Request: UpdateCustomerRequest
Response: CustomerDto

// 5. Search customers
GET /api/rm/customers/search?query={searchTerm}
Response: List<CustomerDto>
```

**DTOs:**

```java
public record CustomerDto(
    Long id,
    String customerCode,
    String firstName,
    String lastName,
    String email,
    String phone,
    String kycStatus,
    LocalDateTime createdAt
) {}

public record CreateCustomerRequest(
    @NotBlank String firstName,
    @NotBlank String lastName,
    @Email String email,
    @Pattern(regexp = "^[0-9]{10}$") String phone,
    @NotNull LocalDate dateOfBirth
) {}
```

---

#### Module 2: Goal Management

```java
// GoalController.java

// 1. Get all goals for a customer
GET /api/rm/customers/{customerId}/goals
Response: List<GoalSummaryDto>

// 2. Get goal details with journey status
GET /api/rm/goals/{goalId}
Response: GoalDetailDto

// 3. Create new goal
POST /api/rm/customers/{customerId}/goals
Request: CreateGoalRequest
Response: GoalDto

// 4. Update goal
PUT /api/rm/goals/{goalId}
Request: UpdateGoalRequest
Response: GoalDto

// 5. Get goal journey progress
GET /api/rm/goals/{goalId}/journey
Response: GoalJourneyDto
```

**DTOs:**

```java
public record CreateGoalRequest(
    @NotBlank String goalName,
    String goalType // RETIREMENT, EDUCATION, etc.
) {}

public record GoalJourneyDto(
    Long goalId,
    String goalName,
    String currentStage,
    List<JourneyStageDto> stages,
    Integer completionPercentage
) {}

public record JourneyStageDto(
    String stageCode,
    String stageName,
    String status, // PENDING, IN_PROGRESS, COMPLETED
    LocalDateTime startedAt,
    LocalDateTime completedAt
) {}
```

---

#### Module 3: Questionnaire Management (Super Admin)

```java
// QuestionnaireAdminController.java

// 1. Get all questionnaire types
GET /api/admin/questionnaires/types
Response: List<QuestionnaireTypeDto>

// 2. Get questions for a questionnaire type
GET /api/admin/questionnaires/{typeCode}/questions
Response: List<QuestionDto>

// 3. Create new question
POST /api/admin/questionnaires/{typeCode}/questions
Request: CreateQuestionRequest
Response: QuestionDto

// 4. Update question
PUT /api/admin/questionnaires/questions/{questionId}
Request: UpdateQuestionRequest
Response: QuestionDto

// 5. Reorder questions
PUT /api/admin/questionnaires/{typeCode}/questions/reorder
Request: ReorderQuestionsRequest
Response: void

// 6. Get scoring configuration
GET /api/admin/questionnaires/{typeCode}/scoring
Response: ScoringConfigDto

// 7. Update scoring configuration
PUT /api/admin/questionnaires/{typeCode}/scoring
Request: UpdateScoringRequest
Response: ScoringConfigDto
```

**DTOs:**

```java
public record CreateQuestionRequest(
    @NotBlank String questionText,
    @NotBlank String questionType, // SINGLE_SELECT, MULTI_SELECT, etc.
    Boolean isRequired,
    Integer displayOrder,
    String helpText,
    Map<String, Object> validationRules,
    Map<String, Object> scoringConfig,
    List<CreateOptionRequest> options
) {}

public record CreateOptionRequest(
    @NotBlank String optionText,
    String optionValue,
    BigDecimal points,
    Integer displayOrder
) {}
```

---

#### Module 4: Risk Profile Assessment

```java
// RiskProfileController.java

// 1. Get risk profile questionnaire for goal
GET /api/rm/goals/{goalId}/risk-profile/questions
Response: QuestionnaireDto

// 2. Submit risk profile answer (single question)
POST /api/rm/goals/{goalId}/risk-profile/answers
Request: SubmitAnswerRequest
Response: AnswerResponseDto

// 3. Submit complete risk profile (all answers at once)
POST /api/rm/goals/{goalId}/risk-profile/submit
Request: SubmitRiskProfileRequest
Response: RiskScoreResultDto

// 4. Get risk score result
GET /api/rm/goals/{goalId}/risk-score
Response: RiskScoreResultDto

// 5. Re-calculate risk score (if answers edited)
POST /api/rm/goals/{goalId}/risk-score/recalculate
Response: RiskScoreResultDto
```

**DTOs:**

```java
public record QuestionnaireDto(
    String questionnaireType,
    List<QuestionDto> questions,
    ScoringConfigDto scoring
) {}

public record SubmitAnswerRequest(
    Long questionId,
    String responseText,
    BigDecimal responseNumber,
    LocalDate responseDate,
    List<Long> selectedOptionIds
) {}

public record RiskScoreResultDto(
    Long goalId,
    BigDecimal totalScore,
    String categoryCode,
    String categoryName,
    String description,
    LocalDateTime calculatedAt
) {}
```

**Business Logic:**

```java
@Service
public class RiskScoreCalculationService {

    public RiskScoreResultDto calculateRiskScore(Long goalId) {
        // 1. Fetch all risk profile responses for goal
        List<RiskProfileResponse> responses = responseRepository.findByGoalId(goalId);

        // 2. Calculate total score
        BigDecimal totalScore = BigDecimal.ZERO;

        for (RiskProfileResponse response : responses) {
            Question question = response.getQuestion();

            switch (question.getQuestionType()) {
                case SINGLE_SELECT, MULTI_SELECT -> {
                    // Sum points from selected options
                    totalScore = totalScore.add(response.getPointsEarned());
                }
                case INPUT_NUMBER -> {
                    // Apply range-based scoring from question.scoringConfig
                    BigDecimal points = applyRangeScoring(
                        question.getScoringConfig(),
                        response.getResponseNumber()
                    );
                    totalScore = totalScore.add(points);
                }
                // Handle other types...
            }
        }

        // 3. Determine category based on total score
        ScoreCategory category = categoryRepository
            .findByScoreRange(totalScore)
            .orElseThrow(() -> new InvalidScoreException("Score out of range"));

        // 4. Save result
        RiskScoreResult result = new RiskScoreResult();
        result.setGoalId(goalId);
        result.setTotalScore(totalScore);
        result.setCategoryCode(category.getCategoryCode());
        result.setCategoryName(category.getCategoryName());

        return riskScoreRepository.save(result);
    }

    private BigDecimal applyRangeScoring(Map<String, Object> config, BigDecimal value) {
        // Parse ranges from config and return appropriate points
        // Example config: {"ranges": [{"min": 0, "max": 500000, "points": 1}, ...]}
        // Implementation details...
    }
}
```

---

#### Module 5: Suitability Assessment

```java
// SuitabilityController.java

// 1. Get suitability questionnaire
GET /api/rm/goals/{goalId}/suitability/questions
Response: QuestionnaireDto

// 2. Submit suitability answers
POST /api/rm/goals/{goalId}/suitability/submit
Request: SubmitSuitabilityRequest
Response: SuitabilityResultDto

// 3. Get suitability result
GET /api/rm/goals/{goalId}/suitability/result
Response: SuitabilityResultDto
```

**DTOs:**

```java
public record SuitabilityResultDto(
    Long goalId,
    String knowledgeLevel,
    String experienceLevel,
    String financialCapacity,
    String investmentObjective,
    Boolean isSuitableForInvestment,
    List<String> restrictedPortfolioTypes,
    String assessmentNotes,
    LocalDateTime assessedAt
) {}
```

**Business Logic:**

```java
@Service
public class SuitabilityAssessmentService {

    public SuitabilityResultDto assessSuitability(Long goalId, SubmitSuitabilityRequest request) {
        // 1. Analyze responses to determine:
        //    - Knowledge level (based on education, experience questions)
        //    - Financial capacity (based on income, assets questions)
        //    - Investment objective (based on goal questions)

        // 2. Apply business rules
        //    Example: If knowledge = LOW AND objective = SPECULATION → NOT SUITABLE

        // 3. Determine restricted portfolios
        List<String> restrictions = new ArrayList<>();
        if (knowledgeLevel.equals("LOW")) {
            restrictions.add("AGGRESSIVE");
            restrictions.add("SPECULATIVE");
        }

        // 4. Save and return result
        // ...
    }
}
```

---

#### Module 6: Financial Calculator

```java
// FinancialCalculatorController.java

// 1. Calculate corpus (Step 1)
POST /api/rm/goals/{goalId}/financial-calc/corpus
Request: CalculateCorpusRequest
Response: CorpusResultDto

// 2. Calculate investment requirement (Step 2)
POST /api/rm/goals/{goalId}/financial-calc/investment
Request: CalculateInvestmentRequest
Response: InvestmentResultDto

// 3. Get complete financial calculation
GET /api/rm/goals/{goalId}/financial-calc/result
Response: FinancialCalculationDto

// 4. Reverse calculate required return rate
POST /api/rm/goals/{goalId}/financial-calc/required-return
Request: ReverseCalculateRequest
Response: RequiredReturnDto
```

**DTOs:**

```java
public record CalculateCorpusRequest(
    @NotNull BigDecimal targetAmount,
    @NotNull Integer tenureYears,
    @NotNull BigDecimal inflationRate
) {}

public record CorpusResultDto(
    BigDecimal targetAmount,
    Integer tenureYears,
    BigDecimal inflationRate,
    BigDecimal calculatedCorpus,
    String formula,
    Map<String, BigDecimal> yearWiseProjection // Year -> Inflated amount
) {}

public record CalculateInvestmentRequest(
    @NotNull BigDecimal initialInvestment,
    @NotNull BigDecimal monthlyInvestment,
    @NotNull Integer tenureYears,
    @NotNull BigDecimal assumedReturnRate
) {}

public record InvestmentResultDto(
    BigDecimal initialInvestment,
    BigDecimal monthlyInvestment,
    Integer tenureYears,
    BigDecimal assumedReturnRate,
    BigDecimal calculatedFutureValue,
    BigDecimal totalInvested,
    BigDecimal totalReturns,
    Boolean isGoalAchievable,
    BigDecimal shortfallOrSurplus
) {}
```

**Business Logic - Formulas:**

```java
@Service
public class FinancialCalculatorService {

    // Step 1: Calculate inflation-adjusted corpus
    public BigDecimal calculateCorpus(BigDecimal targetAmount, int years, BigDecimal inflationRate) {
        // Formula: FV = PV × (1 + inflation)^years
        double inflationMultiplier = Math.pow(1 + inflationRate.doubleValue() / 100, years);
        return targetAmount.multiply(BigDecimal.valueOf(inflationMultiplier));
    }

    // Step 2: Calculate future value of investments
    public BigDecimal calculateFutureValue(
        BigDecimal initial,
        BigDecimal monthly,
        int years,
        BigDecimal returnRate
    ) {
        double r = returnRate.doubleValue() / 100 / 12; // Monthly rate
        int n = years * 12; // Total months

        // FV of lump sum: Initial × (1 + r)^n
        double fvLumpSum = initial.doubleValue() * Math.pow(1 + r, n);

        // FV of SIP: Monthly × [((1 + r)^n - 1) / r] × (1 + r)
        double fvSip = monthly.doubleValue() *
                       (Math.pow(1 + r, n) - 1) / r * (1 + r);

        return BigDecimal.valueOf(fvLumpSum + fvSip);
    }

    // Reverse calculate required return
    public BigDecimal calculateRequiredReturn(
        BigDecimal initial,
        BigDecimal monthly,
        int years,
        BigDecimal targetCorpus
    ) {
        // Use Newton-Raphson or binary search to find return rate
        // that makes calculatedFutureValue = targetCorpus
        // Implementation using iterative approach...
        return findReturnRate(initial, monthly, years, targetCorpus);
    }
}
```

---

#### Module 7: Portfolio Matching & Recommendation

```java
// PortfolioMatchingController.java

// 1. Get eligible portfolios for goal
POST /api/rm/goals/{goalId}/portfolios/match
Response: PortfolioMatchResultDto

// 2. Get portfolio details
GET /api/rm/portfolios/{portfolioId}
Response: PortfolioDetailDto

// 3. Get all active portfolios (for reference)
GET /api/rm/portfolios
Response: List<PortfolioSummaryDto>
```

**DTOs:**

```java
public record PortfolioMatchResultDto(
    Long goalId,
    RiskScoreResultDto riskScore,
    SuitabilityResultDto suitability,
    FinancialCalculationDto financialCalc,
    List<EligiblePortfolioDto> eligiblePortfolios,
    PortfolioDetailDto recommendedPortfolio
) {}

public record EligiblePortfolioDto(
    Long portfolioId,
    String portfolioCode,
    String portfolioName,
    String description,
    BigDecimal expectedReturnMin,
    BigDecimal expectedReturnMax,
    BigDecimal eligibilityScore, // 0-100
    Boolean isRecommended,
    String matchReason,
    List<AssetAllocationDto> allocations
) {}

public record AssetAllocationDto(
    String assetClassName,
    BigDecimal minPercentage,
    BigDecimal maxPercentage,
    BigDecimal defaultPercentage
) {}
```

**Business Logic - Matching Engine:**

```java
@Service
public class PortfolioMatchingService {

    public PortfolioMatchResultDto matchPortfolios(Long goalId) {
        // 1. Get all inputs
        RiskScoreResult riskScore = riskScoreService.getRiskScore(goalId);
        SuitabilityResult suitability = suitabilityService.getResult(goalId);
        FinancialCalculation finCalc = financialCalcService.getResult(goalId);

        // 2. Get all active portfolios
        List<PortfolioTemplate> allPortfolios = portfolioRepository.findAllActive();

        // 3. Filter eligible portfolios
        List<EligiblePortfolio> eligible = new ArrayList<>();

        for (PortfolioTemplate portfolio : allPortfolios) {

            // Check 1: Risk score range
            if (!isRiskScoreInRange(riskScore, portfolio)) {
                continue;
            }

            // Check 2: Suitability rules
            if (!meetsSuitabilityRequirements(suitability, portfolio)) {
                continue;
            }

            // Check 3: Expected return vs required return
            BigDecimal requiredReturn = finCalc.getRequiredReturnRate();
            if (requiredReturn != null) {
                if (!canAchieveRequiredReturn(portfolio, requiredReturn)) {
                    continue; // Portfolio can't meet return requirements
                }
            }

            // Calculate eligibility score (0-100)
            BigDecimal eligibilityScore = calculateEligibilityScore(
                riskScore, suitability, finCalc, portfolio
            );

            eligible.add(new EligiblePortfolio(portfolio, eligibilityScore));
        }

        // 4. Sort by eligibility score
        eligible.sort((a, b) -> b.getEligibilityScore().compareTo(a.getEligibilityScore()));

        // 5. Mark top portfolio as recommended
        if (!eligible.isEmpty()) {
            eligible.get(0).setRecommended(true);
        }

        // 6. Save eligible portfolios
        saveEligiblePortfolios(goalId, eligible);

        return buildMatchResult(goalId, eligible);
    }

    private BigDecimal calculateEligibilityScore(
        RiskScoreResult risk,
        SuitabilityResult suit,
        FinancialCalculation fin,
        PortfolioTemplate portfolio
    ) {
        // Weighted scoring:
        // 40% - Risk score match
        // 30% - Suitability alignment
        // 30% - Return potential vs requirement

        BigDecimal riskMatch = calculateRiskMatch(risk, portfolio) * 0.40;
        BigDecimal suitMatch = calculateSuitabilityMatch(suit, portfolio) * 0.30;
        BigDecimal returnMatch = calculateReturnMatch(fin, portfolio) * 0.30;

        return riskMatch + suitMatch + returnMatch;
    }
}
```

---

#### Module 8: Portfolio Selection & Allocation

```java
// PortfolioSelectionController.java

// 1. Select portfolio strategy
POST /api/rm/goals/{goalId}/portfolio/select
Request: SelectPortfolioRequest
Response: SelectedStrategyDto

// 2. Get asset allocation for selected portfolio
GET /api/rm/goals/{goalId}/portfolio/allocation
Response: AssetAllocationDetailDto

// 3. Customize asset allocation
PUT /api/rm/goals/{goalId}/portfolio/allocation
Request: CustomizeAllocationRequest
Response: AssetAllocationDetailDto

// 4. Finalize allocation
POST /api/rm/goals/{goalId}/portfolio/allocation/finalize
Response: FinalizedAllocationDto
```

**DTOs:**

```java
public record SelectPortfolioRequest(
    @NotNull Long portfolioId,
    String selectionNotes
) {}

public record AssetAllocationDetailDto(
    Long goalId,
    String portfolioName,
    BigDecimal totalInvestmentAmount,
    List<AssetAllocationLineDto> allocations
) {}

public record AssetAllocationLineDto(
    Long assetClassId,
    String assetClassName,
    String assetClassCode,
    BigDecimal allocatedPercentage,
    BigDecimal allocatedAmount,
    BigDecimal expectedReturn,
    String riskLevel
) {}

public record CustomizeAllocationRequest(
    List<CustomAllocationDto> allocations
) {}

public record CustomAllocationDto(
    @NotNull Long assetClassId,
    @NotNull BigDecimal percentage // Must sum to 100
) {}
```

**Business Logic:**

```java
@Service
public class AllocationService {

    public AssetAllocationDetailDto customizeAllocation(
        Long goalId,
        CustomizeAllocationRequest request
    ) {
        // 1. Validation: percentages must sum to 100
        BigDecimal sum = request.allocations().stream()
            .map(CustomAllocationDto::percentage)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (sum.compareTo(BigDecimal.valueOf(100)) != 0) {
            throw new ValidationException("Allocations must sum to 100%");
        }

        // 2. Check against portfolio constraints (min/max per asset class)
        PortfolioTemplate portfolio = getSelectedPortfolio(goalId);

        for (CustomAllocationDto alloc : request.allocations()) {
            PortfolioAllocation constraint = portfolio.getAllocation(alloc.assetClassId());

            if (alloc.percentage().compareTo(constraint.getMinPercentage()) < 0 ||
                alloc.percentage().compareTo(constraint.getMaxPercentage()) > 0) {
                throw new ValidationException(
                    "Allocation for " + constraint.getAssetClass().getName() +
                    " must be between " + constraint.getMinPercentage() + "% and " +
                    constraint.getMaxPercentage() + "%"
                );
            }
        }

        // 3. Calculate amounts
        BigDecimal totalAmount = getTotalInvestmentAmount(goalId);

        List<AssetAllocationLineDto> lines = request.allocations().stream()
            .map(alloc -> {
                BigDecimal amount = totalAmount
                    .multiply(alloc.percentage())
                    .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

                return new AssetAllocationLineDto(
                    alloc.assetClassId(),
                    getAssetClassName(alloc.assetClassId()),
                    getAssetClassCode(alloc.assetClassId()),
                    alloc.percentage(),
                    amount,
                    getExpectedReturn(alloc.assetClassId()),
                    getRiskLevel(alloc.assetClassId())
                );
            })
            .toList();

        // 4. Save allocation
        saveAllocation(goalId, lines);

        return new AssetAllocationDetailDto(goalId, portfolio.getName(), totalAmount, lines);
    }
}
```

---

#### Module 9: Monte Carlo Simulation

```java
// MonteCarloController.java

// 1. Run Monte Carlo simulation
POST /api/rm/goals/{goalId}/simulation/run
Request: RunSimulationRequest
Response: SimulationResultDto

// 2. Get simulation result
GET /api/rm/goals/{goalId}/simulation/result
Response: SimulationResultDto

// 3. Get simulation chart data
GET /api/rm/goals/{goalId}/simulation/chart-data
Response: SimulationChartDataDto
```

**DTOs:**

```java
public record RunSimulationRequest(
    Integer numIterations, // Default: 10000
    Integer confidenceLevel // Default: 95
) {}

public record SimulationResultDto(
    Long goalId,
    Integer numIterations,
    Integer timeHorizonYears,
    BigDecimal initialInvestment,
    BigDecimal monthlyContribution,

    BigDecimal targetCorpus,

    BigDecimal bestCaseValue,      // 95th percentile
    BigDecimal expectedValue,      // 50th percentile (median)
    BigDecimal worstCaseValue,     // 5th percentile

    BigDecimal probabilityOfSuccess,  // % chance of meeting goal
    BigDecimal probabilityOfShortfall,

    LocalDateTime simulatedAt
) {}

public record SimulationChartDataDto(
    List<YearProjectionDto> yearlyProjections,
    List<PercentileDto> percentiles,
    HistogramDataDto histogram
) {}

public record YearProjectionDto(
    Integer year,
    BigDecimal bestCase,
    BigDecimal expected,
    BigDecimal worstCase
) {}
```

**Business Logic - Monte Carlo Implementation:**

**Option 1: Simplified Projection (MVP)**

```java
@Service
public class SimplifiedProjectionService {

    public SimulationResultDto runSimplifiedProjection(Long goalId) {
        // Get inputs
        FinancialCalculation finCalc = getFinancialCalc(goalId);
        AssetAllocationDetail allocation = getAllocation(goalId);

        // Calculate portfolio expected return & volatility
        PortfolioMetrics metrics = calculatePortfolioMetrics(allocation);
        BigDecimal expectedReturn = metrics.getExpectedReturn();
        BigDecimal volatility = metrics.getVolatility();

        // Best case: Expected return + 2 * volatility
        BigDecimal bestReturn = expectedReturn.add(volatility.multiply(BigDecimal.valueOf(2)));
        BigDecimal bestCase = calculateFutureValue(
            finCalc.getInitialInvestment(),
            finCalc.getMonthlyInvestment(),
            finCalc.getTenureYears(),
            bestReturn
        );

        // Expected case: Expected return
        BigDecimal expectedCase = calculateFutureValue(
            finCalc.getInitialInvestment(),
            finCalc.getMonthlyInvestment(),
            finCalc.getTenureYears(),
            expectedReturn
        );

        // Worst case: Expected return - 2 * volatility
        BigDecimal worstReturn = expectedReturn.subtract(volatility.multiply(BigDecimal.valueOf(2)));
        BigDecimal worstCase = calculateFutureValue(
            finCalc.getInitialInvestment(),
            finCalc.getMonthlyInvestment(),
            finCalc.getTenureYears(),
            worstReturn
        );

        // Calculate probability of success
        // Using normal distribution assumption
        BigDecimal targetCorpus = finCalc.getCalculatedCorpus();
        BigDecimal probabilityOfSuccess = calculateProbability(
            expectedCase,
            worstCase,
            bestCase,
            targetCorpus
        );

        return new SimulationResultDto(/* ... */);
    }

    private PortfolioMetrics calculatePortfolioMetrics(AssetAllocationDetail allocation) {
        // Weighted average of expected returns
        BigDecimal portfolioReturn = BigDecimal.ZERO;
        BigDecimal portfolioVariance = BigDecimal.ZERO;

        for (AssetAllocationLineDto line : allocation.getAllocations()) {
            AssetClass asset = assetClassRepository.findById(line.assetClassId()).get();

            BigDecimal weight = line.allocatedPercentage().divide(BigDecimal.valueOf(100));
            BigDecimal assetReturn = asset.getExpectedReturnAverage();
            BigDecimal assetVolatility = asset.getVolatility();

            portfolioReturn = portfolioReturn.add(weight.multiply(assetReturn));
            portfolioVariance = portfolioVariance.add(
                weight.multiply(weight).multiply(assetVolatility).multiply(assetVolatility)
            );
        }

        BigDecimal portfolioVolatility = BigDecimal.valueOf(Math.sqrt(portfolioVariance.doubleValue()));

        return new PortfolioMetrics(portfolioReturn, portfolioVolatility);
    }
}
```

**Option 2: Full Monte Carlo Simulation (Advanced)**

```java
@Service
public class MonteCarloSimulationService {

    private final Random random = new Random();

    public SimulationResultDto runMonteCarlo(Long goalId, int iterations) {
        // Get inputs
        FinancialCalculation finCalc = getFinancialCalc(goalId);
        AssetAllocationDetail allocation = getAllocation(goalId);
        PortfolioMetrics metrics = calculatePortfolioMetrics(allocation);

        int years = finCalc.getTenureYears();
        BigDecimal initial = finCalc.getInitialInvestment();
        BigDecimal monthly = finCalc.getMonthlyInvestment();

        // Run simulations
        double[] finalValues = new double[iterations];

        for (int i = 0; i < iterations; i++) {
            finalValues[i] = simulateSinglePath(
                initial.doubleValue(),
                monthly.doubleValue(),
                years,
                metrics.getExpectedReturn().doubleValue() / 100,
                metrics.getVolatility().doubleValue() / 100
            );
        }

        // Sort results
        Arrays.sort(finalValues);

        // Extract percentiles
        int p5Index = (int) (iterations * 0.05);
        int p50Index = (int) (iterations * 0.50);
        int p95Index = (int) (iterations * 0.95);

        BigDecimal worstCase = BigDecimal.valueOf(finalValues[p5Index]);
        BigDecimal expectedCase = BigDecimal.valueOf(finalValues[p50Index]);
        BigDecimal bestCase = BigDecimal.valueOf(finalValues[p95Index]);

        // Calculate success probability
        BigDecimal targetCorpus = finCalc.getCalculatedCorpus();
        long successCount = Arrays.stream(finalValues)
            .filter(value -> value >= targetCorpus.doubleValue())
            .count();

        BigDecimal probabilityOfSuccess = BigDecimal.valueOf(successCount)
            .divide(BigDecimal.valueOf(iterations), 4, RoundingMode.HALF_UP)
            .multiply(BigDecimal.valueOf(100));

        // Save result
        return saveSimulationResult(goalId, iterations, worstCase, expectedCase, bestCase, probabilityOfSuccess);
    }

    private double simulateSinglePath(
        double initial,
        double monthly,
        int years,
        double expectedReturn,
        double volatility
    ) {
        double portfolio = initial;

        for (int month = 1; month <= years * 12; month++) {
            // Add monthly contribution
            portfolio += monthly;

            // Generate random return using normal distribution
            // Box-Muller transform for normal random numbers
            double u1 = random.nextDouble();
            double u2 = random.nextDouble();
            double z = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math.PI * u2);

            // Monthly return = annual return / 12 + random component
            double monthlyExpectedReturn = expectedReturn / 12;
            double monthlyVolatility = volatility / Math.sqrt(12);
            double monthlyReturn = monthlyExpectedReturn + z * monthlyVolatility;

            // Apply return to portfolio
            portfolio *= (1 + monthlyReturn);
        }

        return portfolio;
    }
}
```

**Decision Point:**
For MVP, I recommend **Option 1 (Simplified Projection)**, then upgrade to **Option 2 (Full Monte Carlo)** in Phase 2.

---

#### Module 10: Order Management

```java
// OrderController.java

// 1. Create draft order
POST /api/rm/goals/{goalId}/orders/draft
Response: OrderDto

// 2. Generate Excel/PDF document
POST /api/rm/orders/{orderId}/generate-document
Response: DocumentDto

// 3. Send MFA to client
POST /api/rm/orders/{orderId}/send-mfa
Request: SendMfaRequest
Response: MfaStatusDto

// 4. Verify MFA (by client)
POST /api/orders/{orderId}/verify-mfa
Request: VerifyMfaRequest
Response: MfaVerificationDto

// 5. Submit order (after MFA)
POST /api/rm/orders/{orderId}/submit
Response: OrderDto

// 6. Get order details
GET /api/rm/orders/{orderId}
Response: OrderDetailDto

// 7. Get all orders for customer
GET /api/rm/customers/{customerId}/orders
Response: List<OrderSummaryDto>
```

**DTOs:**

```java
public record OrderDto(
    Long id,
    String orderCode,
    Long goalId,
    String goalName,
    Long customerId,
    String customerName,
    String orderStatus,
    BigDecimal totalInvestmentAmount,
    String documentUrl,
    Boolean mfaRequired,
    LocalDateTime createdAt
) {}

public record SendMfaRequest(
    String mfaMethod, // OTP, EMAIL
    String contactDetail // Phone or email
) {}

public record VerifyMfaRequest(
    String otpCode
) {}

public record OrderDetailDto(
    OrderDto order,
    List<OrderLineItemDto> lineItems,
    List<OrderAuditLogDto> auditLog
) {}

public record OrderLineItemDto(
    String assetClassName,
    BigDecimal allocatedPercentage,
    BigDecimal investmentAmount
) {}
```

---

#### Module 11: Portfolio Configuration (Super Admin)

```java
// PortfolioAdminController.java

// 1. Get all portfolios
GET /api/admin/portfolios
Response: List<PortfolioSummaryDto>

// 2. Create new portfolio
POST /api/admin/portfolios
Request: CreatePortfolioRequest
Response: PortfolioDetailDto

// 3. Update portfolio
PUT /api/admin/portfolios/{portfolioId}
Request: UpdatePortfolioRequest
Response: PortfolioDetailDto

// 4. Manage asset classes
GET /api/admin/asset-classes
Response: List<AssetClassDto>

POST /api/admin/asset-classes
Request: CreateAssetClassRequest
Response: AssetClassDto

// 5. Configure portfolio allocations
PUT /api/admin/portfolios/{portfolioId}/allocations
Request: ConfigureAllocationsRequest
Response: PortfolioAllocationDto
```

---

### 4.3 API Security

```java
// JWT-based authentication (already exists)
// Role-based access control

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) {
        return http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/rm/**").hasRole("RM")
                .requestMatchers("/api/admin/**").hasRole("SUPER_ADMIN")
                .requestMatchers("/api/orders/*/verify-mfa").permitAll() // Client access
            )
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
            .build();
    }
}
```

---

## 5. Frontend Design

### 5.1 Technology Stack (Existing)

- Angular 19
- TypeScript 5.7
- Tailwind CSS v4
- Signals for state management
- SSR enabled

### 5.2 Application Structure

```
src/app/
├── core/                    # Singleton services, guards, interceptors
│   ├── auth/
│   ├── services/
│   ├── guards/
│   ├── interceptors/
│   └── models/
│
├── features/                # Feature modules
│   ├── rm-dashboard/
│   ├── customer-management/
│   ├── goal-management/
│   ├── risk-assessment/
│   ├── suitability-assessment/
│   ├── financial-calculator/
│   ├── portfolio-selection/
│   ├── order-management/
│   └── admin/
│       ├── questionnaire-config/
│       └── portfolio-config/
│
├── shared/                  # Reusable components
│   ├── components/
│   │   ├── data-table/
│   │   ├── stepper/
│   │   ├── progress-bar/
│   │   ├── chart/
│   │   └── modal/
│   ├── directives/
│   └── pipes/
│
└── layout/                  # Layout components
    ├── header/
    ├── sidebar/
    └── footer/
```

---

### 5.3 Key Screen Designs

#### Screen 1: RM Dashboard

**Route:** `/rm/dashboard`

**Components:**

- Customer list with search
- Recent goals
- Pending actions
- Statistics cards

**Signals:**

```typescript
export class RmDashboardComponent {
  private rmService = inject(RmDashboardService);

  // State
  protected readonly customers = signal<Customer[]>([]);
  protected readonly recentGoals = signal<Goal[]>([]);
  protected readonly stats = signal<DashboardStats | null>(null);
  protected readonly loading = signal(false);

  // Load data
  async ngOnInit() {
    this.loading.set(true);
    const data = await this.rmService.getDashboardData();
    this.customers.set(data.customers);
    this.recentGoals.set(data.recentGoals);
    this.stats.set(data.stats);
    this.loading.set(false);
  }
}
```

---

#### Screen 2: Customer Management

**Route:** `/rm/customers`

**Features:**

- List all customers
- Search & filter
- Create new customer
- View customer details

**Key Component:**

```typescript
export class CustomerListComponent {
  private customerService = inject(CustomerService);

  protected readonly customers = signal<Customer[]>([]);
  protected readonly searchQuery = signal("");
  protected readonly filteredCustomers = computed(() => {
    const query = this.searchQuery().toLowerCase();
    return this.customers().filter(
      (c) =>
        c.firstName.toLowerCase().includes(query) ||
        c.lastName.toLowerCase().includes(query) ||
        c.email.toLowerCase().includes(query)
    );
  });

  protected async createCustomer(data: CreateCustomerForm) {
    const customer = await this.customerService.create(data);
    this.customers.update((list) => [...list, customer]);
  }
}
```

---

#### Screen 3: Goal Creation Wizard (Multi-Step)

**Route:** `/rm/customers/{customerId}/goals/new`

**Stepper Flow:**

```
Step 1: Goal Details
Step 2: Risk Profile Questionnaire
Step 3: Risk Score Result
Step 4: Suitability Questionnaire
Step 5: Financial Calculator
Step 6: Portfolio Matching
Step 7: Strategy Selection
Step 8: Asset Allocation
Step 9: Monte Carlo Simulation
Step 10: Order Review
```

**Main Component:**

```typescript
export class GoalWizardComponent {
  private route = inject(ActivatedRoute);
  private goalService = inject(GoalService);

  // Route params
  protected readonly customerId = input.required<string>();

  // Wizard state
  protected readonly currentStep = signal(1);
  protected readonly totalSteps = 10;
  protected readonly goalId = signal<number | null>(null);

  // Step completion tracking
  protected readonly completedSteps = signal<number[]>([]);

  // Step data
  protected readonly goalData = signal<GoalFormData | null>(null);
  protected readonly riskScore = signal<RiskScoreResult | null>(null);
  protected readonly suitabilityResult = signal<SuitabilityResult | null>(null);
  protected readonly financialCalc = signal<FinancialCalculation | null>(null);

  // Navigation
  protected async nextStep() {
    // Save current step data
    await this.saveStepData(this.currentStep());

    // Mark as completed
    this.completedSteps.update((steps) => [...steps, this.currentStep()]);

    // Move to next
    this.currentStep.update((step) => step + 1);
  }

  protected previousStep() {
    this.currentStep.update((step) => step - 1);
  }

  protected async saveStepData(step: number) {
    // Save to backend with journey tracking
    await this.goalService.updateJourneyStep(this.goalId()!, step /* data */);
  }
}
```

---

#### Screen 4: Risk Profile Questionnaire

**Component Template:**

```html
<div class="questionnaire-container">
  <h2>Risk Profile Assessment</h2>

  <div class="progress-bar">
    <span
      >Question {{ currentQuestionIndex() + 1 }} of {{ totalQuestions() }}</span
    >
    <div class="progress" [style.width]="progress() + '%'"></div>
  </div>

  @for (question of questions(); track question.id; let i = $index) { @if (i ===
  currentQuestionIndex()) {
  <div class="question-card">
    <h3>{{ question.questionText }}</h3>
    @if (question.helpText) {
    <p class="help-text">{{ question.helpText }}</p>
    }

    <!-- Single Select -->
    @if (question.questionType === 'SINGLE_SELECT') {
    <div class="options">
      @for (option of question.options; track option.id) {
      <label class="option-card">
        <input
          type="radio"
          [name]="'question_' + question.id"
          [value]="option.id"
          (change)="selectOption(question.id, option.id)"
        />
        <span>{{ option.optionText }}</span>
      </label>
      }
    </div>
    }

    <!-- Multi Select -->
    @if (question.questionType === 'MULTI_SELECT') {
    <div class="options">
      @for (option of question.options; track option.id) {
      <label class="option-card">
        <input
          type="checkbox"
          [value]="option.id"
          (change)="toggleOption(question.id, option.id)"
        />
        <span>{{ option.optionText }}</span>
      </label>
      }
    </div>
    }

    <!-- Number Input -->
    @if (question.questionType === 'INPUT_NUMBER') {
    <input
      type="number"
      class="form-input"
      (input)="updateNumberInput(question.id, $event)"
      [min]="question.validationRules?.min"
      [max]="question.validationRules?.max"
    />
    }
  </div>
  } }

  <div class="navigation">
    <button
      (click)="previousQuestion()"
      [disabled]="currentQuestionIndex() === 0"
    >
      Previous
    </button>

    @if (currentQuestionIndex() < totalQuestions() - 1) {
    <button (click)="nextQuestion()">Next</button>
    } @else {
    <button (click)="submitQuestionnaire()">Submit</button>
    }
  </div>
</div>
```

**Component Logic:**

```typescript
export class RiskProfileQuestionnaireComponent {
  private riskProfileService = inject(RiskProfileService);

  // Input
  readonly goalId = input.required<number>();

  // State
  protected readonly questions = signal<Question[]>([]);
  protected readonly currentQuestionIndex = signal(0);
  protected readonly answers = signal<Map<number, Answer>>(new Map());
  protected readonly loading = signal(false);

  // Computed
  protected readonly totalQuestions = computed(() => this.questions().length);
  protected readonly progress = computed(
    () => ((this.currentQuestionIndex() + 1) / this.totalQuestions()) * 100
  );

  // Output
  readonly completed = output<RiskScoreResult>();

  async ngOnInit() {
    this.loading.set(true);
    const questions = await this.riskProfileService.getQuestions();
    this.questions.set(questions);
    this.loading.set(false);
  }

  protected selectOption(questionId: number, optionId: number) {
    this.answers.update((map) => {
      map.set(questionId, { selectedOptionIds: [optionId] });
      return new Map(map);
    });
  }

  protected toggleOption(questionId: number, optionId: number) {
    this.answers.update((map) => {
      const existing = map.get(questionId)?.selectedOptionIds || [];
      const updated = existing.includes(optionId)
        ? existing.filter((id) => id !== optionId)
        : [...existing, optionId];
      map.set(questionId, { selectedOptionIds: updated });
      return new Map(map);
    });
  }

  protected nextQuestion() {
    // Save current answer
    this.saveAnswer(this.currentQuestionIndex());
    this.currentQuestionIndex.update((i) => i + 1);
  }

  protected async submitQuestionnaire() {
    this.loading.set(true);

    // Submit all answers
    const result = await this.riskProfileService.submitAll(
      this.goalId(),
      Array.from(this.answers().entries()).map(([questionId, answer]) => ({
        questionId,
        ...answer,
      }))
    );

    this.loading.set(false);
    this.completed.emit(result);
  }

  private async saveAnswer(index: number) {
    const question = this.questions()[index];
    const answer = this.answers().get(question.id);

    if (answer) {
      await this.riskProfileService.saveAnswer(
        this.goalId(),
        question.id,
        answer
      );
    }
  }
}
```

---

#### Screen 5: Risk Score Result Display

**Component:**

```typescript
export class RiskScoreResultComponent {
  readonly riskScore = input.required<RiskScoreResult>();

  // Computed
  protected readonly categoryColor = computed(() => {
    const category = this.riskScore().categoryCode;
    const colors: Record<string, string> = {
      Secure: "bg-blue-500",
      Conservative: "bg-green-500",
      Income: "bg-yellow-500",
      Balance: "bg-orange-500",
      Aggressive: "bg-red-500",
      Speculative: "bg-purple-500",
    };
    return colors[category] || "bg-gray-500";
  });
}
```

**Template:**

```html
<div class="result-card">
  <h2>Your Risk Profile</h2>

  <div class="score-display">
    <div class="score-circle" [class]="categoryColor()">
      <span class="score-number">{{ riskScore().totalScore }}</span>
    </div>

    <div class="category-info">
      <h3>{{ riskScore().categoryName }}</h3>
      <p>{{ riskScore().description }}</p>
    </div>
  </div>

  <!-- Risk score scale visualization -->
  <div class="risk-scale">
    <div class="scale-bar">
      @for (category of categories; track category.code) {
      <div
        class="scale-segment"
        [style.width]="category.width + '%'"
        [class.active]="category.code === riskScore().categoryCode"
      >
        <span>{{ category.name }}</span>
      </div>
      }
    </div>
  </div>

  <button (click)="proceed.emit()">Continue to Suitability Assessment</button>
</div>
```

---

#### Screen 6: Financial Calculator

**Two-Step Component:**

**Step 1: Corpus Calculation**

```html
<div class="calculator-step">
  <h3>Step 1: Calculate Required Corpus</h3>

  <form [formGroup]="corpusForm">
    <div class="form-group">
      <label>Goal Amount (Today's Value)</label>
      <input
        type="number"
        formControlName="targetAmount"
        placeholder="₹10,00,000"
      />
    </div>

    <div class="form-group">
      <label>Time Horizon (Years)</label>
      <input type="number" formControlName="tenureYears" placeholder="10" />
    </div>

    <div class="form-group">
      <label>Expected Inflation Rate (%)</label>
      <input
        type="number"
        formControlName="inflationRate"
        placeholder="6"
        step="0.1"
      />
    </div>

    <button (click)="calculateCorpus()">Calculate</button>
  </form>

  @if (corpusResult()) {
  <div class="result-box">
    <h4>Required Corpus (Inflation Adjusted)</h4>
    <p class="amount">{{ corpusResult().calculatedCorpus | currency:'INR' }}</p>

    <div class="breakdown">
      <p>Today's Goal: {{ corpusResult().targetAmount | currency:'INR' }}</p>
      <p>
        After {{ corpusResult().tenureYears }} years at {{
        corpusResult().inflationRate }}% inflation
      </p>
    </div>
  </div>
  }
</div>
```

**Step 2: Investment Calculation**

```html
<div class="calculator-step">
  <h3>Step 2: Calculate Monthly Investment</h3>

  <form [formGroup]="investmentForm">
    <div class="form-group">
      <label>Initial Investment (Lump Sum)</label>
      <input
        type="number"
        formControlName="initialInvestment"
        placeholder="₹1,00,000"
      />
    </div>

    <div class="form-group">
      <label>Monthly SIP Amount</label>
      <input
        type="number"
        formControlName="monthlyInvestment"
        placeholder="₹10,000"
      />
    </div>

    <div class="form-group">
      <label>Investment Period (Years)</label>
      <input
        type="number"
        formControlName="tenureYears"
        [value]="corpusResult().tenureYears"
      />
    </div>

    <div class="form-group">
      <label>Expected Annual Return (%)</label>
      <input
        type="number"
        formControlName="assumedReturnRate"
        placeholder="12"
        step="0.1"
      />
    </div>

    <button (click)="calculateInvestment()">Calculate</button>
  </form>

  @if (investmentResult()) {
  <div class="result-box">
    <h4>Projected Future Value</h4>
    <p class="amount">
      {{ investmentResult().calculatedFutureValue | currency:'INR' }}
    </p>

    <div class="comparison">
      <div class="comparison-item">
        <span>Required Corpus</span>
        <span class="value"
          >{{ corpusResult().calculatedCorpus | currency:'INR' }}</span
        >
      </div>

      <div class="comparison-item">
        <span>Projected Value</span>
        <span class="value"
          >{{ investmentResult().calculatedFutureValue | currency:'INR' }}</span
        >
      </div>

      <div
        class="comparison-item"
        [class.surplus]="investmentResult().isGoalAchievable"
      >
        <span
          >{{ investmentResult().isGoalAchievable ? 'Surplus' : 'Shortfall'
          }}</span
        >
        <span class="value">
          {{ investmentResult().shortfallOrSurplus | currency:'INR' }}
        </span>
      </div>
    </div>

    @if (!investmentResult().isGoalAchievable) {
    <div class="warning">
      <p>⚠️ Your goal may not be achievable with current investment plan.</p>
      <p>Consider:</p>
      <ul>
        <li>Increasing monthly SIP amount</li>
        <li>Adding more initial investment</li>
        <li>Choosing a higher return portfolio (with higher risk)</li>
      </ul>
    </div>
    }
  </div>
  }
</div>
```

---

#### Screen 7: Portfolio Selection

**Component:**

```html
<div class="portfolio-selection">
  <h2>Recommended Investment Strategies</h2>

  <div class="matching-summary">
    <div class="summary-card">
      <h4>Your Risk Profile</h4>
      <p>
        {{ riskScore().categoryName }} (Score: {{ riskScore().totalScore }})
      </p>
    </div>

    <div class="summary-card">
      <h4>Suitability Level</h4>
      <p>
        {{ suitability().knowledgeLevel }} Knowledge, {{
        suitability().experienceLevel }} Experience
      </p>
    </div>

    <div class="summary-card">
      <h4>Required Return</h4>
      <p>{{ financialCalc().requiredReturnRate }}% p.a.</p>
    </div>
  </div>

  <div class="portfolios-grid">
    @for (portfolio of eligiblePortfolios(); track portfolio.portfolioId) {
    <div
      class="portfolio-card"
      [class.recommended]="portfolio.isRecommended"
      (click)="selectPortfolio(portfolio)"
    >
      @if (portfolio.isRecommended) {
      <span class="badge">Recommended</span>
      }

      <h3>{{ portfolio.portfolioName }}</h3>
      <p class="description">{{ portfolio.description }}</p>

      <div class="metrics">
        <div class="metric">
          <span class="label">Expected Return</span>
          <span class="value"
            >{{ portfolio.expectedReturnMin }}% - {{ portfolio.expectedReturnMax
            }}%</span
          >
        </div>

        <div class="metric">
          <span class="label">Match Score</span>
          <span class="value">{{ portfolio.eligibilityScore }}/100</span>
        </div>
      </div>

      <div class="allocation-preview">
        <h5>Asset Allocation</h5>
        @for (alloc of portfolio.allocations; track alloc.assetClassName) {
        <div class="allocation-bar">
          <span>{{ alloc.assetClassName }}</span>
          <div class="bar">
            <div
              class="fill"
              [style.width]="alloc.defaultPercentage + '%'"
            ></div>
          </div>
          <span>{{ alloc.defaultPercentage }}%</span>
        </div>
        }
      </div>

      <p class="match-reason">{{ portfolio.matchReason }}</p>
    </div>
    }
  </div>
</div>
```

---

#### Screen 8: Asset Allocation Table

**Component:**

```html
<div class="allocation-editor">
  <h2>Asset Allocation Distribution</h2>

  <div class="total-investment">
    <h3>Total Investment Amount</h3>
    <p class="amount">{{ totalAmount() | currency:'INR' }}</p>
  </div>

  <table class="allocation-table">
    <thead>
      <tr>
        <th>Asset Class</th>
        <th>Risk Level</th>
        <th>Expected Return</th>
        <th>Allocation %</th>
        <th>Amount (₹)</th>
      </tr>
    </thead>
    <tbody>
      @for (alloc of allocations(); track alloc.assetClassId) {
      <tr>
        <td>
          <div class="asset-info">
            <span class="asset-name">{{ alloc.assetClassName }}</span>
            <span class="asset-type">{{ alloc.assetClassCode }}</span>
          </div>
        </td>
        <td>
          <span
            class="risk-badge"
            [class]="'risk-' + alloc.riskLevel.toLowerCase()"
          >
            {{ alloc.riskLevel }}
          </span>
        </td>
        <td>{{ alloc.expectedReturn }}%</td>
        <td>
          <input
            type="number"
            [(ngModel)]="alloc.allocatedPercentage"
            (input)="recalculate()"
            min="0"
            max="100"
            step="0.1"
            class="percentage-input"
          />
        </td>
        <td>{{ alloc.allocatedAmount | currency:'INR' }}</td>
      </tr>
      }
    </tbody>
    <tfoot>
      <tr>
        <td colspan="3"><strong>Total</strong></td>
        <td>
          <strong [class.error]="totalPercentage() !== 100">
            {{ totalPercentage() }}%
          </strong>
        </td>
        <td><strong>{{ totalAmount() | currency:'INR' }}</strong></td>
      </tr>
    </tfoot>
  </table>

  @if (totalPercentage() !== 100) {
  <div class="error-message">
    ⚠️ Total allocation must equal 100%. Current: {{ totalPercentage() }}%
  </div>
  }

  <div class="allocation-chart">
    <!-- Pie chart visualization -->
    <canvas #chartCanvas></canvas>
  </div>

  <button (click)="finalizeAllocation()" [disabled]="totalPercentage() !== 100">
    Finalize Allocation
  </button>
</div>
```

---

#### Screen 9: Monte Carlo Simulation Results

**Component:**

```html
<div class="simulation-results">
  <h2>Investment Projection & Probability Analysis</h2>

  <div class="simulation-summary">
    <div class="outcome-card best">
      <h4>Best Case (95%)</h4>
      <p class="value">{{ simulation().bestCaseValue | currency:'INR' }}</p>
    </div>

    <div class="outcome-card expected">
      <h4>Expected (Median)</h4>
      <p class="value">{{ simulation().expectedValue | currency:'INR' }}</p>
    </div>

    <div class="outcome-card worst">
      <h4>Worst Case (5%)</h4>
      <p class="value">{{ simulation().worstCaseValue | currency:'INR' }}</p>
    </div>
  </div>

  <div class="probability-meter">
    <h3>Probability of Achieving Goal</h3>
    <div class="meter">
      <div
        class="fill"
        [style.width]="simulation().probabilityOfSuccess + '%'"
        [class.high]="simulation().probabilityOfSuccess >= 70"
        [class.medium]="simulation().probabilityOfSuccess >= 50 && simulation().probabilityOfSuccess < 70"
        [class.low]="simulation().probabilityOfSuccess < 50"
      ></div>
    </div>
    <p class="percentage">{{ simulation().probabilityOfSuccess }}%</p>
  </div>

  <div class="target-comparison">
    <p>
      Your Target Corpus: <strong>{{ targetCorpus() | currency:'INR' }}</strong>
    </p>
    <p>
      Expected Outcome:
      <strong>{{ simulation().expectedValue | currency:'INR' }}</strong>
    </p>
  </div>

  <!-- Line chart showing growth projection -->
  <div class="projection-chart">
    <h4>
      Portfolio Growth Projection ({{ simulation().timeHorizonYears }} Years)
    </h4>
    <canvas #projectionChart></canvas>
  </div>

  <!-- Distribution histogram -->
  <div class="distribution-chart">
    <h4>Outcome Distribution</h4>
    <canvas #distributionChart></canvas>
  </div>

  <div class="simulation-details">
    <p>Based on {{ simulation().numIterations | number }} simulations</p>
    <p>
      Initial Investment: {{ simulation().initialInvestment | currency:'INR' }}
    </p>
    <p>
      Monthly Contribution: {{ simulation().monthlyContribution | currency:'INR'
      }}
    </p>
  </div>

  <button (click)="proceedToOrder()">Proceed to Order</button>
</div>
```

---

#### Screen 10: Order Review & Submission

**Component:**

```html
<div class="order-review">
  <h2>Order Summary</h2>

  <div class="customer-info">
    <h3>Customer Details</h3>
    <p>{{ customer().firstName }} {{ customer().lastName }}</p>
    <p>{{ customer().email }} | {{ customer().phone }}</p>
  </div>

  <div class="goal-info">
    <h3>Goal Details</h3>
    <p>{{ goal().goalName }}</p>
    <p>Target: {{ financialCalc().calculatedCorpus | currency:'INR' }}</p>
    <p>Tenure: {{ financialCalc().tenureYears }} years</p>
  </div>

  <div class="investment-summary">
    <h3>Investment Plan</h3>
    <table>
      <tr>
        <td>Initial Investment:</td>
        <td>{{ financialCalc().initialInvestment | currency:'INR' }}</td>
      </tr>
      <tr>
        <td>Monthly SIP:</td>
        <td>{{ financialCalc().monthlyInvestment | currency:'INR' }}</td>
      </tr>
      <tr>
        <td>Total Investment:</td>
        <td><strong>{{ totalInvestment() | currency:'INR' }}</strong></td>
      </tr>
    </table>
  </div>

  <div class="portfolio-summary">
    <h3>Selected Strategy: {{ portfolio().portfolioName }}</h3>
    <table class="allocation-table-readonly">
      @for (alloc of allocations(); track alloc.assetClassId) {
      <tr>
        <td>{{ alloc.assetClassName }}</td>
        <td>{{ alloc.allocatedPercentage }}%</td>
        <td>{{ alloc.allocatedAmount | currency:'INR' }}</td>
      </tr>
      }
    </table>
  </div>

  <div class="documents">
    <h3>Investment Documents</h3>
    @if (documentUrl()) {
    <a [href]="documentUrl()" target="_blank" class="document-link">
      📄 Download Investment Proposal (Excel)
    </a>
    } @else {
    <button (click)="generateDocument()" [disabled]="generating()">
      {{ generating() ? 'Generating...' : 'Generate Document' }}
    </button>
    }
  </div>

  <div class="actions">
    <button (click)="sendToClient()" class="primary">
      Send to Client for Review & MFA
    </button>
  </div>
</div>
```

---

#### Screen 11: Client MFA & Order Confirmation

**Client-facing screen (accessed via secure link):**

```html
<div class="client-order-review">
  <h2>Investment Order Confirmation</h2>

  <div class="order-details">
    <!-- Same summary as above -->
  </div>

  @if (mfaStatus() === 'PENDING') {
  <div class="mfa-section">
    <h3>Verify Your Identity</h3>
    <p>An OTP has been sent to {{ maskedContact() }}</p>

    <form [formGroup]="mfaForm">
      <input
        type="text"
        formControlName="otpCode"
        placeholder="Enter 6-digit OTP"
        maxlength="6"
      />
      <button (click)="verifyMfa()">Verify & Confirm Order</button>
    </form>

    <button (click)="resendOtp()" class="link">Resend OTP</button>
  </div>
  } @if (mfaStatus() === 'VERIFIED') {
  <div class="success-message">
    ✅ Order confirmed successfully!
    <p>Your investment order has been placed.</p>
  </div>
  }
</div>
```

---

### 5.4 Shared Components

#### Stepper Component

```typescript
export class StepperComponent {
  readonly steps = input.required<StepConfig[]>();
  readonly currentStep = input.required<number>();
  readonly completedSteps = input.required<number[]>();

  readonly stepChange = output<number>();
}
```

#### Progress Bar Component

```typescript
export class ProgressBarComponent {
  readonly value = input.required<number>(); // 0-100
  readonly showLabel = input(true);
  readonly color = input<"primary" | "success" | "warning" | "danger">(
    "primary"
  );
}
```

#### Chart Component (Wrapper for Chart.js)

```typescript
export class ChartComponent {
  readonly type = input.required<"line" | "bar" | "pie" | "doughnut">();
  readonly data = input.required<ChartData>();
  readonly options = input<ChartOptions>();
}
```

---

### 5.5 Services Layer

```typescript
// Example: RiskProfileService
@Injectable({ providedIn: "root" })
export class RiskProfileService {
  private http = inject(HttpClient);
  private apiUrl = "/api/rm/goals";

  async getQuestions(): Promise<Question[]> {
    return firstValueFrom(
      this.http.get<Question[]>(`${this.apiUrl}/risk-profile/questions`)
    );
  }

  async saveAnswer(
    goalId: number,
    questionId: number,
    answer: Answer
  ): Promise<void> {
    await firstValueFrom(
      this.http.post(`${this.apiUrl}/${goalId}/risk-profile/answers`, {
        questionId,
        ...answer,
      })
    );
  }

  async submitAll(
    goalId: number,
    answers: AnswerSubmission[]
  ): Promise<RiskScoreResult> {
    return firstValueFrom(
      this.http.post<RiskScoreResult>(
        `${this.apiUrl}/${goalId}/risk-profile/submit`,
        { answers }
      )
    );
  }

  async getRiskScore(goalId: number): Promise<RiskScoreResult> {
    return firstValueFrom(
      this.http.get<RiskScoreResult>(`${this.apiUrl}/${goalId}/risk-score`)
    );
  }
}
```

---

## 6. Implementation Phases

### Phase 1: Foundation & Core Flows (Weeks 1-4)

**Goal:** Complete customer management, goal creation, risk assessment, and basic financial calculator.

**Tasks:**

1. ✅ Database schema creation & migration
2. ✅ Backend APIs for:
   - Customer CRUD
   - Goal CRUD
   - Risk Profile Questionnaire
   - Risk Score Calculation
   - Basic Suitability Assessment
   - Financial Calculator (corpus + investment)
3. ✅ Frontend:
   - RM Dashboard
   - Customer Management
   - Goal Wizard (Steps 1-5)
   - Risk Profile UI
   - Financial Calculator UI

**Deliverable:** RM can create customers, create goals, complete risk assessment, get risk score, and calculate financial requirements.

---

### Phase 2: Portfolio Matching & Selection (Weeks 5-6)

**Tasks:**

1. ✅ Super Admin portal for:
   - Asset class configuration
   - Portfolio template configuration
   - Allocation rules setup
2. ✅ Backend APIs for:
   - Portfolio matching engine
   - Suitability-based filtering
   - Portfolio selection
   - Allocation customization
3. ✅ Frontend:
   - Portfolio selection UI
   - Asset allocation table
   - Admin configuration screens

**Deliverable:** System can recommend portfolios based on risk + suitability + financial requirements. RM can select and customize allocation.

---

### Phase 3: Simulation & Order (Weeks 7-8)

**Tasks:**

1. ✅ Backend:
   - Simplified projection service (MVP)
   - Order management APIs
   - Document generation (Excel/PDF)
   - MFA implementation
2. ✅ Frontend:
   - Simulation results UI
   - Order review screen
   - Client MFA screen
   - Chart visualizations

**Deliverable:** End-to-end flow from goal creation to order placement with MFA.

---

### Phase 4: Admin Features & Configurability (Weeks 9-10)

**Tasks:**

1. ✅ Backend:
   - Questionnaire configuration APIs
   - Dynamic scoring engine
   - Question type handlers (all types)
2. ✅ Frontend:
   - Questionnaire builder for super admin
   - Drag-drop question ordering
   - Scoring configuration UI

**Deliverable:** Super admin can configure custom questionnaires for any bank.

---

### Phase 5: Advanced Features (Weeks 11-12)

**Tasks:**

1. ✅ Full Monte Carlo simulation engine
2. ✅ Advanced charting & visualizations
3. ✅ Analytics dashboard for RM
4. ✅ Reporting & exports
5. ✅ Integration with Avaloq (if applicable)

**Deliverable:** Production-ready system with all advanced features.

---

## 7. Open Questions & Clarifications

### Questions Needing Your Input:

1. **Risk Score Calculation:**

   - What's the exact formula/weighting for each question?
   - Are there different weights for different questions?

2. **Suitability Matching:**

   - Should suitability act as a filter or modifier?
   - What are the exact blocking rules?

3. **Financial Calculator Matching:**

   - If expected return < required return, what action?
   - Show warning, block portfolio, or suggest changes?

4. **Portfolio Configurability:**

   - Do you need version control for portfolio templates?
   - How to handle portfolio updates for existing goals?

5. **MFA Implementation:**

   - OTP provider? (Twilio, AWS SNS, custom?)
   - Email provider? (SendGrid, AWS SES, custom?)

6. **Monte Carlo Simulation:**

   - Start with simplified projection (Phase 1)?
   - Or build full Monte Carlo from start?

7. **Order Execution:**

   - Integration with which trading system?
   - API specifications?

8. **Client Portal:**
   - Do clients have their own login?
   - Or access via secure links only?

---

## Sources

All research conducted using web searches:

**Risk Profile:**

- [RBC Client Risk Profile Questionnaire](https://ca.rbcwealthmanagement.com/documents/54275/54295/3.pdf/cd17c4ad-23a4-4767-8ada-781cbf50595d)
- [Risk Profiling with Bank Data: 2025 Guide](https://blog.finexer.com/risk-profiling-bank-data/)
- [CFA Institute Investment Risk Profiling Guide](https://rpc.cfainstitute.org/sites/default/files/-/media/documents/survey/investment-risk-profiling.pdf)

**Suitability:**

- [ESMA MiFID II Suitability Guidelines](https://www.esma.europa.eu/publications-and-data/interactive-single-rulebook/mifid-ii/article-25-assessment-suitability-and)
- [CFA Standard III(C) Suitability](https://www.cfainstitute.org/standards/professionals/code-ethics-standards/standards-of-practice-iii-c)

**Risk Score Calculation:**

- [MetricStream Risk Scores](https://www.metricstream.com/learn/risk-scores-for-better-risk-mgmt.html)
- [Horizon Investments Portfolio Risk Assessment](https://www.horizoninvestments.com/how-to-calculate-portfolio-risk-essential-guide-to-investment-risk-assessment/)

**Modern Portfolio Theory:**

- [Wikipedia: Modern Portfolio Theory](https://en.wikipedia.org/wiki/Modern_portfolio_theory)
- [CIBC 2025 Asset Allocation](https://www.cibc.com/content/dam/cibc-public-assets/asset-management/pdfs/2025-long-term-strategic-asset-allocation-en.pdf)
- [State Street Global Market Portfolio 2025](https://www.ssga.com/library-content/assets/pdf/global/gmp/global-market-portfolio-2025.pdf)

**Asset Allocation:**

- [Vanguard Model Portfolio Allocation](https://investor.vanguard.com/investor-resources-education/education/model-portfolio-allocation)
- [Trustnet Asset Allocation Models](https://www.trustnet.com/investing/13426105/cautious-balanced-and-aggressive-asset-allocation-models)

**Monte Carlo Simulation:**

- [Portfolio Visualizer Monte Carlo](https://www.portfoliovisualizer.com/monte-carlo-simulation)
- [InvestGlass Monte Carlo Guide](https://www.investglass.com/mastering-monte-carlo-simulation-portfolio-optimization-for-smarter-investments/)

**Financial Calculations:**

- [NISM Corpus Calculator](https://www.nism.ac.in/NISM%20Financial%20Calculators/Corpus-Making/index.html)
- [Calculator Soup Future Value](https://www.calculatorsoup.com/calculators/financial/future-value-calculator.php)
- [Excel Demy Inflation Calculation](https://www.exceldemy.com/how-to-calculate-future-value-with-inflation-in-excel/)

---

**Next Step:** Please review this plan and provide answers to the open questions so we can proceed with implementation.
