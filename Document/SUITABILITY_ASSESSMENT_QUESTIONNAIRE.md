# Suitability Assessment Questionnaire
## MiFID II Compliant Assessment (Top 8 Questions)

**Version**: 2.0
**Last Updated**: December 25, 2025
**Regulatory Framework**: MiFID II (Markets in Financial Instruments Directive II), FINRA Rule 2111, SEBI IA Regulations 2013
**Purpose**: Streamlined suitability assessment to ensure investment recommendations align with client's knowledge, experience, financial situation, and investment objectives

---

## Document Information

### Research Sources

This questionnaire is based on industry-standard practices from:

1. **ESMA MiFID II Suitability Guidelines** (2018/2019)
   - European Securities and Markets Authority regulatory requirements
   - [ESMA Guidelines on Suitability](https://www.esma.europa.eu/sites/default/files/library/esma35-43-1163_guidelines_on_certain_aspects_of_mifid_ii_suitability_requirements.pdf)

2. **FINRA Rule 2111** - Suitability Obligations
   - U.S. regulatory framework for suitability assessments
   - [FINRA Suitability Rule](https://www.finra.org/rules-guidance/rulebooks/finra-rules/2111)

3. **SEBI Investment Adviser Regulations** (2013)
   - India-specific regulatory requirements for client profiling
   - [SEBI IA Regulations](https://www.sebi.gov.in/legal/regulations/jan-2013/sebi-investment-advisers-regulations-2013_28353.html)

4. **CFA Institute** - Suitability and Investment Recommendations
   - Professional standards for investment suitability
   - [CFA Suitability Standards](https://www.cfainstitute.org/en/ethics-standards/codes/standards-of-practice-guidance/suitability)

---

## Assessment Structure

**Total Questions**: 8 (Optimized from 32-question comprehensive version)
**Assessment Categories**: 4
- Personal Information (1 question)
- Financial Situation (3 questions)
- Investment Experience (2 questions)
- Investment Knowledge & Objectives (2 questions)

**Scoring Method**: Multi-dimensional assessment across 3 dimensions:
- **Risk Capacity**: Ability to take risk (financial situation)
- **Investment Knowledge**: Understanding of financial instruments
- **Investment Experience**: Historical investment behavior

**Assessment Time**: 7-10 minutes (reduced from 15-20 minutes)
**Recommended Usage**: Annual review or when client circumstances change significantly

**Selection Rationale**: These 8 questions capture the **mandatory MiFID II requirements** and **most predictive behavioral factors**:
- Q1, Q2, Q3: MiFID II mandatory fields (age, income, net worth)
- Q4: Gate question (determines if client can take any risk)
- Q5, Q6: Experience assessment (regulatory requirement)
- Q7: Knowledge validation (objective quiz)
- Q8: Investment objectives (regulatory requirement)

---

## Complete Questionnaire

### **Question 1: Age Group**

**Question Code**: `SUIT_AGE_GROUP`
**Question Type**: Single Select
**Category**: Personal Information
**Mandatory**: Yes (MiFID II Required)
**Weight**: 1.0

**Question Text**:
Please select your current age group:

**Description (All Users)**:
Your age helps us understand your investment timeline and financial life stage. Younger investors typically have more time to recover from market downturns, while those closer to retirement may prioritize capital preservation.

**RM Notes**:
- Correlate with investment time horizon for consistency check
- Clients under 35 typically have higher risk capacity but may lack experience
- Clients over 55 require special attention to capital preservation needs
- MiFID II requires age for lifecycle investing approach

**Client Notes**:
This information is mandatory for regulatory compliance and helps us recommend age-appropriate investment strategies.

**Options**:

| Option | Value | Assessment Impact | Risk Capacity |
|--------|-------|-------------------|---------------|
| Under 25 years | `UNDER_25` | Longest time horizon, highest capacity for equity | Very High |
| 25-35 years | `AGE_25_35` | Long horizon, wealth accumulation phase | High |
| 36-45 years | `AGE_36_45` | Moderate to high capacity, peak earning | Moderate-High |
| 46-55 years | `AGE_46_55` | Moderate capacity, pre-retirement planning | Moderate |
| 56-65 years | `AGE_56_65` | Lower capacity, nearing retirement | Low-Moderate |
| Over 65 years | `OVER_65` | Lowest capacity, preservation focus | Low |

**Source**: MiFID II Guidelines Section 4.2.1 - Personal Circumstances

---

### **Question 2: Annual Gross Income**

**Question Code**: `SUIT_ANNUAL_INCOME`
**Question Type**: Single Select
**Category**: Financial Situation
**Mandatory**: Yes (MiFID II Required)
**Weight**: 1.5

**Question Text**:
What is your approximate annual gross income (before taxes)?

**Description (All Users)**:
Your income level helps us understand your investment capacity and ability to sustain regular investments. This information is strictly confidential and required for regulatory compliance.

**RM Notes**:
- **MiFID II MANDATORY FIELD**: Cannot proceed without this information
- Income verification may be required for high-value portfolios (>₹25L)
- Compare with Net Worth (Q3) for consistency - low income + high net worth may indicate inheritance/windfall
- If "Prefer not to disclose" selected → Cannot proceed with suitability assessment

**Client Notes**:
**IMPORTANT**: This information is mandatory for regulatory compliance under MiFID II and SEBI IA Regulations. We cannot provide suitable investment recommendations without understanding your financial capacity. Your data is strictly confidential and protected under data privacy regulations.

**Options**:

| Option | Value | Investment Capacity | SIP Capacity |
|--------|-------|---------------------|--------------|
| Below ₹3,00,000 | `BELOW_3L` | Limited | Micro-SIP only |
| ₹3,00,000 - ₹6,00,000 | `3L_6L` | Basic | ₹2,000-₹5,000/month |
| ₹6,00,000 - ₹12,00,000 | `6L_12L` | Moderate | ₹5,000-₹15,000/month |
| ₹12,00,000 - ₹25,00,000 | `12L_25L` | Strong | ₹15,000-₹50,000/month |
| ₹25,00,000 - ₹50,00,000 | `25L_50L` | High | ₹50,000-₹1,00,000/month |
| Above ₹50,00,000 | `ABOVE_50L` | Very High | ₹1,00,000+/month |
| Prefer not to disclose | `NOT_DISCLOSED` | **Cannot proceed** | N/A |

**Source**: MiFID II Article 25(2) - Assessment of Financial Situation

---

### **Question 3: Total Net Worth**

**Question Code**: `SUIT_NET_WORTH`
**Question Type**: Single Select
**Category**: Financial Situation
**Mandatory**: Yes (MiFID II Required)
**Weight**: 1.5

**Question Text**:
What is your approximate total net worth (total assets minus total liabilities)?

**Description (All Users)**:
Your net worth helps us understand your overall financial strength and ability to absorb potential losses. This includes all assets (real estate, investments, savings) minus debts.

**RM Notes**:
- **MiFID II MANDATORY FIELD**: Required for risk capacity assessment
- Net Worth ≥ ₹1 Crore → Consider private banking services
- Verify consistency: If Net Worth >> Annual Income → Ask about source (inheritance, business sale, windfall)
- Cross-check with Emergency Fund status (Q4) - high net worth with no emergency fund = poor financial planning

**Client Notes**:
This information helps us ensure investment recommendations are appropriate for your financial situation. Include all assets (property, investments, savings, gold) and subtract all liabilities (loans, credit card debt).

**Options**:

| Option | Value | Financial Strength | Client Category |
|--------|-------|-------------------|-----------------|
| Below ₹5,00,000 | `BELOW_5L` | Limited buffer | Retail |
| ₹5,00,000 - ₹25,00,000 | `5L_25L` | Basic cushion | Retail |
| ₹25,00,000 - ₹50,00,000 | `25L_50L` | Moderate wealth | Retail+ |
| ₹50,00,000 - ₹1,00,00,000 | `50L_1CR` | Strong position | HNI Track |
| ₹1,00,00,000 - ₹5,00,00,000 | `1CR_5CR` | High Net Worth | HNI |
| Above ₹5,00,00,000 | `ABOVE_5CR` | Ultra HNI | Private Banking |
| Prefer not to disclose | `NOT_DISCLOSED` | **Cannot proceed** | N/A |

**Source**: MiFID II Guidelines - Wealth Assessment, SEBI IA Regulations

---

### **Question 4: Emergency Fund Status**

**Question Code**: `SUIT_EMERGENCY_FUND`
**Question Type**: Single Select
**Category**: Financial Situation
**Mandatory**: Yes (GATE QUESTION)
**Weight**: 2.0 (Highest weight - determines risk capacity)

**Question Text**:
Do you have an emergency fund covering at least 6 months of essential expenses in liquid instruments (savings account, liquid funds, FD)?

**Description (All Users)**:
An emergency fund protects your investments from forced liquidation during crises. Without adequate emergency savings, you might need to sell long-term investments at unfavorable times.

**RM Notes**:
- **CRITICAL GATE QUESTION**: Client MUST have 3+ months emergency fund before equity allocation
- **MANDATORY REQUIREMENT**: No emergency fund = Maximum 20% equity allocation
- If "No emergency fund" → Recommend liquid/ultra-short-term debt funds FIRST
- Emergency fund should be in LIQUID instruments (not equity, not locked-in FDs, not real estate)
- Calculation: 6 months × Monthly expenses (not income!)

**Client Notes**:
**CRITICAL**: An emergency fund is the foundation of financial planning. Without it, you may be forced to sell long-term investments during market downturns or personal emergencies, locking in losses and derailing your financial goals.

**Options**:

| Option | Value | Risk Capacity Impact | Max Equity % |
|--------|-------|---------------------|--------------|
| Yes, 6+ months covered | `YES_ADEQUATE` | Ready for growth investments | 95% |
| Yes, 3-6 months covered | `YES_PARTIAL` | Can proceed with moderate risk | 70% |
| Less than 3 months covered | `INADEQUATE` | **WARNING**: Build emergency fund first | 40% |
| No emergency fund | `NO_FUND` | **RED FLAG**: Cannot recommend equity | 20% max |

**Source**: CFA Institute - Emergency Fund Guidelines, SEBI IA Best Practices

---

### **Question 5: Years of Investment Experience**

**Question Code**: `SUIT_YEARS_EXPERIENCE`
**Question Type**: Single Select
**Category**: Investment Experience
**Mandatory**: Yes (MiFID II Required)
**Weight**: 1.0

**Question Text**:
How many years of experience do you have in investing in financial instruments (mutual funds, stocks, bonds, etc.)?

**Description (All Users)**:
Your investment experience helps us recommend products at an appropriate complexity level. Experienced investors understand market cycles and can handle more sophisticated strategies.

**RM Notes**:
- **MiFID II REQUIREMENT**: Experience assessment mandatory for product suitability
- <1 year experience → Limit to diversified equity mutual funds, no sectoral/thematic funds
- <3 years experience → No direct equity, no derivatives, no alternative investments
- This is CALENDAR experience (years since first investment), not transaction frequency
- Cross-verify with Past Performance Behavior (Q6) for consistency

**Client Notes**:
Experience with investing helps you understand market cycles, stay calm during volatility, and make rational decisions. New investors benefit from diversified, professionally managed funds.

**Options**:

| Option | Value | Experience Level | Product Suitability |
|--------|-------|------------------|---------------------|
| No experience (first-time investor) | `NO_EXPERIENCE` | Beginner | Large-cap equity MF, debt MF only |
| Less than 1 year | `LESS_1_YEAR` | Novice | Diversified MF, no sectoral funds |
| 1-3 years | `1_3_YEARS` | Basic | Standard MF products |
| 3-5 years | `3_5_YEARS` | Intermediate | Most MF products, multi-asset funds |
| 5-10 years | `5_10_YEARS` | Experienced | All MF products, PMS consideration |
| More than 10 years | `ABOVE_10_YEARS` | Expert | All products including alternatives |

**Source**: ESMA MiFID II - Experience Assessment, FINRA Rule 2111

---

### **Question 6: Past Performance Behavior**

**Question Code**: `SUIT_PAST_PERFORMANCE`
**Question Type**: Single Select
**Category**: Investment Experience
**Mandatory**: Yes (CRITICAL BEHAVIORAL QUESTION)
**Weight**: 2.0 (Highest weight - best behavioral predictor)

**Question Text**:
Have you ever experienced a significant loss (>20% decline) in your investment portfolio? If yes, what did you do?

**Description (All Users)**:
Your behavior during past market downturns is the best indicator of your true risk tolerance. Historical context: 2008 financial crisis (-50%), 2020 COVID crash (-35%), 2022 correction (-20%).

**RM Notes**:
- **MOST IMPORTANT BEHAVIORAL QUESTION**: Past behavior predicts future behavior
- **"Loss and Sold"** → **MANDATORY RISK REDUCTION**:
  - Client will likely panic sell again during next downturn
  - Reduce equity allocation by 10-20% from model portfolio
  - Increase behavioral coaching and communication during volatility
- **"Loss and Bought More"** → Client has PROVEN risk tolerance (can handle aggressive portfolios)
- **"No Loss Experience"** → Untested risk tolerance, assume conservative until proven otherwise
- This question overrides self-stated risk tolerance from Risk Profile Questionnaire

**Client Notes**:
Be honest about your gut reaction during market drops. It's natural to feel nervous, but selling during downturns locks in losses and prevents recovery. Your actual behavior is more important than what you think you would do.

**Options**:

| Option | Value | Behavioral Type | Equity Adjustment |
|--------|-------|----------------|-------------------|
| No, never experienced significant loss | `NO_LOSS` | Untested (assume conservative) | -10% from model |
| Yes, and I sold investments during decline | `LOSS_SOLD` | **RED FLAG**: Panic seller | -20% from model |
| Yes, and I held investments without selling | `LOSS_HELD` | Positive: Demonstrated resilience | No adjustment |
| Yes, and I invested more during decline | `LOSS_BOUGHT_MORE` | Excellent: Contrarian mindset | +10% to model |
| Never invested during market volatility | `NO_VOLATILITY_EXP` | Untested (assume conservative) | -10% from model |

**Source**: Vanguard Investor Behavior Research, CFA Institute Behavioral Finance, Morningstar Investor Psychology

---

### **Question 7: Investment Knowledge Quiz**

**Question Code**: `SUIT_KNOWLEDGE_QUIZ`
**Question Type**: Multiple Choice Quiz (Aggregate Score)
**Category**: Investment Knowledge
**Mandatory**: Yes (MiFID II Required)
**Weight**: 1.5

**Question Text**:
Please answer the following 7 questions to assess your investment knowledge. This is required for regulatory compliance to ensure we only recommend products you understand.

**Description (All Users)**:
This short quiz validates your understanding of basic investment concepts. It's not a test to "pass" or "fail" - it helps us ensure we recommend only those products you're comfortable with.

**RM Notes**:
- **MiFID II REQUIREMENT**: Objective knowledge assessment mandatory
- Clients often overestimate their knowledge (Dunning-Kruger effect)
- Match product recommendations to TESTED knowledge, not self-assessed knowledge
- If score <60% (4 or fewer correct) → Limit to simple products (large-cap equity MF, debt MF only)
- If client claims expert knowledge but scores <5 → Flag for discussion

**Client Notes**:
This quiz helps us comply with regulations requiring that investment recommendations match your knowledge level. Take your time and answer honestly - there's no penalty for getting answers wrong.

---

#### **Quiz Question 1: Risk-Return Relationship**

**Question Text**:
Which of the following statements about investment risk and return is TRUE?

**Options**:
A) Higher returns always guarantee higher risk
B) Government bonds typically offer higher returns than equity stocks
C) Generally, there is a positive relationship between risk and potential return over the long term ✅
D) Fixed deposits have the same risk as equity mutual funds

