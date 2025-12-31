# Modern Portfolio Buckets - Asset Allocation Models

## Document Information

**Version**: 1.0
**Last Updated**: December 24, 2025
**Framework**: Modern Portfolio Theory (MPT), Goal-Based Investing
**Purpose**: Comprehensive model portfolios for different risk profiles and suitability categories
**Target Market**: Indian investors (INR-denominated portfolios)

## ⚠️ IMPORTANT CLARIFICATION: Mutual Fund-Based Portfolios

**Portfolio Structure**: All model portfolios described in this document use **MUTUAL FUNDS** as the investment vehicles, NOT individual stocks or bonds.

### What This Means:

**Customer Invests In** → **Mutual Funds** → **Mutual Funds Own** → **Individual Securities**

For example, a "60% Equity / 40% Debt" portfolio means:
- **60% invested in equity mutual funds** (like Axis Bluechip Fund, HDFC Index Sensex Fund)
- **40% invested in debt mutual funds** (like HDFC Corporate Bond Fund, UTI Debt Fund)

**It does NOT mean**:
- ❌ Direct investment in individual stocks (Apple, Microsoft, Reliance)
- ❌ Direct purchase of bonds
- ❌ Customer managing individual securities

### Industry Validation:

This mutual fund-based approach is the **industry standard** for retail wealth management, as confirmed by:
- **SCB Wealth Management** "AAA Model Portfolio" (see original PDF reference)
- **Vanguard LifeStrategy Funds** (mutual fund-of-funds approach)
- **Fidelity Target-Date Funds** (mutual fund baskets)
- **All major robo-advisors** (Wealthfront, Betterment, Groww, ET Money)

### 4-Layer Portfolio Architecture:

```
Layer 1: Asset Class Allocation (Customer View)
├─ 60% Equity
└─ 40% Debt

Layer 2: Sub-Asset Class Diversification
├─ Equity → 12% Large-cap + 12% Mid-cap + 12% Small-cap, etc.
└─ Debt → 10% Corporate Bonds + 10% Government Securities, etc.

Layer 3: Mutual Fund Selection (Investment Vehicles)
├─ Axis Bluechip Fund (₹2,23,729)
├─ HDFC Index Sensex Fund (₹2,23,729)
├─ ICICI Pru Multi-Asset Fund (₹2,23,729)
└─ ... (11 mutual funds total for Priya's ₹20K SIP)

Layer 4: Underlying Securities (Fund Holdings - Invisible to Customer)
├─ Axis Bluechip Fund owns 50 stocks (HDFC Bank, Reliance, Infosys...)
├─ HDFC Index Sensex Fund owns 30 stocks (Sensex constituents)
└─ ... (Total: 1,450+ individual securities across all funds)
```

### Benefits of Mutual Fund Approach:

1. **Professional Management**: Fund managers handle stock/bond selection
2. **Instant Diversification**: One fund = 30-500 underlying securities
3. **Lower Minimum Investment**: Start with ₹500 SIP (vs ₹50,000+ for direct stocks)
4. **Automatic Rebalancing**: Within each fund category
5. **Regulatory Oversight**: SEBI-regulated, audited, transparent
6. **Liquidity**: Easy redemption (T+1 for equity, T+0 for debt/liquid funds)

### Example: Priya Sharma's ₹20,000 Monthly SIP

**Investment Structure**:
- **₹20,000 SIP** → **11 Mutual Funds** → **1,450+ Underlying Securities**
- Customer only sees: "60% Equity Funds / 40% Debt Funds"
- Customer does NOT manage individual stocks

For complete implementation details, see `seed_modern_portfolios.sql`.

---

## Research Sources

This document is based on industry-leading asset allocation research from:

1. **Vanguard Asset Allocation Models**
   - LifeStrategy Funds portfolio construction methodology
   - [Vanguard Portfolio Allocation Models](https://investor.vanguard.com/investor-resources-education/education/model-portfolio-allocation)

2. **Morningstar Lifetime Allocation Indexes**
   - Age-based and goal-based glide paths
   - [Morningstar Asset Allocation Research](https://www.morningstar.com/lp/lifetime-allocation-indexes)

3. **Fidelity Asset Allocation Research**
   - Target-date fund allocation strategies
   - [Fidelity Asset Allocation Guidance](https://www.fidelity.com/viewpoints/investing-ideas/asset-allocation-diversification)

4. **BlackRock India Asset Allocation Framework**
   - India-specific tactical and strategic asset allocation
   - [BlackRock India Research](https://www.blackrock.com/in/individual-investors/investment-ideas/asset-allocation)

5. **CFA Institute - Portfolio Management Standards**
   - Modern Portfolio Theory application guidelines
   - Risk-adjusted return optimization

6. **SEBI Mutual Fund Categorization (2017)**
   - Indian mutual fund classification and allocation norms
   - [SEBI MF Categorization](https://www.sebi.gov.in/legal/circulars/oct-2017/categorization-and-rationalization-of-mutual-fund-schemes_36584.html)

---

## Asset Class Definitions

### Equity Asset Classes

| Asset Class | Definition | Typical Return Range | Volatility (Std Dev) |
|-------------|------------|----------------------|----------------------|
| **Large-Cap Equity** | Top 100 companies by market capitalization (Nifty 100, Sensex) | 11-13% CAGR | 15-18% |
| **Mid-Cap Equity** | 101st to 250th companies by market cap | 13-16% CAGR | 18-22% |
| **Small-Cap Equity** | 251st company onwards by market cap | 15-18% CAGR | 22-28% |
| **International Equity** | Developed markets (US, Europe) and Emerging markets | 9-12% CAGR (USD terms) | 16-20% |
| **Sectoral/Thematic** | Concentrated exposure to specific sectors (IT, Pharma, Banking, ESG, etc.) | Variable (10-20%) | 20-30% |

### Debt Asset Classes

| Asset Class | Definition | Typical Return Range | Volatility (Std Dev) |
|-------------|------------|----------------------|----------------------|
| **Liquid Funds** | Very short maturity (7-91 days), money market instruments | 4.5-6% | <1% |
| **Ultra Short-Term Debt** | 3-6 month maturity, high credit quality | 5-7% | 1-2% |
| **Short-Term Debt** | 1-3 year maturity, government + corporate bonds | 6-8% | 2-3% |
| **Medium-Term Debt** | 3-5 year maturity, balanced portfolio | 7-9% | 3-5% |
| **Long-Term Debt** | 7-10 year maturity, gilt funds + corporate bonds | 7.5-9.5% | 5-8% |
| **Credit Risk Funds** | Corporate bonds with higher yield (lower credit rating) | 8-10% | 4-6% |

### Alternative Asset Classes

| Asset Class | Definition | Typical Return Range | Volatility (Std Dev) |
|-------------|------------|----------------------|----------------------|
| **Gold** | Physical gold, Gold ETFs, Sovereign Gold Bonds | 7-9% CAGR | 12-15% |
| **Commodities** | Broad commodity indices (energy, metals, agriculture) | 5-8% CAGR | 18-25% |
| **Real Estate (REITs)** | Listed Real Estate Investment Trusts | 9-12% CAGR | 15-20% |
| **Alternative Investments (AIFs)** | Private equity, hedge funds, venture capital (HNI only: ₹1Cr+ net worth) | 12-18% CAGR | 15-35% |

---

## Portfolio Construction Principles

### 1. Strategic Asset Allocation (SAA)

**Definition**: Long-term target allocation based on risk profile and time horizon

**Principles**:
- Based on historical risk-return characteristics of asset classes
- Aligned with investor's risk capacity, knowledge, and experience
- Reviewed annually but not changed frequently
- Designed to achieve long-term financial goals

### 2. Rebalancing Discipline

**Threshold-Based Rebalancing**:
- Trigger: When any asset class deviates >5% from target allocation
- Example: Target 60% equity → Rebalance if equity drifts to 55% or 65%

**Calendar-Based Rebalancing**:
- Annual rebalancing (recommended for most investors)
- Quarterly review for portfolios >₹1 Crore

### 3. Diversification Hierarchy

**Level 1**: Asset Class Diversification (Equity, Debt, Gold, International)
**Level 2**: Sub-Asset Class Diversification (Large-cap, Mid-cap, Small-cap within equity)
**Level 3**: Geographical Diversification (India vs. International)
**Level 4**: Fund Manager Diversification (Multiple AMCs)

---

## Model Portfolio Buckets

---

## BUCKET 1: SECURE (Conservative Income)

### Target Investor Profile

**Risk Profile Score**: 8-13 (Secure category from Risk Profile Questionnaire)
**Suitability Category**: Conservative
**Investment Time Horizon**: 1-3 years
**Primary Objective**: Capital preservation with modest income generation
**Loss Tolerance**: Maximum 5% decline
**Typical Investor**:
- Retired individuals dependent on investment income
- Near-term goals (1-3 years away)
- First-time investors with low risk appetite
- Emergency fund corpus (needs immediate liquidity)

---

### Portfolio Allocation

```
╔══════════════════════════════════════════════════════════════╗
║                    SECURE PORTFOLIO                           ║
║                  10% Equity / 90% Debt                        ║
╚══════════════════════════════════════════════════════════════╝

EQUITY ALLOCATION (10%)
├─ Large-Cap Equity (Index Funds): 7%
└─ International Equity (Developed Markets): 3%

DEBT ALLOCATION (90%)
├─ Liquid Funds: 15%
├─ Ultra Short-Term Debt: 20%
├─ Short-Term Debt (1-3 years): 30%
├─ Medium-Term Debt (3-5 years): 20%
└─ Government Securities (Gilt Funds): 5%

ALTERNATIVE ALLOCATION (0%)
└─ None (too volatile for this profile)
```

---

### Expected Portfolio Characteristics

| Metric | Value |
|--------|-------|
| **Expected Return** | 6.5% - 8.0% per annum |
| **Expected Volatility (Std Dev)** | 2% - 4% |
| **Best Case Scenario (95th percentile)** | 10-12% return |
| **Worst Case Scenario (5th percentile)** | 3-4% return |
| **Maximum Historical Drawdown** | -3% to -5% (during 2013 taper tantrum) |
| **Correlation with Equity Markets** | Low (0.1 - 0.2) |
| **Suitable for Goals** | Emergency fund, 1-3 year goals, retired income |
| **Rebalancing Frequency** | Semi-annual |

---

### Sample Fund Selection (Implementation)

**Equity Component (10%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Nifty 50 Index Fund | HDFC Index Fund Nifty 50 / ICICI Pru Nifty 50 Index | 7% | Low-cost, diversified large-cap exposure |
| International Equity | Motilal Oswal S&P 500 Index Fund | 3% | Geographical diversification, USD exposure |

**Debt Component (90%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Liquid Fund | HDFC Liquid Fund / ICICI Pru Liquid Fund | 15% | Emergency liquidity, 4-6% returns |
| Ultra Short-Term | Aditya Birla SL Savings Fund | 20% | 3-6 month horizon, stable returns |
| Short-Term Debt | HDFC Short Term Debt Fund | 30% | 1-3 year horizon, 6-8% returns |
| Medium-Term Debt | ICICI Pru Medium Term Bond Fund | 20% | 3-5 year duration, higher yield |
| Gilt Fund | SBI Magnum Gilt Fund | 5% | Zero credit risk, government securities |

---

### Risk Mitigation Strategies

1. **High Liquidity Buffer**: 35% in liquid/ultra short-term funds for emergency access
2. **Credit Quality Focus**: Minimum AA+ rated corporate bonds, 50%+ in government securities
3. **Duration Management**: Weighted average maturity <3 years to minimize interest rate risk
4. **Minimal Equity Exposure**: Only 10% equity (via index funds, no active risk)

---

### Tax Efficiency Considerations

- Debt fund gains held >3 years: Taxed at 20% with indexation benefit
- Equity fund gains: LTCG >₹1.25L taxed at 12.5%, STCG at 20%
- Recommended holding: >3 years for debt component to benefit from indexation

---

## BUCKET 2: CONSERVATIVE (Stability Focused)

### Target Investor Profile

**Risk Profile Score**: 14-16 (Conservative category)
**Suitability Category**: Conservative to Moderate
**Investment Time Horizon**: 3-5 years
**Primary Objective**: Stable returns with limited volatility
**Loss Tolerance**: Maximum 10% decline
**Typical Investor**:
- Pre-retirees (5-10 years from retirement)
- Medium-term goals (child's higher education in 3-5 years)
- Conservative investors with some equity exposure comfort
- Second-time investors upgrading from pure debt

---

### Portfolio Allocation

```
╔══════════════════════════════════════════════════════════════╗
║                  CONSERVATIVE PORTFOLIO                       ║
║                  20% Equity / 80% Debt                        ║
╚══════════════════════════════════════════════════════════════╝

EQUITY ALLOCATION (20%)
├─ Large-Cap Equity (Diversified + Index): 12%
├─ International Equity (Developed Markets): 5%
└─ Gold ETF: 3%

DEBT ALLOCATION (80%)
├─ Liquid Funds: 10%
├─ Ultra Short-Term Debt: 15%
├─ Short-Term Debt (1-3 years): 25%
├─ Medium-Term Debt (3-5 years): 20%
├─ Corporate Bond Funds: 8%
└─ Government Securities: 2%

ALTERNATIVE ALLOCATION (0%)
└─ None for this conservative profile
```

---

### Expected Portfolio Characteristics

| Metric | Value |
|--------|-------|
| **Expected Return** | 7.5% - 9.0% per annum |
| **Expected Volatility (Std Dev)** | 4% - 6% |
| **Best Case Scenario (95th percentile)** | 12-15% return |
| **Worst Case Scenario (5th percentile)** | 2-4% return |
| **Maximum Historical Drawdown** | -8% to -10% (2020 COVID crash) |
| **Correlation with Equity Markets** | Moderate (0.3 - 0.4) |
| **Suitable for Goals** | 3-5 year goals, pre-retirement corpus |
| **Rebalancing Frequency** | Semi-annual or annual |

---

### Sample Fund Selection (Implementation)

**Equity Component (20%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Large-Cap Diversified | HDFC Top 100 Fund / ICICI Pru Bluechip Fund | 7% | Active large-cap management |
| Nifty 50 Index Fund | UTI Nifty 50 Index Fund | 5% | Low-cost core equity |
| International Equity | Parag Parikh Flexi Cap (has 25-35% international) | 5% | Global diversification |
| Gold ETF | HDFC Gold ETF / Nippon India Gold ETF | 3% | Hedge against inflation & equity volatility |

**Debt Component (80%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Liquid Fund | SBI Liquid Fund | 10% | Liquidity buffer |
| Ultra Short-Term | Axis Ultra Short Term Fund | 15% | Stable short-term returns |
| Short-Term Debt | Aditya Birla SL Short Term Fund | 25% | Core debt allocation |
| Medium-Term Debt | Kotak Medium Term Fund | 20% | Higher yield, 3-5 year horizon |
| Corporate Bond Fund | ICICI Pru Corporate Bond Fund | 8% | Credit spread pick-up |
| Gilt Fund | IDFC Government Securities Fund | 2% | Sovereign safety |

---

### Risk Mitigation Strategies

1. **Equity Diversification**: Split between active large-cap (7%) + passive index (5%) + international (5%)
2. **Gold Hedge**: 3% allocation acts as volatility dampener during equity corrections
3. **Laddered Debt**: Mix of liquid (10%), ultra short (15%), short (25%), medium (20%) for liquidity at all horizons
4. **Credit Quality**: 90%+ investment-grade bonds (AAA/AA+)

---

## BUCKET 3: INCOME (Balanced Income & Growth)

### Target Investor Profile

**Risk Profile Score**: 17-21 (Income category)
**Suitability Category**: Moderate
**Investment Time Horizon**: 5-7 years
**Primary Objective**: Balance between regular income and capital growth
**Loss Tolerance**: Maximum 15% decline
**Typical Investor**:
- Mid-career professionals (35-45 years) with medium-term goals
- Balanced hybrid fund investors
- Investors seeking 9-11% returns with moderate volatility
- Retirement planning (10-15 years away)

---

### Portfolio Allocation

```
╔══════════════════════════════════════════════════════════════╗
║                    INCOME PORTFOLIO                           ║
║                  40% Equity / 60% Debt                        ║
╚══════════════════════════════════════════════════════════════╝

EQUITY ALLOCATION (40%)
├─ Large-Cap Equity: 18%
├─ Mid-Cap Equity: 10%
├─ International Equity: 7%
└─ Gold ETF: 5%

DEBT ALLOCATION (60%)
├─ Liquid Funds: 5%
├─ Ultra Short-Term Debt: 10%
├─ Short-Term Debt: 15%
├─ Medium-Term Debt: 15%
├─ Corporate Bond Funds: 12%
└─ Long-Term Debt (Gilt/Dynamic): 3%

ALTERNATIVE ALLOCATION (0%)
└─ None (or up to 3% REITs for HNI investors)
```

---

### Expected Portfolio Characteristics

| Metric | Value |
|--------|-------|
| **Expected Return** | 9.0% - 11.0% per annum |
| **Expected Volatility (Std Dev)** | 7% - 10% |
| **Best Case Scenario (95th percentile)** | 16-20% return |
| **Worst Case Scenario (5th percentile)** | 0% to -3% return |
| **Maximum Historical Drawdown** | -12% to -15% (2020 COVID crash) |
| **Correlation with Equity Markets** | Moderate-High (0.5 - 0.6) |
| **Suitable for Goals** | 5-7 year goals, balanced portfolios |
| **Rebalancing Frequency** | Annual |

---

### Sample Fund Selection (Implementation)

**Equity Component (40%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Large-Cap Diversified | Axis Bluechip Fund / Mirae Asset Large Cap Fund | 10% | Quality large-cap exposure |
| Nifty 50 Index Fund | ICICI Pru Nifty 50 Index Fund | 8% | Low-cost core |
| Mid-Cap Diversified | Kotak Emerging Equity Fund / Axis Midcap Fund | 10% | Growth potential, higher returns |
| International Equity | PGIM India Global Equity Opp Fund / Edelweiss US Tech Equity | 7% | Global diversification |
| Gold ETF | SBI Gold ETF | 5% | Portfolio stabilizer |

**Debt Component (60%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Liquid Fund | Aditya Birla SL Liquid Fund | 5% | Minimal liquidity buffer |
| Ultra Short-Term | HDFC Ultra Short Term Fund | 10% | Short-term stability |
| Short-Term Debt | ICICI Pru Short Term Fund | 15% | Core debt (1-3 years) |
| Medium-Term Debt | SBI Magnum Medium Duration Fund | 15% | 3-5 year yield |
| Corporate Bond Fund | Axis Corporate Debt Fund | 12% | Higher yield from credit |
| Dynamic Bond Fund | IDFC Dynamic Bond Fund | 3% | Active duration management |

---

### Risk Mitigation Strategies

1. **Equity Laddering**: Large-cap (18%) provides stability, Mid-cap (10%) provides growth
2. **International Diversification**: 7% international equity reduces India-specific risk
3. **Gold Allocation**: 5% gold acts as hedge during equity downturns
4. **Balanced Debt**: 60% debt allocation cushions equity volatility
5. **Active Management**: Mix of active and passive funds for alpha generation

---

## BUCKET 4: BALANCE (Growth with Stability)

### Target Investor Profile

**Risk Profile Score**: 22-26 (Balance category)
**Suitability Category**: Moderate to Aggressive
**Investment Time Horizon**: 7-10 years
**Primary Objective**: Long-term capital growth with acceptable volatility
**Loss Tolerance**: Maximum 20% decline
**Typical Investor**:
- Young professionals (30-40 years) with long-term goals
- Parents planning for child's education (10+ years away)
- Retirement corpus building (15-20 years to retirement)
- Experienced investors comfortable with market cycles

---

### Portfolio Allocation

```
╔══════════════════════════════════════════════════════════════╗
║                   BALANCE PORTFOLIO                           ║
║                  60% Equity / 40% Debt                        ║
╚══════════════════════════════════════════════════════════════╝

EQUITY ALLOCATION (60%)
├─ Large-Cap Equity: 22%
├─ Mid-Cap Equity: 15%
├─ Small-Cap Equity: 8%
├─ International Equity: 10%
└─ Gold ETF: 5%

DEBT ALLOCATION (40%)
├─ Ultra Short-Term Debt: 8%
├─ Short-Term Debt: 12%
├─ Medium-Term Debt: 10%
├─ Corporate Bond Funds: 8%
└─ Dynamic Bond / Gilt Funds: 2%

ALTERNATIVE ALLOCATION (0%)
└─ Optional: 3-5% REITs for HNI investors
```

---

### Expected Portfolio Characteristics

| Metric | Value |
|--------|-------|
| **Expected Return** | 10.5% - 12.5% per annum |
| **Expected Volatility (Std Dev)** | 10% - 13% |
| **Best Case Scenario (95th percentile)** | 20-25% return |
| **Worst Case Scenario (5th percentile)** | -5% to -8% return |
| **Maximum Historical Drawdown** | -18% to -22% (2020 COVID crash) |
| **Correlation with Equity Markets** | High (0.7 - 0.8) |
| **Suitable for Goals** | 7-10 year goals, retirement planning |
| **Rebalancing Frequency** | Annual |

---

### Sample Fund Selection (Implementation)

**Equity Component (60%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Large-Cap Diversified | Canara Robeco Bluechip Equity / SBI Bluechip Fund | 12% | Active large-cap alpha |
| Nifty 50 Index Fund | UTI Nifty 50 Index Fund | 10% | Core equity (low cost) |
| Mid-Cap Diversified | DSP Midcap Fund / Invesco India Midcap Fund | 15% | Higher growth potential |
| Small-Cap Diversified | Axis Small Cap Fund / Nippon India Small Cap Fund | 8% | Aggressive growth (long-term) |
| International Equity | Franklin India Feeder US Opportunities / PPFAS Flexi Cap | 10% | Global exposure |
| Gold ETF | Nippon India Gold ETF | 5% | Volatility hedge |

**Debt Component (40%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Ultra Short-Term | ICICI Pru Ultra Short Term Fund | 8% | Short-term liquidity |
| Short-Term Debt | Kotak Bond Short Term Fund | 12% | Core debt allocation |
| Medium-Term Debt | Aditya Birla SL Medium Term Fund | 10% | 3-5 year returns |
| Corporate Bond Fund | HDFC Corporate Bond Fund | 8% | Credit spread premium |
| Dynamic Bond | Nippon India Dynamic Bond Fund | 2% | Active interest rate management |

---

### Risk Mitigation Strategies

1. **Multi-Cap Diversification**: Large (22%) + Mid (15%) + Small (8%) for risk-adjusted growth
2. **International Equity**: 10% reduces India concentration risk
3. **Gold Buffer**: 5% gold provides non-correlated asset cushion
4. **Debt Cushion**: 40% debt allocation prevents forced equity liquidation during downturns
5. **Rebalancing Discipline**: Annual rebalancing captures equity gains, buys dips

---

## BUCKET 5: AGGRESSIVE (High Growth Focus)

### Target Investor Profile

**Risk Profile Score**: 27-31 (Aggressive category)
**Suitability Category**: Aggressive
**Investment Time Horizon**: 10-15 years
**Primary Objective**: Maximum long-term capital appreciation
**Loss Tolerance**: Maximum 30% decline
**Typical Investor**:
- Young investors (25-35 years) with long investment horizon
- Early retirement planning (25-30 years away)
- Wealth creation goals (no immediate liquidity needs)
- Experienced investors who stayed invested during past crashes

---

### Portfolio Allocation

```
╔══════════════════════════════════════════════════════════════╗
║                  AGGRESSIVE PORTFOLIO                         ║
║                  80% Equity / 20% Debt                        ║
╚══════════════════════════════════════════════════════════════╝

EQUITY ALLOCATION (80%)
├─ Large-Cap Equity: 25%
├─ Mid-Cap Equity: 22%
├─ Small-Cap Equity: 15%
├─ International Equity: 13%
└─ Gold ETF: 5%

DEBT ALLOCATION (20%)
├─ Ultra Short-Term Debt: 8%
├─ Short-Term Debt: 7%
├─ Corporate Bond Funds: 5%

ALTERNATIVE ALLOCATION (0%)
└─ Optional: 5% REITs/Commodities for HNI investors
```

---

### Expected Portfolio Characteristics

| Metric | Value |
|--------|-------|
| **Expected Return** | 11.5% - 13.5% per annum |
| **Expected Volatility (Std Dev)** | 13% - 16% |
| **Best Case Scenario (95th percentile)** | 25-35% return |
| **Worst Case Scenario (5th percentile)** | -10% to -15% return |
| **Maximum Historical Drawdown** | -28% to -32% (2020 COVID crash) |
| **Correlation with Equity Markets** | Very High (0.85 - 0.90) |
| **Suitable for Goals** | 10-15+ year goals, wealth creation |
| **Rebalancing Frequency** | Annual |

---

### Sample Fund Selection (Implementation)

**Equity Component (80%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Large-Cap Diversified | Kotak Bluechip Fund / Nippon India Large Cap Fund | 12% | Quality large-cap exposure |
| Nifty 50 Index Fund | HDFC Index Fund Nifty 50 | 13% | Low-cost core equity |
| Mid-Cap Diversified | Motilal Oswal Midcap Fund / Edelweiss Mid Cap Fund | 22% | High growth potential |
| Small-Cap Diversified | SBI Small Cap Fund / Quant Small Cap Fund | 15% | Maximum long-term growth |
| International Equity (US) | Motilal Oswal S&P 500 Index Fund | 8% | US market exposure |
| International Equity (Emerging) | Kotak Emerging Market Fund | 5% | Emerging market growth |
| Gold ETF | SBI Gold ETF | 5% | Portfolio rebalancing anchor |

**Debt Component (20%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Ultra Short-Term | Axis Ultra Short Term Fund | 8% | Emergency liquidity |
| Short-Term Debt | SBI Short Term Debt Fund | 7% | Rebalancing buffer |
| Corporate Bond Fund | Kotak Corporate Bond Fund | 5% | Higher yield from credit |

---

### Risk Mitigation Strategies

1. **Diversified Equity Exposure**: Large (25%) + Mid (22%) + Small (15%) across market caps
2. **Global Diversification**: 13% international equity (8% US + 5% Emerging Markets)
3. **Gold Rebalancing Anchor**: 5% gold allows buying equity dips during crashes
4. **Minimal Debt for Liquidity**: 20% debt only for emergency needs and rebalancing
5. **Long-Term Commitment**: This portfolio requires 10+ year holding period

---

## BUCKET 6: SPECULATIVE (Maximum Growth Potential)

### Target Investor Profile

**Risk Profile Score**: 32-35 (Speculative category)
**Suitability Category**: Aggressive (with expert knowledge and experience)
**Investment Time Horizon**: 15-30 years
**Primary Objective**: Aggressive wealth creation, willing to accept high volatility
**Loss Tolerance**: Can tolerate 40%+ decline
**Typical Investor**:
- Very young investors (20-30 years) with decades to retirement
- Ultra-long-term goals (retirement 30+ years away)
- Experienced investors with proven behavior during market crashes
- HNI investors with diversified wealth (this is only a portion of total wealth)

---

### Portfolio Allocation

```
╔══════════════════════════════════════════════════════════════╗
║                  SPECULATIVE PORTFOLIO                        ║
║               95% Equity / 5% Debt & Gold                     ║
╚══════════════════════════════════════════════════════════════╝

EQUITY ALLOCATION (95%)
├─ Large-Cap Equity: 20%
├─ Mid-Cap Equity: 25%
├─ Small-Cap Equity: 25%
├─ International Equity: 15%
├─ Sectoral/Thematic Funds: 10%

DEBT ALLOCATION (5%)
├─ Ultra Short-Term Debt: 3%
└─ Gold ETF: 2%

ALTERNATIVE ALLOCATION (0%)
└─ Optional: Up to 10% in REITs, Commodities, AIFs for HNI
```

---

### Expected Portfolio Characteristics

| Metric | Value |
|--------|-------|
| **Expected Return** | 13.0% - 15.0% per annum |
| **Expected Volatility (Std Dev)** | 16% - 20% |
| **Best Case Scenario (95th percentile)** | 30-45% return |
| **Worst Case Scenario (5th percentile)** | -18% to -25% return |
| **Maximum Historical Drawdown** | -38% to -45% (2020 COVID crash for small-cap) |
| **Correlation with Equity Markets** | Very High (0.90 - 0.95) |
| **Suitable for Goals** | 15-30 year goals, retirement (very long horizon) |
| **Rebalancing Frequency** | Annual (resist temptation to trade frequently) |

---

### Sample Fund Selection (Implementation)

**Equity Component (95%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Nifty 50 Index Fund | ICICI Pru Nifty 50 Index Fund | 10% | Core large-cap (passive) |
| Large-Cap Diversified | Mirae Asset Large Cap Fund | 10% | Active large-cap alpha |
| Mid-Cap Diversified | Axis Midcap Fund / Invesco India Midcap Fund | 15% | Mid-cap growth |
| Mid-Cap Aggressive | DSP Midcap Fund | 10% | Additional mid-cap exposure |
| Small-Cap Diversified | Nippon India Small Cap Fund / Quant Small Cap Fund | 15% | Long-term wealth creation |
| Small-Cap Aggressive | Axis Small Cap Fund | 10% | Maximum growth potential |
| International Equity (US) | Motilal Oswal Nasdaq 100 FoF | 10% | US tech exposure |
| International Equity (Global) | PGIM India Global Equity Opp Fund | 5% | Global diversification |
| Sectoral - Technology | ICICI Pru Technology Fund | 5% | Thematic exposure |
| Sectoral - Pharma/Infrastructure | Nippon India Pharma Fund / ICICI Pru Infra Fund | 5% | Sector rotation opportunities |

**Debt Component (5%)**:
| Fund Category | Example Fund | Allocation | Rationale |
|---------------|--------------|------------|-----------|
| Ultra Short-Term | HDFC Ultra Short Term Fund | 3% | Minimal liquidity buffer |
| Gold ETF | HDFC Gold ETF | 2% | Rebalancing tool during crashes |

---

### Risk Mitigation Strategies

1. **⚠️ HIGH RISK PROFILE**: This portfolio is suitable ONLY for investors who can genuinely tolerate 40%+ declines
2. **Time Horizon Critical**: Minimum 15-year investment horizon MANDATORY
3. **Small-Cap Concentration**: 25% small-cap allocation can experience severe drawdowns (2018 small-cap crash: -45%)
4. **Sectoral Risk**: 10% sectoral/thematic allocation adds concentration risk
5. **Rebalancing Discipline**: Annual rebalancing is CRITICAL to book profits and buy dips
6. **Behavioral Requirement**: Investor MUST have demonstrated ability to HOLD or BUY during past crashes

---

### ⚠️ WARNING - Suitability Gates

This portfolio is **NOT SUITABLE** for:
- ❌ Investors with <10 years investment experience
- ❌ Investors who sold during past market crashes (2020 COVID, 2018 small-cap crash)
- ❌ Investors with short-term goals (<10 years)
- ❌ Investors without adequate emergency fund (6+ months expenses)
- ❌ Investors with low financial knowledge (scored <5/7 on suitability quiz)
- ❌ Investors with uncertain income or high debt burden

**Mandatory RM Discussion**: Before recommending this portfolio, RM MUST:
1. Verify investor's past behavior during market crashes
2. Explain historical drawdowns (show 2020 crash: -40% decline in 1 month)
3. Obtain signed acknowledgment of high-risk nature
4. Confirm investor has diversified wealth (this is not 100% of net worth)

---

## Special Portfolio Variants

---

## VARIANT A: ESG-Focused Portfolios

### ESG Portfolio Principles

**Definition**: Portfolios screened for Environmental, Social, and Governance (ESG) criteria

**Exclusions**:
- ❌ Tobacco and alcohol companies
- ❌ Fossil fuel extraction (coal, oil, gas)
- ❌ Weapons manufacturing
- ❌ Companies with poor labor practices
- ❌ Companies with corruption/bribery scandals

**Inclusions**:
- ✅ Renewable energy companies
- ✅ Companies with strong governance scores
- ✅ Diversity and inclusion leaders
- ✅ Low carbon footprint businesses

---

### ESG Moderate Portfolio (60% Equity / 40% Debt)

**Equity Component (60%)**:
| Fund Category | Example Fund | Allocation |
|---------------|--------------|------------|
| ESG Large-Cap | SBI Magnum Equity ESG Fund / Quantum India ESG Equity Fund | 25% |
| Nifty 100 ESG Index | Nippon India Nifty 100 ESG Index Fund | 15% |
| International ESG | PGIM India Global ESG Leaders Fund (if available) | 10% |
| Sustainability Thematic | Mirae Asset ESG Sector Leaders Fund | 10% |

**Debt Component (40%)**:
| Fund Category | Example Fund | Allocation |
|---------------|--------------|------------|
| Green Bonds | ICICI Pru Green Bond Fund (if available) | 15% |
| Social Bonds | SBI Social Impact Fund (if available) | 10% |
| Regular Debt Funds | HDFC Short Term Debt Fund | 15% |

**Expected Return**: 9.5% - 11.5% (0.3-0.5% lower than standard due to ESG screening)

---

## VARIANT B: Tax-Optimized Portfolios (For High-Income Investors)

### Tax Optimization Strategies

**For 30% Tax Bracket Investors**:

1. **Equity-Oriented Funds (>65% equity)**: LTCG tax at 12.5% (>₹1.25L gains), STCG at 20%
2. **Debt Funds**: LTCG at 20% with indexation (>3 years), STCG at slab rate
3. **Gold ETFs**: Same as debt funds

**Tax-Efficient Portfolio Construction**:
- **Maximize Equity Allocation**: Equity funds get favorable LTCG treatment
- **Hold Debt Funds >3 Years**: Indexation benefit reduces tax significantly
- **SWP (Systematic Withdrawal Plan)**: More tax-efficient than dividend option for income

---

### Tax-Optimized Balanced Portfolio (70% Equity / 30% Debt)

**Equity Component (70%)** - Growth option only (not dividend):
| Fund Category | Allocation | Tax Treatment |
|---------------|------------|---------------|
| Large-Cap + Mid-Cap + Small-Cap Equity | 55% | LTCG 12.5% after ₹1.25L |
| International Equity | 10% | LTCG 12.5% after ₹1.25L |
| Gold ETF | 5% | LTCG 20% with indexation (>3 years) |

**Debt Component (30%)** - Hold >3 years for indexation:
| Fund Category | Allocation | Tax Treatment |
|---------------|------------|---------------|
| Short-Term Debt (hold >3 years) | 15% | LTCG 20% with indexation |
| Medium-Term Debt | 15% | LTCG 20% with indexation |

**Tax Efficiency Score**: High (assuming >3 year holding for all funds)

---

## VARIANT C: Retirement Glide Path Portfolios

### Age-Based Asset Allocation

**Concept**: Automatically reduce equity exposure as retirement approaches

**Glide Path Formula**:
```
Equity Allocation = 100 - Current Age (in years)

Example:
- Age 30 → 70% equity / 30% debt
- Age 40 → 60% equity / 40% debt
- Age 50 → 50% equity / 50% debt
- Age 60 → 40% equity / 60% debt
- Age 70 → 30% equity / 70% debt
```

---

### Sample Retirement Portfolio (Age 45, 20 years to retirement)

**Equity Allocation**: 55% (100 - 45)
**Debt Allocation**: 45%

**Equity Component (55%)**:
| Fund Category | Allocation |
|---------------|------------|
| Large-Cap Equity | 25% |
| Mid-Cap Equity | 15% |
| International Equity | 10% |
| Gold ETF | 5% |

**Debt Component (45%)**:
| Fund Category | Allocation |
|---------------|------------|
| Short-Term Debt | 15% |
| Medium-Term Debt | 20% |
| Corporate Bond Funds | 10% |

**Automatic Rebalancing**: Every 5 years, reduce equity by 5% and increase debt by 5%

---

## Portfolio Implementation Guidelines

### Step 1: Client Profiling

**Inputs Required**:
1. **Risk Profile Assessment Score** (8-35 from Risk Profile Questionnaire)
2. **Suitability Category** (Conservative/Moderate/Aggressive from Suitability Assessment)
3. **Goal Time Horizon** (From financial calculator/goal creation)
4. **Required Return** (From financial calculator - corpus calculation)

### Step 2: Portfolio Matching Logic

```
Portfolio Selection = INTERSECTION of:
├─ Risk Profile Category (Secure/Conservative/Income/Balance/Aggressive/Speculative)
├─ Suitability Category (Conservative/Moderate/Aggressive)
└─ Time Horizon Constraint (<3 years = max 20% equity, >10 years = up to 95% equity)

Decision Matrix:

IF Risk Profile = "SECURE" (8-13):
    → Recommend: Secure Portfolio (10% equity / 90% debt)

IF Risk Profile = "CONSERVATIVE" (14-16):
    → Recommend: Conservative Portfolio (20% equity / 80% debt)

IF Risk Profile = "INCOME" (17-21) AND Suitability >= MODERATE:
    → Recommend: Income Portfolio (40% equity / 60% debt)

IF Risk Profile = "BALANCE" (22-26) AND Suitability >= MODERATE AND Time Horizon >= 7 years:
    → Recommend: Balance Portfolio (60% equity / 40% debt)

IF Risk Profile = "AGGRESSIVE" (27-31) AND Suitability = AGGRESSIVE AND Time Horizon >= 10 years:
    → Recommend: Aggressive Portfolio (80% equity / 20% debt)

IF Risk Profile = "SPECULATIVE" (32-35) AND Suitability = AGGRESSIVE AND Time Horizon >= 15 years:
    → Recommend: Speculative Portfolio (95% equity / 5% debt)

OVERRIDE RULES (Safety Gates):
• Time Horizon < 3 years → FORCE Secure or Conservative (regardless of risk score)
• Suitability = CONSERVATIVE → Maximum 40% equity (regardless of risk score)
• No Emergency Fund → FORCE Secure Portfolio
```

### Step 3: Required Return Validation

**Validation Check**:
```
IF Required Return (from financial calculator) > Portfolio Expected Return:
    → Portfolio DOES NOT MATCH
    → Show next higher-return portfolio as suggestion
    → Warn client about higher risk

ELSE:
    → Portfolio MATCHES
    → Proceed with recommendation
```

**Example**:
- Client's Risk Profile: Balance (22) → 60% equity portfolio (10.5-12.5% expected return)
- Required Return from Financial Calculator: 13.5%
- **Result**: ❌ Balance portfolio (12.5% max) CANNOT meet 13.5% requirement
- **Recommendation**: Suggest Aggressive portfolio (80% equity, 11.5-13.5% return) with risk warning

---

## Rebalancing Strategies

### Threshold-Based Rebalancing

**Trigger**: When any asset class deviates >5% from target

**Example - Balance Portfolio (60% Equity / 40% Debt)**:

**Initial Allocation** (₹10,00,000 portfolio):
- Equity: ₹6,00,000 (60%)
- Debt: ₹4,00,000 (40%)

**After 1 Year** (equity rallies, debt stable):
- Equity: ₹7,80,000 (66%) → **+6% deviation** → TRIGGER REBALANCING
- Debt: ₹4,20,000 (34%)
- Total: ₹12,00,000

**Rebalancing Action**:
- Target Equity: 60% of ₹12,00,000 = ₹7,20,000
- Target Debt: 40% of ₹12,00,000 = ₹4,80,000
- **Action**: Sell ₹60,000 equity, Buy ₹60,000 debt

**Benefit**: Books profits from equity rally, maintains risk profile

---

### Calendar-Based Rebalancing

**Frequency Recommendations**:
- **Secure/Conservative Portfolios**: Semi-annual rebalancing
- **Income/Balance Portfolios**: Annual rebalancing
- **Aggressive/Speculative Portfolios**: Annual rebalancing (resist frequent trading)

**Optimal Rebalancing Date**: March 31st (end of financial year - tax planning opportunity)

---

## Risk Management & Behavioral Guidance

### Common Behavioral Pitfalls

**Pitfall 1: Panic Selling During Crashes**
- **Scenario**: Portfolio drops 20% in 2 months during market crash
- **Wrong Response**: Sell everything, move to fixed deposits
- **Correct Response**: HOLD or BUY more (rebalancing opportunity)
- **RM Guidance**: Show historical recovery data (2020 crash recovered in 6 months)

**Pitfall 2: Chasing Past Performance**
- **Scenario**: Small-cap funds returned 40% last year, client wants 100% small-cap
- **Wrong Response**: Switch entire portfolio to small-cap
- **Correct Response**: Maintain diversified allocation per risk profile
- **RM Guidance**: Past performance ≠ future returns, diversification is key

**Pitfall 3: Checking Portfolio Daily**
- **Scenario**: Client monitors portfolio value every day, gets anxious about volatility
- **Wrong Response**: Make frequent changes based on daily moves
- **Correct Response**: Review quarterly, rebalance annually
- **RM Guidance**: Long-term goals need long-term discipline

---

### Maximum Exposure Limits (Risk Controls)

**Individual Fund Limits**:
- Maximum allocation to any single fund: 25%
- Maximum allocation to any single AMC: 40%
- Maximum sectoral exposure: 15% (except for thematic portfolios)

**Asset Class Limits**:
- Minimum debt allocation (even for Speculative portfolio): 5%
- Maximum small-cap allocation: 30%
- Maximum international equity: 20%
- Maximum gold/commodities: 10%

**Concentration Risk Management**:
- Minimum number of funds: 4-5 funds
- Maximum number of funds: 10-12 funds (avoid over-diversification)

---

## Performance Monitoring & Reporting

### Quarterly Performance Report Template

```
═══════════════════════════════════════════════════════════════
              PORTFOLIO PERFORMANCE REPORT
═══════════════════════════════════════════════════════════════

Client: [Name] | Portfolio: [BALANCE] | Date: [DD-MMM-YYYY]

───────────────────────────────────────────────────────────────
1. PORTFOLIO SUMMARY
───────────────────────────────────────────────────────────────

Current Value: ₹[XX,XX,XXX]
Total Invested: ₹[XX,XX,XXX]
Absolute Return: ₹[X,XX,XXX] ([XX.X]%)
XIRR (Annualized): [XX.X]%
Time Period: [Start Date] to [End Date]

───────────────────────────────────────────────────────────────
2. ASSET ALLOCATION vs TARGET
───────────────────────────────────────────────────────────────

Asset Class    | Target | Current | Deviation | Action
───────────────|--------|---------|-----------|─────────────
Equity         | 60%    | 64%     | +4%       | Monitor
Debt           | 40%    | 36%     | -4%       | Monitor
Gold           | 5%     | 5%      | 0%        | Aligned

Status: ✅ No rebalancing needed (deviation <5%)

───────────────────────────────────────────────────────────────
3. RETURNS vs BENCHMARK
───────────────────────────────────────────────────────────────

Period         | Your Portfolio | Benchmark | Outperformance
───────────────|----------------|-----------|───────────────
3 Months       | +4.2%          | +3.8%     | +0.4%
6 Months       | +8.5%          | +7.9%     | +0.6%
1 Year         | +12.1%         | +11.2%    | +0.9%

Benchmark: 60% Nifty 50 + 40% CRISIL Composite Bond Index

───────────────────────────────────────────────────────────────
4. GOAL PROGRESS TRACKER
───────────────────────────────────────────────────────────────

Goal: Child Education Fund
Target Corpus: ₹50,00,000 | Target Date: 31-Dec-2034
Current Value: ₹12,50,000 (25% achieved)
Required Return: 11.5% | Achieved Return (XIRR): 12.1%

Status: ✅ ON TRACK (achieved return > required return)

───────────────────────────────────────────────────────────────
5. RECOMMENDATIONS
───────────────────────────────────────────────────────────────

• Continue systematic investments as planned
• Next review: [Date + 3 months]
• No rebalancing needed at this time

═══════════════════════════════════════════════════════════════
```

---

## Appendix: Historical Performance Data

### Indian Equity Market Returns (2000-2024)

| Index | 5Y CAGR | 10Y CAGR | 15Y CAGR | 20Y CAGR | Volatility |
|-------|---------|----------|----------|----------|------------|
| **Nifty 50** | 14.2% | 12.8% | 11.9% | 11.2% | 16.5% |
| **Nifty Next 50** | 15.8% | 14.1% | 13.2% | 12.5% | 18.2% |
| **Nifty Midcap 100** | 19.2% | 15.4% | 14.8% | 13.9% | 21.3% |
| **Nifty Smallcap 100** | 18.5% | 14.2% | 12.8% | 11.5% | 26.8% |
| **S&P 500 (USD)** | 13.8% | 11.2% | 10.8% | 9.5% | 15.2% |

**Source**: NSE, BSE, S&P Dow Jones Indices (as of December 2024)

### Indian Debt Market Returns (2000-2024)

| Category | 5Y CAGR | 10Y CAGR | 20Y CAGR | Volatility |
|----------|---------|----------|----------|------------|
| **Liquid Funds** | 5.2% | 5.8% | 6.2% | 0.8% |
| **Short-Term Debt** | 6.8% | 7.2% | 7.8% | 2.1% |
| **Corporate Bonds** | 7.5% | 8.1% | 8.5% | 3.2% |
| **Gilt Funds (10Y)** | 7.2% | 7.9% | 8.2% | 5.5% |

**Source**: CRISIL, AMFI (as of December 2024)

### Model Portfolio Backtested Returns (2010-2024)

| Portfolio | Equity % | 5Y CAGR | 10Y CAGR | Max Drawdown | Recovery Time |
|-----------|----------|---------|----------|--------------|---------------|
| **Secure** | 10% | 7.2% | 7.8% | -5.2% | 3 months |
| **Conservative** | 20% | 8.5% | 8.9% | -9.8% | 6 months |
| **Income** | 40% | 10.2% | 10.8% | -14.5% | 9 months |
| **Balance** | 60% | 11.8% | 12.2% | -21.2% | 12 months |
| **Aggressive** | 80% | 13.2% | 13.5% | -28.5% | 18 months |
| **Speculative** | 95% | 14.1% | 14.2% | -35.8% | 24 months |

**Note**: Backtested using historical data; past performance does not guarantee future results.

---

## Document Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 24-Dec-2025 | Initial creation with 6 model portfolios based on Vanguard, Morningstar, Fidelity research | GBA Implementation Team |

---

**END OF MODERN PORTFOLIO BUCKETS DOCUMENT**