**Correct Answer**: C

---

#### **Quiz Question 2: Diversification**

**Question Text**:
What is the primary benefit of diversification in an investment portfolio?

**Options**:
A) Guarantees higher returns
B) Eliminates all investment risk
C) Reduces portfolio risk by spreading investments across different assets ✅
D) Maximizes returns from a single best-performing asset

**Correct Answer**: C

---

#### **Quiz Question 3: Inflation Impact**

**Question Text**:
If inflation is 6% per year and your investment returns 5% per year, what is your REAL return?

**Options**:
A) +11%
B) +5%
C) -1% ✅
D) 0%

**Correct Answer**: C (Real return = Nominal return - Inflation = 5% - 6% = -1%)

---

#### **Quiz Question 4: Mutual Fund NAV**

**Question Text**:
What does NAV (Net Asset Value) represent in a mutual fund?

**Options**:
A) The total number of investors in the fund
B) The per-unit market value of the fund's holdings ✅
C) The annual return of the fund
D) The fund manager's performance fee

**Correct Answer**: B

---

#### **Quiz Question 5: Equity vs Debt**

**Question Text**:
Which statement about equity and debt investments is CORRECT?

**Options**:
A) Debt investments typically have higher volatility than equity
B) Equity investments offer fixed returns like debt
C) Equity investments have higher long-term growth potential but more short-term volatility ✅
D) Debt investments can never lose money

**Correct Answer**: C

---

#### **Quiz Question 6: SIP Benefit**

**Question Text**:
What is the main advantage of investing through SIP (Systematic Investment Plan)?

**Options**:
A) Guarantees positive returns in all market conditions
B) Allows you to time the market perfectly
C) Averages out purchase cost over time through rupee cost averaging ✅
D) Provides higher returns than lump-sum investments

**Correct Answer**: C

---

#### **Quiz Question 7: Long-Term Capital Gains Tax**

**Question Text**:
What is the current LTCG (Long-Term Capital Gains) tax rate on equity mutual funds in India (as of 2025)?

**Options**:
A) 0% (completely tax-free)
B) 10% above ₹1 lakh exemption
C) 12.5% above ₹1.25 lakh exemption ✅
D) 20% with indexation

**Correct Answer**: C

---

**Scoring**:

| Score | Knowledge Level | Product Suitability |
|-------|----------------|---------------------|
| 0-2 correct | Basic Knowledge | Debt MF, large-cap equity MF only |
| 3-4 correct | Moderate Knowledge | Standard diversified MF products |
| 5-6 correct | Good Knowledge | All MF products, multi-asset funds |
| 7 correct | Expert Knowledge | All products including PMS, AIFs (if eligible) |

**Source**: MiFID II Knowledge Assessment Requirements, SEBI IA Guidelines

---

### **Question 8: Primary Investment Objective**

**Question Code**: `SUIT_PRIMARY_OBJECTIVE`
**Question Type**: Single Select
**Category**: Investment Objectives
**Mandatory**: Yes (MiFID II Required)
**Weight**: 1.5

**Question Text**:
What is your primary objective for this investment?

**Description (All Users)**:
Your investment objective should align with your financial goals, time horizon, and risk capacity. Different objectives require different investment strategies.

**RM Notes**:
- **MiFID II REQUIREMENT**: Investment objectives mandatory for suitability
- Cross-check consistency:
  - Short time horizon (<3 years) + Aggressive growth = MISMATCH → Force to Conservative
  - Long time horizon (>10 years) + Capital preservation = SUBOPTIMAL → Educate on opportunity cost
  - High income need + No emergency fund = DANGEROUS → Build emergency fund first
- If "Speculation" selected → Verify with high risk tolerance score AND high net worth

**Client Notes**:
Your objective helps us balance between growth and stability. Be realistic about what you're trying to achieve - unrealistic expectations lead to poor investment decisions.

**Options**:

| Option | Value | Typical Allocation | Time Horizon |
|--------|-------|-------------------|--------------|
| Capital Preservation (protect what I have) | `PRESERVATION` | 10% Equity / 90% Debt | Any |
| Generate Regular Income | `INCOME` | 20% Equity / 80% Debt | 3-5 years |
| Balanced Growth & Income | `BALANCED` | 40% Equity / 60% Debt | 5-7 years |
| Long-term Capital Growth | `GROWTH` | 60% Equity / 40% Debt | 7-10 years |
| Aggressive Wealth Accumulation | `AGGRESSIVE_GROWTH` | 80% Equity / 20% Debt | 10-15 years |
| Speculation / Maximum Returns | `SPECULATION` | 95% Equity / 5% Debt | 15+ years |

**Source**: MiFID II - Investment Objectives Assessment, FINRA Rule 2111

---

## Suitability Scoring & Assessment

### Multi-Dimensional Scoring

Unlike the Risk Profile Questionnaire (which produces a single risk score), the Suitability Assessment evaluates **3 independent dimensions**:

```
┌─────────────────────────────────────────────────────┐
│         SUITABILITY ASSESSMENT DIMENSIONS            │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Dimension 1: RISK CAPACITY                         │
│  ├─ Based on: Age, Income, Net Worth, Emergency Fund│
│  ├─ Scale: 1-5 (Low to Very High)                   │
│  └─ Gate Factor: Emergency Fund (blocks if NO_FUND) │
│                                                      │
│  Dimension 2: INVESTMENT KNOWLEDGE                   │
│  ├─ Based on: Knowledge Quiz Score                  │
│  ├─ Scale: 1-4 (Basic to Expert)                    │
│  └─ Product Gate: Limits complex products           │
│                                                      │
│  Dimension 3: INVESTMENT EXPERIENCE                  │
│  ├─ Based on: Years Experience, Past Behavior       │
│  ├─ Scale: 1-5 (Beginner to Expert)                 │
│  └─ Behavioral Adjustment: Past panic selling = -20%│
│                                                      │
│  FINAL SUITABILITY = MIN(Dimension 1, 2, 3)         │
│  (Conservative principle: Limit by weakest dimension)│
│                                                      │
└─────────────────────────────────────────────────────┘
```

### Dimension 1: Risk Capacity Assessment

**Factors**: Age (Q1) + Income (Q2) + Net Worth (Q3) + Emergency Fund (Q4)

**Calculation**:

```
Step 1: Age Score (0-4 points)
- Under 25: 4
- 25-35: 3
- 36-45: 2
- 46-55: 1
- Over 55: 0

Step 2: Income Score (0-5 points)
- Below ₹3L: 0
- ₹3-6L: 1
- ₹6-12L: 2
- ₹12-25L: 3
- ₹25-50L: 4
- Above ₹50L: 5

Step 3: Net Worth Score (0-5 points)
- Below ₹5L: 0
- ₹5-25L: 1
- ₹25-50L: 2
- ₹50L-1Cr: 3
- ₹1-5Cr: 4
- Above ₹5Cr: 5

Step 4: Emergency Fund Multiplier (0.2x to 1.0x)
- No Fund: 0.2x (GATE - blocks high risk)
- <3 months: 0.4x
- 3-6 months: 0.7x
- 6+ months: 1.0x

Raw Capacity Score = (Age + Income + Net Worth) / 3
Final Capacity = Raw Score × Emergency Fund Multiplier

Mapping to Risk Capacity Level:
- 0.0-1.0: Level 1 (Low Capacity) → Max 20% equity
- 1.1-2.0: Level 2 (Moderate-Low) → Max 40% equity
- 2.1-3.0: Level 3 (Moderate) → Max 60% equity
- 3.1-4.0: Level 4 (High) → Max 80% equity
- 4.1-5.0: Level 5 (Very High) → Max 95% equity
```

### Dimension 2: Investment Knowledge

**Factor**: Knowledge Quiz Score (Q7)

**Mapping**:

| Quiz Score | Knowledge Level | Max Product Complexity |
|-----------|----------------|------------------------|
| 0-2 correct | Level 1: Basic | Large-cap equity MF, Debt MF only |
| 3-4 correct | Level 2: Moderate | All diversified MF, no sectoral/thematic |
| 5-6 correct | Level 3: Good | All MF products including sectoral |
| 7 correct | Level 4: Expert | All products (subject to eligibility) |

### Dimension 3: Investment Experience

**Factors**: Years Experience (Q5) + Past Behavior (Q6)

**Calculation**:

```
Step 1: Experience Score (1-5)
- No experience: 1
- <1 year: 2
- 1-3 years: 3
- 3-5 years: 4
- 5-10 years: 5
- >10 years: 5

Step 2: Behavioral Adjustment
- Never experienced loss: -1
- Sold during loss: -2 (PANIC SELLER)
- Held during loss: 0 (Neutral)
- Bought more during loss: +1 (PROVEN TOLERANCE)

Final Experience Level = MAX(1, MIN(5, Experience Score + Behavioral Adjustment))
```

### Final Suitability Determination

```
FINAL SUITABILITY = MIN(Risk Capacity Level, Knowledge Level, Experience Level)

The WEAKEST dimension determines overall suitability.
```

**Example**:

```
Client: Priya Sharma

Q1 (Age): 25-35 → 3 points
Q2 (Income): ₹6-12L → 2 points
Q3 (Net Worth): ₹25-50L → 2 points
Q4 (Emergency Fund): 6+ months → 1.0x

Risk Capacity:
- Raw = (3+2+2)/3 = 2.33
- Final = 2.33 × 1.0 = 2.33 → Level 3 (Moderate)

Q5 (Experience): 1-3 years → 3 points
Q6 (Past Behavior): Held during loss → +0

Experience Level: 3 + 0 = 3 → Level 3 (Intermediate)

Q7 (Knowledge Quiz): 5 correct → Level 3 (Good)

FINAL SUITABILITY = MIN(3, 3, 3) = LEVEL 3 (MODERATE)
→ Suitable for 60% equity / 40% debt allocation
→ Can invest in all standard diversified MF products
```

---

## Suitability Categories & Investment Guidelines

| Level | Category | Max Equity % | Suitable Products | Restrictions |
|-------|----------|--------------|-------------------|--------------|
| **1** | **Conservative** | 20% | Large-cap equity MF, Debt MF, Liquid funds | No mid/small cap, no sectoral funds |
| **2** | **Moderate-Low** | 40% | Diversified equity MF, Multi-asset funds | No sectoral, no direct equity |
| **3** | **Moderate** | 60% | All diversified MF, Sectoral funds (limited) | No direct equity, no derivatives |
| **4** | **Moderate-High** | 80% | All MF products, PMS (if eligible) | No derivatives unless certified |
| **5** | **Aggressive** | 95% | All products (subject to eligibility) | Full product suite access |

---

## Assessment Report Template

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SUITABILITY ASSESSMENT REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Customer: [Name]
Customer ID: [ID]
Assessment Date: [Date]
Assessment ID: [ID]
Assessed By: [RM Name]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FINAL SUITABILITY: LEVEL [X] - [CATEGORY NAME]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Dimensional Assessment:

1. RISK CAPACITY: Level [X]
   ├─ Age: [Range]
   ├─ Annual Income: [Range]
   ├─ Net Worth: [Range]
   └─ Emergency Fund: [Status] ← [GATE FACTOR if low]

2. INVESTMENT KNOWLEDGE: Level [X]
   ├─ Quiz Score: [X]/7 correct
   └─ Knowledge Category: [Basic/Moderate/Good/Expert]

3. INVESTMENT EXPERIENCE: Level [X]
   ├─ Years of Experience: [Range]
   ├─ Past Behavior: [Description]
   └─ Behavioral Adjustment: [+/- X]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Investment Guidelines:

Maximum Equity Allocation: [XX]%
Recommended Allocation: [XX]% Equity / [XX]% Debt
Suitable Products: [List]
Restricted Products: [List]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Key Observations:
[Auto-generated based on responses]

Red Flags (if any):
[List any warning signs - no emergency fund, panic selling history, etc.]

Advisor Notes:
[RM observations and recommendations]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Regulatory Compliance:
✓ MiFID II Article 25(2) - Financial Situation Assessed
✓ MiFID II Article 25(2) - Knowledge & Experience Assessed
✓ MiFID II Article 25(2) - Investment Objectives Assessed
✓ SEBI IA Regulations 2013 - Client Profiling Complete
✓ FINRA Rule 2111 - Suitability Determination Made

Valid Until: [Date + 12 months]
Next Review: [Date + 12 months or when circumstances change]
Reviewed & Approved By: [RM Name, RM ID]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Why These 8 Questions?

### Mandatory Regulatory Requirements (MiFID II)

**MiFID II Article 25(2) requires assessment of:**

1. **Knowledge and Experience** → Q5, Q6, Q7
2. **Financial Situation** → Q2, Q3, Q4
3. **Investment Objectives** → Q8
4. **Personal Circumstances** → Q1 (age)

All 8 questions map directly to regulatory requirements.

### Removed Questions (From 32-Question Version)

**Questions Removed (24 questions)**:
- Education Level (less predictive than knowledge quiz)
- Employment Status (captured via income stability)
- Number of Dependents (secondary factor)
- Monthly Surplus (calculated from income)
- Outstanding Liabilities (less critical for MF investing)
- Insurance Coverage (important but not for suitability assessment)
- Investment Frequency (less predictive than holding period)
- Largest Single Investment (secondary factor)
- Typical Holding Period (captured via past behavior)
- Financial Literacy Self-Assessment (replaced with objective quiz)
- Remaining knowledge quiz questions (combined into Q7)
- Various investment horizon questions (covered in Risk Profile Questionnaire)

**Rationale**:
- 32-question version provides comprehensive profile but takes 15-20 minutes
- 8-question version captures all MiFID II mandatory fields in 7-10 minutes
- Removed redundant questions (e.g., self-assessed knowledge replaced with objective quiz)
- Focused on highest-impact behavioral predictors (past panic selling is #1 predictor)
- Optimized for customer experience while maintaining regulatory compliance

---

## Compliance Notes

✅ **Regulatory Compliance:**
- **MiFID II Article 25(2)**: All mandatory suitability factors assessed
- **FINRA Rule 2111**: Customer-specific suitability determination
- **SEBI IA Regulations 2013**: Client profiling requirements met
- **CFA Institute Standards**: Professional suitability standards followed

✅ **Best Practices:**
- Objective knowledge assessment (quiz) validates self-stated knowledge
- Past behavior analysis predicts future behavior (Vanguard research)
- Multi-dimensional scoring prevents single-factor bias
- Conservative principle: weakest dimension limits overall suitability
- Emergency fund as gate factor prevents unsuitable high-risk recommendations

✅ **Data Privacy:**
- Income and net worth data encrypted in transit and at rest
- Access restricted to authorized RMs only
- Compliant with GDPR and India's DPDP Act 2023
- Client can request data deletion (right to be forgotten)

---

**Document Status:** ✅ MiFID II Compliant Suitability Assessment (Top 8)
**Regulatory Framework:** MiFID II, FINRA Rule 2111, SEBI IA Regulations 2013
**Version:** 2.0 - December 2025 (Optimized from 32 to 8 questions)
**Change Log:** Reduced from 32 to 8 questions while maintaining full regulatory compliance
**Validation:** All MiFID II mandatory fields included, behavioral finance best practices incorporated
