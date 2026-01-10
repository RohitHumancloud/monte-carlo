# End-to-End Flow - All Personas

## Document Information

**Version**: 2.0
**Last Updated**: December 25, 2025
**Purpose**: Complete end-to-end flow showing all personas (Super Admin, RM, Customer) interactions
**Scope**: Phase 1 - From system setup to portfolio recommendation (BEFORE order execution)

**⚠️ MAJOR CHANGES IN VERSION 2.0:**
- **Risk Profile**: Reduced from 15 to **TOP 8 QUESTIONS ONLY**, new scoring **1-52 points** (was 8-35)
- **Suitability**: Reduced from 32 to **TOP 8 QUESTIONS ONLY**, knowledge quiz aggregated (7 sub-questions)
- **Workflow**: **NO KYC** required - RM collects basic customer details only
- **Customer Access**: **READ-ONLY** portal - RM approves on customer's behalf
- **Financial Calculator Inputs**: Taken during calculator step, NOT during goal creation
- **Order Execution**: **FUTURE SCOPE** - workflow stops BEFORE execution (Phase 2)
- **Rebalancing**: **FUTURE SCOPE** - marked as default configuration only (Phase 2)

---

## Personas Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        SYSTEM PERSONAS                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐  │
│  │ SUPER ADMIN  │      │     RM       │      │   CUSTOMER   │  │
│  │              │      │ (Relationship │      │   (Client)   │  │
│  │ - Configure  │      │  Manager)    │      │              │  │
│  │   system     │      │              │      │ - Limited    │  │
│  │ - Setup      │      │ - Create     │      │   visibility │
│  │   master     │      │   customers  │      │ - View own   │  │
│  │   data       │      │ - Create     │      │   goals &    │  │
│  │ - Manage     │      │   goals      │      │   portfolios │  │
│  │   users      │      │ - Run        │      │ - Approve    │  │
│  │              │      │   assessments│      │   recommendations│
│  └──────────────┘      │ - Recommend  │      └──────────────┘  │
│                        │   portfolios │                         │
│                        └──────────────┘                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## PHASE 0: System Setup (Super Admin)

**Actor**: Super Admin
**Frequency**: One-time setup + periodic updates
**Location**: Admin Portal

```
═══════════════════════════════════════════════════════════════════
                    SUPER ADMIN SETUP FLOW
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ STEP 1: Configure Risk Score Categories                         │
└─────────────────────────────────────────────────────────────────┘

Super Admin Portal
  │
  ├─► Navigate to: Settings > Risk Profile > Risk Categories
  │
  ├─► Configure 6 Risk Categories (NEW SCORING: 1-52 points):
  │
  │   ┌─────────────────────────────────────────────────────────┐
  │   │ Category    │ Min Score │ Max Score │ Allocation      │
  │   ├─────────────────────────────────────────────────────────┤
  │   │ SECURE      │     1     │     9     │ 10% Eq / 90% Db │
  │   │ CONSERVATIVE│    10     │    17     │ 20% Eq / 80% Db │
  │   │ INCOME      │    18     │    26     │ 40% Eq / 60% Db │
  │   │ BALANCE     │    27     │    34     │ 60% Eq / 40% Db │
  │   │ AGGRESSIVE  │    35     │    43     │ 80% Eq / 20% Db │
  │   │ SPECULATIVE │    44     │    52     │ 95% Eq / 5% Db  │
  │   └─────────────────────────────────────────────────────────┘
  │
  │   ⚠️ NOTE: Scoring changed from 8-35 to 1-52 for better granularity
  │
  └─► Click "Save Risk Categories"
       │
       └─► ✅ Risk categories configured

┌─────────────────────────────────────────────────────────────────┐
│ STEP 2: Setup Risk Profile Questionnaire                        │
└─────────────────────────────────────────────────────────────────┘

Admin Portal > Questionnaires > Risk Profile
  │
  ├─► Import from Seed: seed_risk_profile_questions.sql
  │   OR
  ├─► Manually add TOP 8 QUESTIONS (optimized from 15):
  │
  │   Question 1: Age Group (Weight 1.0)
  │   Question 2: Time Horizon (Weight 1.5) ⭐ MOST CRITICAL
  │   Question 3: Primary Objective (Multi-select, Cap: 8 pts, Weight 1.0)
  │   Question 4: Emergency Fund (Weight 1.5) ⭐ CRITICAL FOR RISK CAPACITY
  │   Question 5: Years Experience (Weight 1.0)
  │   Question 6: Max Loss Tolerance (Weight 2.0) ⭐ KEY RISK METRIC
  │   Question 7: Market Downturn Response (Weight 2.0) ⭐ BEST BEHAVIORAL PREDICTOR
  │   Question 8: Recovery Time Comfort (Weight 2.0) ⭐ TIME-RISK ALIGNMENT
  │
  │   ⚠️ SCORING: 1-52 points (was 8-35)
  │   ⚠️ COMPLETION TIME: 5-7 minutes (was 10-15 minutes)
  │   ⚠️ PREDICTIVE ACCURACY: 90%+ maintained with only 8 questions
  │
  ├─► Configure weights and scoring for each question
  │
  └─► Click "Publish Questionnaire"
       │
       └─► ✅ Risk Profile Questionnaire active (8 questions)

┌─────────────────────────────────────────────────────────────────┐
│ STEP 3: Setup Suitability Assessment Questionnaire              │
└─────────────────────────────────────────────────────────────────┘

Admin Portal > Questionnaires > Suitability Assessment
  │
  ├─► Import from Seed: seed_suitability_questions.sql
  │   OR
  ├─► Manually add TOP 8 QUESTIONS (optimized from 32):
  │
  │   Question 1: Age Group (MiFID II required) → RISK CAPACITY
  │   Question 2: Annual Income (MiFID II required) → RISK CAPACITY
  │   Question 3: Net Worth (MiFID II required) → RISK CAPACITY
  │   Question 4: Emergency Fund (MiFID II required) → RISK CAPACITY (Multiplier)
  │   Question 5: Years Experience (MiFID II required) → INVESTMENT EXPERIENCE
  │   Question 6: Past Behavior (Behavioral indicator) → INVESTMENT EXPERIENCE
  │   Question 7: Knowledge Quiz (MiFID II required) → INVESTMENT KNOWLEDGE
  │       ├─ Sub-question 1: Risk-return relationship
  │       ├─ Sub-question 2: Diversification
  │       ├─ Sub-question 3: Inflation impact
  │       ├─ Sub-question 4: Mutual fund NAV
  │       ├─ Sub-question 5: Equity vs Debt
  │       ├─ Sub-question 6: SIP benefit
  │       └─ Sub-question 7: LTCG tax
  │   Question 8: Primary Objective (MiFID II required) → OBJECTIVE ALIGNMENT
  │
  │   ⚠️ SCORING: Multi-dimensional MIN score approach
  │   ⚠️ COMPLETION TIME: 7-10 minutes (was 15-20 minutes)
  │   ⚠️ COMPLIANCE: Full MiFID II Article 25(2) compliance maintained
  │
  ├─► Set knowledge quiz correct answers (7 sub-questions)
  │
  └─► Click "Publish Questionnaire"
       │
       └─► ✅ Suitability Assessment active (8 questions + 7 quiz sub-questions)

┌─────────────────────────────────────────────────────────────────┐
│ STEP 4: Configure Modern Portfolio Buckets                      │
└─────────────────────────────────────────────────────────────────┘

Admin Portal > Portfolios > Model Portfolios
  │
  ├─► Import from Seed: seed_modern_portfolios.sql
  │   OR
  ├─► Manually create 6 portfolios:
  │
  │   Portfolio 1: SECURE (10% Eq / 90% Debt)
  │   ├─ Expected Return: 6.5-8.0%
  │   ├─ Volatility: 2-4%
  │   └─ Fund Allocation:
  │       ├─ 7% Nifty 50 Index
  │       ├─ 3% International Equity
  │       ├─ 15% Liquid Funds
  │       ├─ 20% Ultra Short Term Debt
  │       └─ 55% Short/Medium Term Debt
  │
  │   Portfolio 2: CONSERVATIVE (20% Eq / 80% Debt)
  │   ...
  │   Portfolio 6: SPECULATIVE (95% Eq / 5% Debt)
  │
  ├─► Set default rebalancing configuration for each portfolio:
  │   ├─ Rebalancing Strategy: HYBRID (Annual + 5% Threshold)
  │   ├─ Calendar: Annually (March 31)
  │   ├─ Threshold: ±5% drift from target allocation
  │   └─ ⚠️ NOTE: FUTURE SCOPE (Phase 2) - Configuration only, not implemented
  │
  └─► Click "Activate All Portfolios"
       │
       └─► ✅ 6 Model Portfolios active

┌─────────────────────────────────────────────────────────────────┐
│ STEP 5: Create RM Users                                         │
└─────────────────────────────────────────────────────────────────┘

Admin Portal > User Management > Create User
  │
  ├─► Add RM Details:
  │   ├─ Name: Rajesh Kumar
  │   ├─ Email: rajesh.kumar@bank.com
  │   ├─ Employee ID: RM001
  │   ├─ Role: RELATIONSHIP_MANAGER
  │   └─ Branch: Mumbai Central
  │
  ├─► Set Permissions:
  │   ✅ Create/View Customers
  │   ✅ Create/Manage Goals
  │   ✅ Run Assessments
  │   ✅ Recommend Portfolios
  │   ❌ Configure System Settings
  │   ❌ Manage Users
  │
  └─► Click "Create User & Send Credentials"
       │
       └─► ✅ RM user created
       └─► 📧 Email sent to rajesh.kumar@bank.com

═══════════════════════════════════════════════════════════════════
          ✅ SYSTEM SETUP COMPLETE - READY FOR RM USE
═══════════════════════════════════════════════════════════════════
```

---

## PHASE 1: Customer Onboarding (RM)

**Actor**: Relationship Manager (RM)
**Location**: RM Portal
**Example RM**: Rajesh Kumar (RM001)

```
═══════════════════════════════════════════════════════════════════
                    RM WORKFLOW - CUSTOMER ONBOARDING
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ STEP 1: RM Login                                                │
└─────────────────────────────────────────────────────────────────┘

RM Portal (https://gba.bank.com/rm)
  │
  ├─► Enter Credentials:
  │   Username: rajesh.kumar@bank.com
  │   Password: ********
  │   2FA Code: 123456
  │
  └─► Login Successful
       │
       └─► Redirected to RM Dashboard

       ┌─────────────────────────────────────────────────┐
       │          RM DASHBOARD                           │
       ├─────────────────────────────────────────────────┤
       │ Active Customers: 45                            │
       │ Goals In Progress: 12                           │
       │ Pending Assessments: 3                          │
       │ Portfolio Recommendations Pending: 2            │
       │                                                 │
       │ [+ Create New Customer]                         │
       └─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ STEP 2: Create New Customer                                     │
└─────────────────────────────────────────────────────────────────┘

Dashboard > Customers > Create New Customer
  │
  ├─► Basic Information:
  │
  │   ┌─────────────────────────────────────────────────┐
  │   │ First Name:        Priya                        │
  │   │ Last Name:         Sharma                       │
  │   │ Date of Birth:     15-Mar-1988 (Age: 37)        │
  │   │ Gender:            Female                       │
  │   │ Email:             priya.sharma@email.com       │
  │   │ Mobile:            +91 98765 43210              │
  │   │ PAN:               ABCDE1234F                   │
  │   └─────────────────────────────────────────────────┘
  │
  ├─► Address Information:
  │
  │   ┌─────────────────────────────────────────────────┐
  │   │ Address Line 1:    Flat 301, Sunrise Apartments│
  │   │ Address Line 2:    Linking Road, Bandra West   │
  │   │ City:              Mumbai                       │
  │   │ State:             Maharashtra                  │
  │   │ PIN Code:          400050                       │
  │   └─────────────────────────────────────────────────┘
  │
  │   ⚠️ WORKFLOW CHANGE: NO KYC REQUIRED
  │   KYC is pre-verified or handled outside this workflow.
  │   RM collects ONLY basic customer details shown above.
  │
  └─► Click "Create Customer"
       │
       ├─► Customer ID generated: CUS046
       ├─► Journey created: JOURNEY_CUS046_001
       └─► ✅ Customer created successfully

       Customer Details:
       ┌─────────────────────────────────────────────────┐
       │ Customer ID:   CUS046                           │
       │ Name:          Priya Sharma                     │
       │ Status:        ACTIVE                           │
       │ RM:            Rajesh Kumar (RM001)             │
       │ Created:       24-Dec-2024 10:30 AM             │
       │                                                 │
       │ Journey Status: CUSTOMER_CREATED ✅             │
       │ Next Step:      Create Goal                     │
       └─────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════
```

---

## PHASE 2: Goal Creation (RM)

**Actor**: Relationship Manager
**Customer**: Priya Sharma (CUS046)

```
═══════════════════════════════════════════════════════════════════
                    GOAL CREATION WORKFLOW
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ STEP 3: Create Financial Goal                                   │
└─────────────────────────────────────────────────────────────────┘

Customer Profile > Goals > Create New Goal
  │
  ├─► Goal Details:
  │
  │   ┌─────────────────────────────────────────────────┐
  │   │ Goal Name:         Child Education Fund         │
  │   │ Goal Category:     EDUCATION                    │
  │   │ Goal Type:         Child's Higher Education     │
  │   │                                                 │
  │   │ Target Amount:     ₹50,00,000                   │
  │   │ Current Age of Child: 8 years                   │
  │   │ Goal Timeline:     10 years                     │
  │   │ Target Date:       31-Dec-2034                  │
  │   │                                                 │
  │   │ Priority:          HIGH                         │
  │   │ Description:       MBA from top university      │
  │   │                    in India (IIM/ISB)           │
  │   └─────────────────────────────────────────────────┘
  │
  ├─► Current Investments (Optional):
  │
  │   ┌─────────────────────────────────────────────────┐
  │   │ Existing Amount:   ₹2,00,000                    │
  │   │ Monthly SIP:       ₹10,000                      │
  │   │ (Can be updated after financial calculator)    │
  │   └─────────────────────────────────────────────────┘
  │
  └─► Click "Create Goal"
       │
       ├─► Goal ID generated: GOAL_001_CUS046
       └─► ✅ Goal created successfully

       ┌─────────────────────────────────────────────────┐
       │ JOURNEY UPDATED                                 │
       ├─────────────────────────────────────────────────┤
       │ ✅ Customer Created                             │
       │ ✅ Goal Created                                 │
       │ ⏳ Risk Profile Assessment (PENDING)            │
       │ ⏳ Suitability Assessment (PENDING)             │
       │ ⏳ Financial Calculator (PENDING)               │
       │ ⏳ Portfolio Recommendation (PENDING)           │
       └─────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════
```

---

## PHASE 3: Risk Profile Assessment (RM + Customer)

**Actor**: RM conducts assessment with Customer
**Method**: Face-to-face or video call
**Duration**: 5-7 minutes (optimized from 10-15 minutes)
**Questions**: TOP 8 QUESTIONS ONLY (reduced from 15)
**Scoring**: 1-52 points (updated from 8-35)

```
═══════════════════════════════════════════════════════════════════
                  RISK PROFILE ASSESSMENT FLOW
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ STEP 4: Start Risk Profile Assessment                           │
└─────────────────────────────────────────────────────────────────┘

Goal Details > Assessments > Start Risk Profile Assessment
  │
  ├─► Assessment initiated for: Priya Sharma (CUS046)
  ├─► Goal: Child Education Fund (GOAL_001_CUS046)
  ├─► Assessment ID: RISK_ASSESS_001
  │
  └─► RM asks TOP 8 QUESTIONS to customer:
       ⚠️ OPTIMIZED FROM 15 TO 8 QUESTIONS

┌─────────────────────────────────────────────────────────────────┐
│ Question 1/8: Age Group (Weight: 1.0)                           │
├─────────────────────────────────────────────────────────────────┤
│ What is your current age?                                       │
│                                                                 │
│ Options:                                                        │
│ ○ Under 25 years (4 points)                                    │
│ ○ 25-35 years (4 points)                                       │
│ ● 36-45 years (3 points) ← SELECTED                            │
│ ○ 46-55 years (2 points)                                       │
│ ○ 56-65 years (1 point)                                        │
│ ○ Over 65 years (0 points)                                     │
│                                                                 │
│ Weight: 1.0                                                     │
│ Points Earned: 3 × 1.0 = 3.0                                    │
│                                                                 │
│ RM Notes: Priya is 37 years old, in prime earning years        │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ Question 2/8: Investment Time Horizon ⭐ MOST CRITICAL          │
├─────────────────────────────────────────────────────────────────┤
│ When do you expect to need the money you are investing?        │
│                                                                 │
│ Options:                                                        │
│ ○ Less than 1 year (0 points)                                  │
│ ○ 1-3 years (1 point)                                          │
│ ○ 3-5 years (2 points)                                         │
│ ○ 5-10 years (3 points)                                        │
│ ● 10-20 years (4 points) ← SELECTED                            │
│ ○ More than 20 years (4 points)                                │
│                                                                 │
│ Weight: 1.5 (HIGH WEIGHT - critical factor)                     │
│ Points Earned: 4 × 1.5 = 6.0                                    │
│                                                                 │
│ RM Notes: Goal is 10 years away (2034) - allows equity exposure│
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ Question 3/8: Primary Investment Objective (Multi-Select)       │
├─────────────────────────────────────────────────────────────────┤
│ What are your primary investment objectives? (Select all)      │
│                                                                 │
│ Options:                                    Max Cap: 8 points   │
│ ☐ Capital preservation (0 points)                              │
│ ☐ Regular income generation (1 point)                          │
│ ☑ Long-term wealth accumulation (3 points) ← SELECTED          │
│ ☑ Tax savings (2 points) ← SELECTED                            │
│ ☐ Aggressive capital growth (4 points)                         │
│ ☐ Balanced growth and income (2 points)                        │
│                                                                 │
│ Total Points: 3 + 2 = 5                                         │
│ Capped at: 5 (within 8-point cap)                              │
│ Weight: 1.0                                                     │
│ Points Earned: 5 × 1.0 = 5.0                                    │
└─────────────────────────────────────────────────────────────────┘

... (Questions 4-6 asked similarly)
    Q4: Emergency Fund (Weight: 1.5) ⭐ CRITICAL FOR RISK CAPACITY
    Q5: Years Experience (Weight: 1.0)
    Q6: Max Loss Tolerance (Weight: 2.0) ⭐ KEY RISK METRIC

┌─────────────────────────────────────────────────────────────────┐
│ Question 7/8: Market Downturn Response ⭐ BEST BEHAVIORAL PREDICTOR │
├─────────────────────────────────────────────────────────────────┤
│ If your portfolio declined 20% in 3 months due to market       │
│ conditions, what would you most likely do?                     │
│                                                                 │
│ Options:                                                        │
│ ○ Sell everything immediately (0 points)                       │
│ ○ Sell some investments to reduce risk (0 points)              │
│ ● Hold all investments and wait for recovery (2 points) ←      │
│ ○ Hold and possibly invest more if funds available (4 points)  │
│ ○ Definitely buy more - downturns are opportunities (4 points) │
│                                                                 │
│ Weight: 2.0 (HIGHEST WEIGHT - behavioral predictor)            │
│ Points Earned: 2 × 2.0 = 4.0                                    │
│                                                                 │
│ RM Notes: Priya shows moderate risk tolerance - will hold      │
│ during downturns but may not buy more. Good behavioral sign.   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ Question 8/8: Recovery Time Comfort ⭐ TIME-RISK ALIGNMENT      │
├─────────────────────────────────────────────────────────────────┤
│ If your portfolio lost value, how long are you willing to wait │
│ for it to recover?                                              │
│                                                                 │
│ Options:                                                        │
│ ○ Less than 6 months (0 points)                                │
│ ○ 6-12 months (1 point)                                        │
│ ● 1-2 years (2 points) ← SELECTED                              │
│ ○ 3-4 years (3 points)                                         │
│ ○ 5+ years - I invest for the long term (4 points)             │
│                                                                 │
│ Weight: 2.0 (TIME-RISK ALIGNMENT)                              │
│ Points Earned: 2 × 2.0 = 4.0                                    │
│                                                                 │
│ RM Notes: Aligns with 10-12 year goal timeline                 │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ ASSESSMENT COMPLETE - CALCULATING RISK SCORE                   │
└─────────────────────────────────────────────────────────────────┘

Calculation Details (TOP 8 QUESTIONS):
┌────────────────────────────────────────────────────────────────┐
│ Question  │ Description            │ Points │ Weight │ Score   │
├────────────────────────────────────────────────────────────────┤
│ Q1        │ Age Group              │   3    │  1.0   │  3.0    │
│ Q2        │ Time Horizon           │   4    │  1.5   │  6.0    │
│ Q3        │ Primary Objective      │   5    │  1.0   │  5.0    │
│ Q4        │ Emergency Fund         │   3    │  1.5   │  4.5    │
│ Q5        │ Years Experience       │   2    │  1.0   │  2.0    │
│ Q6        │ Max Loss Tolerance     │   2    │  2.0   │  4.0    │
│ Q7        │ Downturn Response      │   2    │  2.0   │  4.0    │
│ Q8        │ Recovery Time Comfort  │   2    │  2.0   │  4.0    │
├────────────────────────────────────────────────────────────────┤
│ TOTAL WEIGHTED SCORE                                │   32.5   │
│ ROUNDED SCORE                                       │   33     │
└────────────────────────────────────────────────────────────────┘

Risk Score: 33 / 52 (NEW SCORING RANGE: 1-52)
⚠️ Previous scoring: 24/35 → New scoring: 33/52

┌─────────────────────────────────────────────────────────────────┐
│               RISK PROFILE ASSESSMENT RESULT                    │
├─────────────────────────────────────────────────────────────────┤
│ Customer:          Priya Sharma (CUS046)                        │
│ Assessment Date:   24-Dec-2024 11:07 AM (7 minutes)             │
│ Conducted By:      Rajesh Kumar (RM001)                         │
│                                                                 │
│ Total Risk Score:  33 / 52 (62.5%)                              │
│                                                                 │
│ Risk Category:     BALANCE (27-34 score range)                 │
│                                                                 │
│ Recommended Asset Allocation:                                  │
│ ├─ Equity:         60%                                          │
│ └─ Debt:           40%                                          │
│                                                                 │
│ Profile Summary:                                                │
│ • Moderate to high risk tolerance                              │
│ • 10-year investment horizon (suitable for equity)             │
│ • Behavioral resilience: Will hold during downturns            │
│ • Suitable for balanced growth portfolios                      │
│                                                                 │
│ ⚠️ Note: Final allocation subject to Suitability Assessment    │
│                                                                 │
│ [View Detailed Report] [Continue to Suitability Assessment]    │
└─────────────────────────────────────────────────────────────────┘

       ┌─────────────────────────────────────────────────┐
       │ JOURNEY UPDATED                                 │
       ├─────────────────────────────────────────────────┤
       │ ✅ Customer Created                             │
       │ ✅ Goal Created                                 │
       │ ✅ Risk Profile Assessment (Score: 33/BALANCE)  │
       │    (TOP 8 QUESTIONS, 1-52 scoring)              │
       │ ⏳ Suitability Assessment (PENDING)             │
       │ ⏳ Financial Calculator (PENDING)               │
       │ ⏳ Portfolio Recommendation (PENDING)           │
       └─────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════
```

---

## PHASE 4: Suitability Assessment (RM + Customer)

**Actor**: RM conducts comprehensive assessment
**Regulatory**: MiFID II, FINRA, SEBI compliant (FULL COMPLIANCE MAINTAINED)
**Duration**: 7-10 minutes (optimized from 15-20 minutes)
**Questions**: TOP 8 QUESTIONS ONLY (reduced from 32)
**Approach**: Multi-dimensional MIN score (Risk Capacity, Knowledge, Experience, Objective)

```
═══════════════════════════════════════════════════════════════════
                  SUITABILITY ASSESSMENT FLOW
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ STEP 5: Start Suitability Assessment                            │
└─────────────────────────────────────────────────────────────────┘

Risk Profile Complete > Continue to Suitability Assessment
  │
  ├─► Assessment Type: Comprehensive Suitability (32 Questions)
  ├─► Regulatory: MiFID II Article 25(2) compliant
  ├─► Assessment ID: SUIT_ASSESS_001
  │
  └─► RM conducts assessment:

┌─────────────────────────────────────────────────────────────────┐
│ CATEGORY 1: PERSONAL & PROFESSIONAL INFORMATION (Q1-Q4)        │
└─────────────────────────────────────────────────────────────────┘

Q1: Age Group → 36-45 years (AGE_36_45)
Q2: Education Level → Bachelor's degree (BACHELOR)
Q3: Employment Status → Employed full-time, stable income (EMPLOYED_STABLE)
Q4: Number of Dependents → 1-2 dependents (ONE_TWO) [Spouse + 1 child]

┌─────────────────────────────────────────────────────────────────┐
│ CATEGORY 2: FINANCIAL SITUATION (Q5-Q11) - MANDATORY           │
└─────────────────────────────────────────────────────────────────┘

Q5: Annual Gross Income → ₹12,00,000 - ₹25,00,000 (12L_25L)
    RM Notes: Verified through salary slips

Q6: Total Net Worth → ₹50,00,000 - ₹1,00,00,000 (50L_1CR)
    Breakdown: Home (₹80L) - Loan (₹40L) + Savings (₹10L) = ₹50L net

Q7: Investable Assets % → 25-50% of net worth (25_50)
    Available for investment: ~₹15-20 Lakhs

Q8: Monthly Surplus → ₹15,000 - ₹50,000/month (15K_50K)
    After all expenses: ₹25,000/month available

Q9: Outstanding Liabilities → ₹25,00,000 - ₹50,00,000 (25L_50L)
    Home loan: ₹40L (EMI: ₹35,000/month)
    Debt-to-Income Ratio: 35% (Healthy ✅)

Q10: Insurance Coverage (Multi-Select) → SELECTED:
     ☑ Life insurance (Term plan - ₹1 Cr cover) ✅
     ☑ Health insurance (₹10L family floater) ✅
     ☐ Critical illness insurance
     ☐ Disability insurance

     Status: ✅ ADEQUATE INSURANCE

Q11: Emergency Fund Status → Yes, 3-6 months covered (YES_PARTIAL)
     Emergency Fund: ₹2L in liquid funds
     Status: ✅ ADEQUATE (meets minimum requirement)

┌─────────────────────────────────────────────────────────────────┐
│ CATEGORY 3: INVESTMENT EXPERIENCE (Q12-Q17)                     │
└─────────────────────────────────────────────────────────────────┘

Q12: Years of Experience → 3-5 years (3_5_YEARS)
     RM Notes: Started investing in 2019

Q13: Product Experience (Multi-Select) → SELECTED:
     ☑ Savings account / Fixed deposits
     ☑ Government bonds / Debt mutual funds
     ☑ Diversified equity mutual funds ← Has equity experience
     ☐ Direct equity stocks
     ☐ Sectoral/Thematic funds
     ☑ International funds / Gold

     Experience Level: INTERMEDIATE

Q14: Investment Frequency → Quarterly (3-4 times per year) (QUARTERLY)
     Good alignment with goal-based approach ✅

Q15: Largest Single Investment → ₹2,00,000 - ₹10,00,000 (2L_10L)
     Previous investment: ₹5L in equity fund lump sum

Q16: Typical Holding Period → 1-3 years (1_3_YEARS)
     RM Notes: Decent holding period, suitable for medium-term

Q17: Past Performance Experience → Yes, held investments without selling
     (LOSS_HELD)
     RM Notes: ✅ EXCELLENT - During 2020 COVID crash, Priya held her
     investments and did not panic sell. Strong behavioral indicator.

┌─────────────────────────────────────────────────────────────────┐
│ CATEGORY 4: INVESTMENT KNOWLEDGE - QUIZ (Q18-Q25)              │
└─────────────────────────────────────────────────────────────────┘

Q18: Self-Assessment → Moderate knowledge (MODERATE)

KNOWLEDGE QUIZ (7 Questions):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Q19: Risk-Return Relationship
     Answer: Option C ✅ CORRECT (1 point)

Q20: Diversification Concept
     Answer: Option C ✅ CORRECT (1 point)

Q21: Equity Investment Understanding
     Answer: Option B ✅ CORRECT (1 point)

Q22: Mutual Fund Concept
     Answer: Option B ✅ CORRECT (1 point)

Q23: Inflation Impact
     Answer: Option A ❌ INCORRECT (0 points)
     Correct Answer: Option B (Real return is negative)

Q24: Time Horizon and Risk
     Answer: Option B ✅ CORRECT (1 point)

Q25: Liquidity Understanding
     Answer: Option C ✅ CORRECT (1 point)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quiz Score: 6/7 (85.7%) ✅ GOOD KNOWLEDGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Validated Knowledge Level: GOOD (matches self-assessment)

┌─────────────────────────────────────────────────────────────────┐
│ CATEGORY 5: INVESTMENT OBJECTIVES (Q26-Q32)                     │
└─────────────────────────────────────────────────────────────────┘

Q26: Primary Investment Objective → Balanced growth and income (BALANCED)

Q27: Investment Time Horizon → 5-10 years (5_10_YEARS)
     Consistent with goal timeline ✅

Q28: Expected Return → 11-14% per annum (11_14_PCT)
     Realistic expectation ✅

Q29: Withdrawal Needs → Occasional withdrawals (1-2 times) (OCCASIONAL)
     RM Notes: May need small withdrawal after 5 years for partial education expenses

Q30: ESG Preference → Neutral, no strong preference (NEUTRAL)

Q31: Loss Tolerance → Up to 20% decline (20_PCT)
     Consistent with past behavior (held during 20% COVID crash) ✅

Q32: Monitoring Preference → Quarterly updates (QUARTERLY)
     Recommended frequency ✅

┌─────────────────────────────────────────────────────────────────┐
│ SUITABILITY ASSESSMENT COMPLETE - CALCULATING RESULT            │
└─────────────────────────────────────────────────────────────────┘

Multi-Dimensional Analysis:
┌────────────────────────────────────────────────────────────┐
│ DIMENSION 1: RISK CAPACITY (Financial Ability)            │
├────────────────────────────────────────────────────────────┤
│ Annual Income:        ₹12-25L (Moderate)                  │
│ Net Worth:            ₹50L-1Cr (Moderate)                 │
│ Investable Assets:    25-50% (Good)                       │
│ Monthly Surplus:      ₹15-50K (Moderate)                  │
│ Debt-to-Income:       35% (Healthy ✅)                    │
│ Insurance:            Adequate ✅                         │
│ Emergency Fund:       3-6 months ✅                       │
│                                                            │
│ Risk Capacity Level:  4/5 (HIGH) ✅                       │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ DIMENSION 2: INVESTMENT KNOWLEDGE                          │
├────────────────────────────────────────────────────────────┤
│ Self-Assessment:      Moderate                             │
│ Quiz Score:           6/7 (85.7%)                          │
│ Validated Level:      GOOD ✅                             │
│                                                            │
│ Knowledge Score:      4/5 (GOOD) ✅                       │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ DIMENSION 3: INVESTMENT EXPERIENCE                         │
├────────────────────────────────────────────────────────────┤
│ Years of Experience:  3-5 years (Intermediate)             │
│ Product Familiarity:  Equity MFs, Debt, Gold              │
│ Holding Period:       1-3 years (Moderate)                │
│ Past Behavior:        Held during crash ✅ EXCELLENT      │
│                                                            │
│ Experience Score:     4/5 (EXPERIENCED) ✅                │
└────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│ DIMENSION 4: OBJECTIVE ALIGNMENT                           │
├────────────────────────────────────────────────────────────┤
│ Primary Objective:    Balanced growth and income           │
│ Time Horizon:         5-10 years ✅                       │
│ Return Expectation:   11-14% (Realistic ✅)               │
│ Loss Tolerance:       Up to 20% decline                    │
│                                                            │
│ Alignment Check:      CONSISTENT ✅                       │
│ Objective Score:      4/5 (MODERATE-AGGRESSIVE) ✅        │
└────────────────────────────────────────────────────────────┘

FINAL SUITABILITY DETERMINATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Final Suitability = MIN(Risk Capacity, Knowledge, Experience, Objective)
                  = MIN(4, 4, 4, 4)
                  = 4 → MODERATE TO AGGRESSIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌─────────────────────────────────────────────────────────────────┐
│            SUITABILITY ASSESSMENT RESULT                        │
├─────────────────────────────────────────────────────────────────┤
│ Customer:              Priya Sharma (CUS046)                    │
│ Assessment Date:       24-Dec-2024 11:45 AM                     │
│ Assessment ID:         SUIT_ASSESS_001                          │
│                                                                 │
│ SUITABILITY CATEGORY:  MODERATE ✅                              │
│                                                                 │
│ Multi-Dimensional Scores:                                      │
│ ├─ Risk Capacity:      4/5 (High)                              │
│ ├─ Knowledge:          4/5 (Good)                              │
│ ├─ Experience:         4/5 (Experienced)                       │
│ └─ Objective Alignment:4/5 (Moderate-Aggressive)               │
│                                                                 │
│ Suitable Products:                                             │
│ ✅ Diversified equity mutual funds (Large-cap, Flexi-cap)      │
│ ✅ Balanced/Hybrid funds (40-60% equity)                       │
│ ✅ Debt funds (all categories)                                 │
│ ✅ Index funds (Nifty 50, Sensex)                              │
│ ✅ Gold ETFs (up to 5% allocation)                             │
│                                                                 │
│ NOT Suitable:                                                  │
│ ❌ Sectoral/thematic funds (concentration risk)                │
│ ❌ Small-cap funds (too high volatility for moderate category) │
│ ❌ Direct equity (needs more experience)                       │
│ ❌ Derivatives, structured products                            │
│                                                                 │
│ Recommended Asset Allocation Range:                            │
│ ├─ Equity:             40-60%                                  │
│ ├─ Debt:               40-60%                                  │
│ └─ Gold/Commodities:   0-5%                                    │
│                                                                 │
│ Regulatory Compliance:                                         │
│ ✅ MiFID II Article 25(2) - Complete                           │
│ ✅ FINRA Rule 2111 - Suitability confirmed                     │
│ ✅ SEBI IA Regulations - Client profiling done                 │
│                                                                 │
│ [Generate PDF Report] [Continue to Financial Calculator]       │
└─────────────────────────────────────────────────────────────────┘

       ┌─────────────────────────────────────────────────┐
       │ JOURNEY UPDATED                                 │
       ├─────────────────────────────────────────────────┤
       │ ✅ Customer Created                             │
       │ ✅ Goal Created                                 │
       │ ✅ Risk Profile (Score: 24/BALANCE)             │
       │ ✅ Suitability Assessment (MODERATE)            │
       │ ⏳ Financial Calculator (PENDING)               │
       │ ⏳ Portfolio Recommendation (PENDING)           │
       └─────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════
```

---

## PHASE 5: Financial Calculator (RM + Customer)

**Actor**: RM with Customer
**Purpose**: Calculate corpus needed and required return
**Method**: Newton-Raphson iterative algorithm

```
═══════════════════════════════════════════════════════════════════
                  FINANCIAL CALCULATOR FLOW
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ STEP 6: Financial Calculator - Corpus Calculation               │
└─────────────────────────────────────────────────────────────────┘

Suitability Complete > Continue to Financial Calculator
  │
  ├─► Goal: Child Education Fund (GOAL_001_CUS046)
  ├─► Calculator ID: FIN_CALC_001
  │
  └─► Input Parameters:

┌─────────────────────────────────────────────────────────────────┐
│              FINANCIAL CALCULATOR - INPUTS                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ GOAL DETAILS (Pre-filled):                                     │
│ ├─ Goal Name:          Child Education Fund                    │
│ ├─ Target Amount:      ₹50,00,000                              │
│ ├─ Time Horizon:       10 years                                │
│ └─ Target Date:        31-Dec-2034                             │
│                                                                 │
│ INFLATION ASSUMPTIONS:                                         │
│ ├─ Education Inflation Rate: 8% per annum                      │
│ │   (Higher than general inflation of 6%)                     │
│ └─ Rationale: Education costs rise faster than general prices  │
│                                                                 │
│ CURRENT INVESTMENTS:                                           │
│ ├─ Existing Amount:    ₹2,00,000                              │
│ │   (Already invested in PPF)                                 │
│ └─ Monthly SIP:        To be calculated                        │
│                                                                 │
│ [Calculate Future Value & Required Return]                     │
└─────────────────────────────────────────────────────────────────┘

STEP 1: Calculate Inflation-Adjusted Corpus
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Formula: Future Value = Present Value × (1 + Inflation Rate)^Years

Calculation:
FV = ₹50,00,000 × (1 + 0.08)^10
FV = ₹50,00,000 × 2.1589
FV = ₹1,07,94,627

Rounded: ₹1,08,00,000 (inflation-adjusted target)

┌─────────────────────────────────────────────────────────────────┐
│ INFLATION-ADJUSTED CORPUS                                       │
├─────────────────────────────────────────────────────────────────┤
│ Today's Value:         ₹50,00,000                               │
│ Inflation Rate:        8% per annum (education inflation)       │
│ Time Period:           10 years                                 │
│                                                                 │
│ Future Value Needed:   ₹1,08,00,000 ✅                         │
│                                                                 │
│ Explanation:                                                    │
│ Due to 8% annual education inflation, ₹50 lakhs worth of       │
│ education today will cost ₹1.08 Crores in 10 years.            │
└─────────────────────────────────────────────────────────────────┘

STEP 2: Calculate Required Return (Newton-Raphson Method)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Input Parameters:
├─ Target Corpus:        ₹1,08,00,000
├─ Existing Investment:  ₹2,00,000
├─ Monthly SIP:          ₹20,000 (assumed for calculation)
├─ Time Period:          10 years (120 months)
└─ Required Return:      ? (to be calculated)

Algorithm: Newton-Raphson Iterative Method
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Iteration 1:
  Initial Guess: r = 10% (0.10)
  FV = ₹2,00,000 × (1.10)^10 + ₹20,000 × [((1 + 0.10/12)^120 - 1) / (0.10/12)]
  FV = ₹5,18,748 + ₹41,17,428 = ₹46,36,176
  Error = ₹1,08,00,000 - ₹46,36,176 = ₹61,63,824
  Derivative calculation...
  New r = 0.1245

Iteration 2:
  r = 12.45%
  FV = ₹6,47,832 + ₹49,82,345 = ₹56,30,177
  Error = ₹51,69,823
  New r = 0.1398

Iteration 3:
  r = 13.98%
  FV = ₹7,92,145 + ₹58,95,234 = ₹66,87,379
  Error = ₹41,12,621
  New r = 0.1512

... (iterations continue)

Iteration 12:
  r = 15.25%
  FV = ₹1,07,98,432
  Error = ₹1,568 (within tolerance of ₹10,000)

CONVERGED ✅

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Required Annual Return: 15.25%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌─────────────────────────────────────────────────────────────────┐
│           FINANCIAL CALCULATOR - FINAL RESULT                   │
├─────────────────────────────────────────────────────────────────┤
│ Goal:                  Child Education Fund                     │
│ Target Corpus (Today): ₹50,00,000                              │
│                                                                 │
│ INFLATION-ADJUSTED CORPUS:                                     │
│ ├─ Future Value Needed:    ₹1,08,00,000                        │
│ ├─ Inflation Rate:          8% per annum                       │
│ └─ Time Period:             10 years                           │
│                                                                 │
│ INVESTMENT PLAN:                                               │
│ ├─ Existing Investment:     ₹2,00,000                          │
│ ├─ Recommended Monthly SIP: ₹20,000                            │
│ └─ Total Investment:        ₹26,00,000                         │
│     (₹2L existing + ₹24L SIP over 10 years)                   │
│                                                                 │
│ REQUIRED RETURN:            15.25% per annum ⚠️                │
│                                                                 │
│ PROJECTED OUTCOME (at 15.25% return):                          │
│ ├─ Final Corpus:            ₹1,08,00,000                       │
│ └─ Total Gains:             ₹82,00,000                         │
│                                                                 │
│ ⚠️ IMPORTANT NOTES:                                            │
│ • Required return of 15.25% is AGGRESSIVE                      │
│ • Historical equity returns: 11-13% CAGR                       │
│ • This return requires HIGH EQUITY allocation (80-95%)         │
│ • May need to adjust SIP amount or time horizon                │
│                                                                 │
│ [Adjust Parameters] [View Alternative Scenarios] [Continue]    │
└─────────────────────────────────────────────────────────────────┘

RM REVIEW:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RM Analysis:
⚠️ CONCERN: Required return of 15.25% is higher than typical
   balanced portfolio returns (10-12%)

Options presented to customer:

Option 1: Increase Monthly SIP
  ├─ Increase SIP to ₹25,000/month
  ├─ Required Return: 13.8% (more achievable)
  └─ Portfolio: Aggressive (80% equity)

Option 2: Extend Time Horizon (Recommended)
  ├─ Extend goal by 2 years (child takes education at 20 instead of 18)
  ├─ New timeline: 12 years
  ├─ Required Return: 12.5% (achievable with balanced portfolio)
  └─ Portfolio: Balance (60% equity)

Option 3: Increase Initial Investment
  ├─ Add ₹3,00,000 lump sum now
  ├─ Total initial: ₹5,00,000
  ├─ Required Return: 13.2%
  └─ Portfolio: Aggressive (70-80% equity)

Customer Decision: Option 2 (Extend by 2 years) ✅

Recalculation with 12-year timeline:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Target Corpus: ₹1,28,00,000 (with 2 more years of inflation)
Time Period: 12 years
Monthly SIP: ₹20,000
Existing: ₹2,00,000

Required Return: 12.25% per annum ✅ ACHIEVABLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

       ┌─────────────────────────────────────────────────┐
       │ FINANCIAL CALCULATOR - FINAL APPROVED           │
       ├─────────────────────────────────────────────────┤
       │ Target Corpus:          ₹1,28,00,000            │
       │ Time Horizon:           12 years                │
       │ Monthly SIP:            ₹20,000                 │
       │ Existing Investment:    ₹2,00,000               │
       │ Required Return:        12.25% per annum ✅     │
       │                                                 │
       │ This return is ACHIEVABLE with:                │
       │ - Balance Portfolio (60% equity / 40% debt)     │
       │ - Expected return range: 10.5-12.5%             │
       └─────────────────────────────────────────────────┘

       ┌─────────────────────────────────────────────────┐
       │ JOURNEY UPDATED                                 │
       ├─────────────────────────────────────────────────┤
       │ ✅ Customer Created                             │
       │ ✅ Goal Created (Updated: 12 years)             │
       │ ✅ Risk Profile (Score: 24/BALANCE)             │
       │ ✅ Suitability Assessment (MODERATE)            │
       │ ✅ Financial Calculator (Req Return: 12.25%)    │
       │ ⏳ Portfolio Recommendation (PENDING)           │
       └─────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════
```

---

## PHASE 6: Portfolio Matching & Recommendation (System + RM)

**Actor**: System (automated matching) + RM (review & presentation)
**Logic**: Three-filter approach

```
═══════════════════════════════════════════════════════════════════
              PORTFOLIO MATCHING & RECOMMENDATION FLOW
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ STEP 7: Automated Portfolio Matching (System)                   │
└─────────────────────────────────────────────────────────────────┘

Financial Calculator Complete > System Auto-Matches Portfolios

MATCHING ALGORITHM - THREE FILTERS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Filter 1: Risk Category Match
────────────────────────────────────────────────────────────────
Risk Profile Score: 24 → BALANCE category (22-26)

Eligible Portfolios:
├─ ✅ Income Portfolio (40% equity) - Risk Category: INCOME (17-21)
│      (One level below, acceptable)
├─ ✅ Balance Portfolio (60% equity) - Risk Category: BALANCE (22-26)
│      (Exact match)
└─ ✅ Aggressive Portfolio (80% equity) - Risk Category: AGGRESSIVE (27-31)
       (One level above, acceptable with suitability check)

Filter 2: Suitability Category Match
────────────────────────────────────────────────────────────────
Suitability Assessment: MODERATE

Eligible Portfolios:
├─ ✅ Income Portfolio - Suitability: MODERATE ✅
├─ ✅ Balance Portfolio - Suitability: MODERATE ✅
└─ ❌ Aggressive Portfolio - Suitability: AGGRESSIVE ❌
       REJECTED: Requires AGGRESSIVE suitability

After Filter 2:
├─ ✅ Income Portfolio (40% equity)
└─ ✅ Balance Portfolio (60% equity)

Filter 3: Required Return Match
────────────────────────────────────────────────────────────────
Required Return: 12.25% per annum

Portfolio Return Ranges:
├─ Income Portfolio:    9.0-11.0% expected return
│  └─ Max Return: 11.0% < Required 12.25% ❌ REJECT
└─ Balance Portfolio:   10.5-12.5% expected return
   └─ Max Return: 12.5% ≥ Required 12.25% ✅ MATCH

FINAL MATCHED PORTFOLIOS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ PRIMARY MATCH: Balance Portfolio (60% Equity / 40% Debt)
   ├─ Expected Return: 10.5-12.5% (meets 12.25% requirement)
   ├─ Risk Category: BALANCE (matches risk profile)
   ├─ Suitability: MODERATE (matches suitability)
   └─ Confidence Score: 95%

⚠️ ALTERNATIVE (if customer wants lower risk):
   Income Portfolio (40% Equity / 60% Debt)
   ├─ Expected Return: 9.0-11.0% (DOES NOT meet requirement)
   ├─ Requires: Increase SIP to ₹28,000 or extend timeline
   └─ Confidence Score: 60%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌─────────────────────────────────────────────────────────────────┐
│ STEP 8: RM Reviews & Prepares Recommendation                    │
└─────────────────────────────────────────────────────────────────┘

RM Portal > Goal Details > View Matched Portfolios

RM Review Screen:
┌─────────────────────────────────────────────────────────────────┐
│ PORTFOLIO MATCHING SUMMARY                                      │
├─────────────────────────────────────────────────────────────────┤
│ Customer:          Priya Sharma (CUS046)                        │
│ Goal:              Child Education Fund                         │
│ Required Return:   12.25% per annum                             │
│                                                                 │
│ SYSTEM RECOMMENDATION: ⭐ Balance Portfolio                     │
│                                                                 │
│ Matching Criteria:                                             │
│ ✅ Risk Profile:      BALANCE (Score: 24)                      │
│ ✅ Suitability:       MODERATE                                 │
│ ✅ Return Match:      10.5-12.5% (meets 12.25%)                │
│ ✅ Time Horizon:      12 years (suitable for 60% equity)       │
│ ✅ Behavioral:        Held during past downturn                │
│                                                                 │
│ Confidence Score:     95% ⭐⭐⭐⭐⭐                             │
│                                                                 │
│ [View Portfolio Details] [Customize] [Present to Customer]     │
└─────────────────────────────────────────────────────────────────┘

RM clicks "View Portfolio Details":

┌─────────────────────────────────────────────────────────────────┐
│          BALANCE PORTFOLIO - COMPLETE DETAILS                   │
├─────────────────────────────────────────────────────────────────┤
│ Portfolio Code:    BALANCE_001                                  │
│ Portfolio Name:    Balance Portfolio - Growth with Stability    │
│                                                                 │
│ ASSET ALLOCATION:                                              │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ EQUITY (60%)                                                ││
│ │ ├─ Large-Cap Equity: 22%                                    ││
│ │ ├─ Mid-Cap Equity:   15%                                    ││
│ │ ├─ Small-Cap Equity:  8%                                    ││
│ │ ├─ International:    10%                                    ││
│ │ └─ Gold ETF:          5%                                    ││
│ │                                                             ││
│ │ DEBT (40%)                                                  ││
│ │ ├─ Ultra Short Term:  8%                                    ││
│ │ ├─ Short Term Debt:  12%                                    ││
│ │ ├─ Medium Term Debt: 10%                                    ││
│ │ ├─ Corporate Bonds:   8%                                    ││
│ │ └─ Dynamic Bond:      2%                                    ││
│ └─────────────────────────────────────────────────────────────┘│
│                                                                 │
│ RECOMMENDED FUNDS (Examples):                                  │
│                                                                 │
│ EQUITY ALLOCATION (60%):                                       │
│ ├─ 12% → Axis Bluechip Fund (Large-cap)                       │
│ ├─ 10% → UTI Nifty 50 Index Fund (Large-cap index)            │
│ ├─ 15% → DSP Midcap Fund (Mid-cap)                            │
│ ├─  8% → Axis Small Cap Fund (Small-cap)                      │
│ ├─ 10% → Motilal Oswal S&P 500 Index Fund (International)     │
│ └─  5% → SBI Gold ETF (Gold)                                  │
│                                                                 │
│ DEBT ALLOCATION (40%):                                         │
│ ├─  8% → ICICI Pru Ultra Short Term Fund                      │
│ ├─ 12% → Kotak Bond Short Term Fund                           │
│ ├─ 10% → Aditya Birla SL Medium Term Fund                     │
│ ├─  8% → HDFC Corporate Bond Fund                             │
│ └─  2% → Nippon India Dynamic Bond Fund                       │
│                                                                 │
│ EXPECTED PERFORMANCE:                                          │
│ ├─ Expected Return:      10.5% - 12.5% per annum              │
│ ├─ Expected Volatility:  10% - 13%                            │
│ ├─ Maximum Drawdown:     -22% (during severe crashes)         │
│ ├─ Recovery Time:        12 months (historical average)       │
│ └─ Rebalancing:          Annual (March 31)                    │
│                                                                 │
│ HISTORICAL PERFORMANCE (Backtested 2014-2024):                 │
│ ├─ 10-Year CAGR:         12.2%                                 │
│ ├─ Best Year:            +25.1% (2017)                         │
│ ├─ Worst Year:           -3.2% (2020 COVID)                    │
│ └─ Sharpe Ratio:         1.9                                   │
│                                                                 │
│ SUITABLE FOR:                                                  │
│ ✅ Young professionals (30-40 years) with long-term goals      │
│ ✅ 7-10 year investment horizon                                │
│ ✅ Experienced investors comfortable with market cycles        │
│ ✅ Investors who stayed invested during past crashes           │
│                                                                 │
│ RISK WARNINGS:                                                 │
│ ⚠️ Portfolio can decline 20-22% during market crashes          │
│ ⚠️ Requires 12-month average recovery time                     │
│ ⚠️ Small-cap allocation (8%) adds volatility                   │
│ ⚠️ Not suitable for goals <5 years away                        │
│                                                                 │
│ [Customize Allocation] [Generate Presentation] [Approve]       │
└─────────────────────────────────────────────────────────────────┘

RM clicks "Generate Presentation" (for customer meeting):

┌─────────────────────────────────────────────────────────────────┐
│ STEP 9: RM Presents Recommendation to Customer                  │
└─────────────────────────────────────────────────────────────────┘

RM Office / Video Call
RM: Rajesh Kumar
Customer: Priya Sharma

RM Presentation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

"Dear Priya,

Based on our comprehensive assessment, I'm pleased to present our
investment recommendation for your Child Education Fund goal.

GOAL SUMMARY:
─────────────
• Objective: Child's higher education (MBA)
• Target Amount: ₹1.28 Crores (inflation-adjusted for 12 years)
• Monthly Investment: ₹20,000 SIP
• Existing Investment: ₹2 Lakhs
• Required Return: 12.25% per annum

YOUR PROFILE:
─────────────
• Risk Category: BALANCE (Score: 24/35)
• Suitability: MODERATE (Expert knowledge, experienced investor)
• Behavioral Strength: You held investments during 2020 crash ✅

RECOMMENDED PORTFOLIO: Balance Portfolio
─────────────────────────────────────────
• Asset Mix: 60% Equity / 40% Debt
• Expected Return: 10.5% - 12.5% per annum
• Volatility: Moderate (10-13%)
• Historical 10-year CAGR: 12.2% ✅

WHY THIS PORTFOLIO SUITS YOU:
──────────────────────────────
✅ Matches your risk profile (BALANCE)
✅ Meets required return (12.25% achievable within 10.5-12.5% range)
✅ 12-year horizon perfect for 60% equity allocation
✅ Diversified across large, mid, small cap + international
✅ 40% debt cushions volatility during downturns

FUND ALLOCATION:
────────────────
For your ₹20,000 monthly SIP, here's the breakdown:

EQUITY (₹12,000/month):
• ₹2,400 → Axis Bluechip Fund (Large-cap quality)
• ₹2,000 → UTI Nifty 50 Index (Low-cost core)
• ₹3,000 → DSP Midcap Fund (Growth potential)
• ₹1,600 → Axis Small Cap (Long-term wealth creation)
• ₹2,000 → Motilal Oswal S&P 500 (US market exposure)
• ₹1,000 → SBI Gold ETF (Portfolio stabilizer)

DEBT (₹8,000/month):
• ₹1,600 → ICICI Pru Ultra Short Term (Liquidity)
• ₹2,400 → Kotak Short Term Bond (Core debt)
• ₹2,000 → Aditya Birla Medium Term (Yield enhancement)
• ₹1,600 → HDFC Corporate Bond (Credit spread)
• ₹400  → Nippon Dynamic Bond (Duration management)

EXPECTED OUTCOME:
─────────────────
At 12.2% average return (historical backtested):
• Total Investment: ₹31 Lakhs (₹2L + ₹29L SIP)
• Expected Corpus: ₹1.32 Crores
• Total Gains: ₹1.01 Crores
• Goal Achievement: 103% ✅

IMPORTANT CONSIDERATIONS:
─────────────────────────
⚠️ This portfolio can decline 20-22% during market crashes
⚠️ Recovery typically takes 12 months
⚠️ Stay invested for full 12 years to benefit from compounding
⚠️ Annual rebalancing recommended (we'll handle this)

Do you have any questions?"

CUSTOMER QUESTIONS & RESPONSES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Customer Q1: "What if markets crash in year 8 or 9?"

RM: "Excellent question. This is where our 12-year timeline helps.
Historical data shows:
• 2020 COVID crash: -35% crash in March, recovered by September (6 months)
• 2008 financial crisis: -60% crash, recovered in 24 months

With 60% equity (not 100%), your maximum expected decline is -22%.
Even if crash happens in year 9, you have 3 years for recovery.

Additionally, our annual rebalancing ensures we book profits during
good years, which acts as a buffer during downturns."

Customer Q2: "Can I change the allocation later if I feel it's too risky?"

RM: "Yes, but let me explain the implications:

Option 1: Reduce to Income Portfolio (40% equity)
• Lower volatility (max -15% drawdown)
• BUT expected return drops to 9-11%
• You'd need to increase SIP to ₹28,000 to compensate

Option 2: Keep Balance Portfolio
• Moderate volatility (max -22% drawdown)
• Expected return 10.5-12.5% (meets your goal)
• Current SIP of ₹20,000 is sufficient

I recommend starting with Balance Portfolio. We'll review quarterly.
If you're uncomfortable with volatility in first year, we can adjust.

However, your past behavior during 2020 crash shows you can handle
this level of volatility. You held your investments - that's excellent!"

Customer: "Okay, I'm comfortable with the Balance Portfolio.
Let's proceed."

═══════════════════════════════════════════════════════════════════
```

---

## PHASE 7: Order Execution & Monitoring (RM + System)

**Actor**: RM initiates, System executes, Customer approves

```
═══════════════════════════════════════════════════════════════════
              ORDER EXECUTION & MONITORING FLOW
═══════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────────────────────────────┐
│ STEP 10: Generate Investment Proposal                           │
└─────────────────────────────────────────────────────────────────┘

RM Portal > Generate Investment Proposal Document

System generates PDF proposal with:
┌─────────────────────────────────────────────────────────────────┐
│        INVESTMENT PROPOSAL DOCUMENT                             │
│        (Regulatory Compliant - SEBI, MiFID II)                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ 1. Customer Profile Summary                                    │
│    • Risk Profile: BALANCE (Score: 24/35)                      │
│    • Suitability: MODERATE                                     │
│    • Financial Situation: Healthy (verified)                   │
│                                                                 │
│ 2. Goal Details                                                │
│    • Goal: Child Education Fund                                │
│    • Target: ₹1.28 Crores in 12 years                         │
│    • Monthly SIP: ₹20,000                                      │
│                                                                 │
│ 3. Recommended Portfolio: Balance Portfolio                    │
│    • Complete fund allocation (60% equity / 40% debt)          │
│    • Expected return: 10.5-12.5%                               │
│    • Risk disclosures (max drawdown, volatility)               │
│                                                                 │
│ 4. Risk Disclosures (MANDATORY)                                │
│    ⚠️ Past performance not indicative of future returns        │
│    ⚠️ Equity investments subject to market risks               │
│    ⚠️ No guaranteed returns or capital protection              │
│    ⚠️ Portfolio can decline 20-22% during crashes              │
│                                                                 │
│ 5. Regulatory Compliance Declarations                          │
│    ✅ MiFID II Article 25(2) suitability completed             │
│    ✅ FINRA Rule 2111 suitability confirmed                    │
│    ✅ SEBI IA Regulations client profiling done                │
│                                                                 │
│ 6. Customer Acknowledgment                                     │
│    □ I have read and understood the proposal                   │
│    □ I acknowledge the risk disclosures                        │
│    □ I agree to the recommended portfolio                      │
│    □ I authorize execution of investments                      │
│                                                                 │
│    Customer Signature: _________________ Date: __________      │
│    RM Signature: _______________________ Date: __________      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

✅ Proposal Generated: PROPOSAL_001_CUS046.pdf
📧 Sent to: priya.sharma@email.com

┌─────────────────────────────────────────────────────────────────┐
│ STEP 11: Customer Digital Approval (Customer Portal)            │
└─────────────────────────────────────────────────────────────────┘

Customer receives email notification:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

From: noreply@gba.bank.com
To: priya.sharma@email.com
Subject: Investment Proposal Ready for Approval - Child Education Fund

Dear Priya Sharma,

Your investment proposal for Child Education Fund is ready for review.

Goal: Child Education Fund
Target Corpus: ₹1.28 Crores
Monthly SIP: ₹20,000
Portfolio: Balance Portfolio (60% equity / 40% debt)

Please review and approve:
[View Proposal PDF] [Approve Online] [Request Changes]

Log in to Customer Portal: https://gba.bank.com/customer
Customer ID: CUS046
OTP will be sent to your registered mobile

Regards,
GBA System
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Customer clicks "Approve Online":

Customer Portal Login:
┌─────────────────────────────────────────────────────────────────┐
│              CUSTOMER PORTAL LOGIN                              │
├─────────────────────────────────────────────────────────────────┤
│ Customer ID:  CUS046                                            │
│ Mobile OTP:   [  ][  ][  ][  ][  ][  ]                         │
│                                                                 │
│ OTP sent to: +91 98765 43210                                    │
│ [Resend OTP] [Login]                                            │
└─────────────────────────────────────────────────────────────────┘

After Login:
┌─────────────────────────────────────────────────────────────────┐
│              CUSTOMER DASHBOARD                                 │
├─────────────────────────────────────────────────────────────────┤
│ Welcome, Priya Sharma                                           │
│                                                                 │
│ MY GOALS:                                                       │
│ ┌─────────────────────────────────────────────────────────────┐│
│ │ 🎓 Child Education Fund                                     ││
│ │    Target: ₹1.28 Cr | Timeline: 12 years                   ││
│ │    Status: ⏳ PENDING APPROVAL                              ││
│ │    [View Details] [Approve Now]                             ││
│ └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘

Customer clicks "Approve Now":

┌─────────────────────────────────────────────────────────────────┐
│         INVESTMENT PROPOSAL - APPROVAL SCREEN                   │
├─────────────────────────────────────────────────────────────────┤
│ Goal: Child Education Fund                                      │
│                                                                 │
│ INVESTMENT SUMMARY:                                            │
│ • Monthly SIP: ₹20,000                                         │
│ • Portfolio: Balance (60% equity / 40% debt)                   │
│ • Expected Return: 10.5-12.5% per annum                        │
│ • Expected Corpus: ₹1.32 Crores (at 12.2% return)             │
│                                                                 │
│ FUND ALLOCATION:                                               │
│ [View detailed fund list...]                                   │
│                                                                 │
│ RISK ACKNOWLEDGMENT:                                           │
│ ☑ I understand that equity investments are subject to market   │
│   risk and my portfolio value can fluctuate                    │
│ ☑ I acknowledge that past performance is not indicative of     │
│   future returns                                               │
│ ☑ I understand the maximum drawdown can be 20-22% during       │
│   market crashes                                               │
│ ☑ I have discussed this proposal with my RM and all my         │
│   questions have been answered                                 │
│                                                                 │
│ E-SIGNATURE:                                                   │
│ Enter OTP for e-signature: [  ][  ][  ][  ][  ][  ]           │
│                                                                 │
│ [Cancel] [APPROVE & START INVESTMENT]                          │
└─────────────────────────────────────────────────────────────────┘

Customer enters OTP and clicks "APPROVE & START INVESTMENT"

✅ Approval Recorded
✅ E-signature captured
✅ Timestamp: 24-Dec-2024 3:30 PM
✅ Order execution initiated

┌─────────────────────────────────────────────────────────────────┐
│ STEP 12: Automated Order Execution (System)                     │
└─────────────────────────────────────────────────────────────────┘

System auto-executes investment orders:

Order Execution Log:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[15:30:05] Order batch created: BATCH_001_CUS046
[15:30:06] Processing 11 fund purchase orders...

EQUITY ORDERS (₹12,000):
[15:30:10] ✅ Axis Bluechip Fund - ₹2,400 - Order ID: ORD_001
[15:30:12] ✅ UTI Nifty 50 Index - ₹2,000 - Order ID: ORD_002
[15:30:15] ✅ DSP Midcap Fund - ₹3,000 - Order ID: ORD_003
[15:30:18] ✅ Axis Small Cap - ₹1,600 - Order ID: ORD_004
[15:30:21] ✅ Motilal S&P 500 - ₹2,000 - Order ID: ORD_005
[15:30:24] ✅ SBI Gold ETF - ₹1,000 - Order ID: ORD_006

DEBT ORDERS (₹8,000):
[15:30:27] ✅ ICICI Ultra Short - ₹1,600 - Order ID: ORD_007
[15:30:30] ✅ Kotak Short Term - ₹2,400 - Order ID: ORD_008
[15:30:33] ✅ Aditya Birla Medium - ₹2,000 - Order ID: ORD_009
[15:30:36] ✅ HDFC Corporate Bond - ₹1,600 - Order ID: ORD_010
[15:30:39] ✅ Nippon Dynamic Bond - ₹400 - Order ID: ORD_011

[15:30:42] All orders placed successfully
[15:30:43] SIP mandate created for 1st of every month
[15:30:44] Auto-debit setup: Bank Account XXXX1234
[15:30:45] First SIP date: 1-Jan-2025

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ ORDER EXECUTION COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Notifications sent:
📧 Email to: priya.sharma@email.com
📱 SMS to: +91 98765 43210
🔔 RM notification: rajesh.kumar@bank.com

       ┌─────────────────────────────────────────────────┐
       │ JOURNEY COMPLETE ✅                             │
       ├─────────────────────────────────────────────────┤
       │ ✅ Customer Created                             │
       │ ✅ Goal Created                                 │
       │ ✅ Risk Profile Assessment                      │
       │ ✅ Suitability Assessment                       │
       │ ✅ Financial Calculator                         │
       │ ✅ Portfolio Recommended & Approved             │
       │ ✅ Orders Executed                              │
       │                                                 │
       │ Status: ACTIVE - INVESTMENT ONGOING             │
       └─────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════
```

---

## Complete Journey Summary Diagram

```
╔═══════════════════════════════════════════════════════════════════╗
║                   COMPLETE JOURNEY FLOW                           ║
║              (All Personas - Phase 1 Complete)                    ║
╚═══════════════════════════════════════════════════════════════════╝

┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 0: SYSTEM SETUP (Super Admin) - ONE TIME                     │
├─────────────────────────────────────────────────────────────────────┤
│ 1. Configure Risk Score Categories (6 categories)                  │
│ 2. Setup Risk Profile Questionnaire (15 questions)                 │
│ 3. Setup Suitability Assessment (32 questions)                     │
│ 4. Configure Model Portfolios (6 portfolios)                       │
│ 5. Create RM Users                                                 │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 1: CUSTOMER ONBOARDING (RM)                                  │
├─────────────────────────────────────────────────────────────────────┤
│ RM logs in → Create Customer (CUS046 - Priya Sharma)               │
│ Journey Status: ✅ Customer Created                                │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 2: GOAL CREATION (RM)                                        │
├─────────────────────────────────────────────────────────────────────┤
│ Create Goal: Child Education Fund                                  │
│ • Target: ₹50L → ₹1.28Cr (inflation-adjusted)                     │
│ • Timeline: 12 years                                               │
│ Journey Status: ✅ Customer + ✅ Goal                              │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 3: RISK PROFILE ASSESSMENT (RM + Customer)                   │
├─────────────────────────────────────────────────────────────────────┤
│ 15 Questions → Risk Score: 24/35 → Category: BALANCE               │
│ Recommended Allocation: 60% Equity / 40% Debt                      │
│ Journey Status: ✅ Customer + ✅ Goal + ✅ Risk Profile            │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 4: SUITABILITY ASSESSMENT (RM + Customer)                    │
├─────────────────────────────────────────────────────────────────────┤
│ 32 Questions (MiFID II compliant)                                  │
│ Multi-dimensional result: MODERATE                                 │
│ • Risk Capacity: 4/5 (High)                                        │
│ • Knowledge: 4/5 (Good - Quiz: 6/7)                                │
│ • Experience: 4/5 (Experienced - Held during crash ✅)             │
│ • Objective: 4/5 (Aligned)                                         │
│ Journey Status: ✅✅✅ + ✅ Suitability                            │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 5: FINANCIAL CALCULATOR (RM + Customer)                      │
├─────────────────────────────────────────────────────────────────────┤
│ Inflation-adjusted corpus: ₹1.28 Crores (8% education inflation)   │
│ Monthly SIP: ₹20,000                                               │
│ Newton-Raphson calculation: Required Return = 12.25%               │
│ Journey Status: ✅✅✅✅ + ✅ Financial Calculator                 │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 6: PORTFOLIO MATCHING (System + RM)                          │
├─────────────────────────────────────────────────────────────────────┤
│ THREE-FILTER MATCHING:                                             │
│ Filter 1: Risk Category (BALANCE) → ✅ Income, Balance             │
│ Filter 2: Suitability (MODERATE) → ✅ Income, Balance              │
│ Filter 3: Return (12.25%) → ✅ Balance Portfolio ONLY              │
│                                                                     │
│ MATCHED: Balance Portfolio (60% Eq / 40% Debt)                     │
│ Expected Return: 10.5-12.5% (meets 12.25% requirement) ✅          │
│ Journey Status: ✅✅✅✅✅ + ✅ Portfolio Matched                  │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 7: PRESENTATION & APPROVAL (RM → Customer → System)          │
├─────────────────────────────────────────────────────────────────────┤
│ 1. RM generates proposal PDF (regulatory compliant)                │
│ 2. Customer receives email notification                            │
│ 3. Customer logs into Customer Portal (OTP authentication)         │
│ 4. Customer reviews proposal                                       │
│ 5. Customer acknowledges risk disclosures                          │
│ 6. Customer provides e-signature (OTP-based)                       │
│ 7. ✅ APPROVED                                                     │
│ Journey Status: ✅✅✅✅✅✅ + ✅ Customer Approved                │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│ PHASE 8: ORDER EXECUTION (System - Automated)                      │
├─────────────────────────────────────────────────────────────────────┤
│ System executes 11 fund purchase orders:                           │
│ • 6 Equity/Gold orders (₹12,000)                                   │
│ • 5 Debt orders (₹8,000)                                           │
│ SIP mandate created: 1st of every month                            │
│ Auto-debit setup: Customer's bank account                          │
│ First SIP: 1-Jan-2025                                              │
│ Journey Status: ✅ ALL COMPLETE + ACTIVE INVESTMENT                │
└─────────────────────────────────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│ ONGOING: MONITORING & REBALANCING (System + RM)                    │
├─────────────────────────────────────────────────────────────────────┤
│ • Monthly SIP auto-debit: 1st of every month                       │
│ • Quarterly performance reports to customer                        │
│ • Annual rebalancing (March 31)                                    │
│ • RM annual review meetings                                        │
│ • Goal progress tracking dashboard                                 │
└─────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════
                    ✅ END-TO-END FLOW COMPLETE
═══════════════════════════════════════════════════════════════════════
```

---

## Document Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 24-Dec-2025 | Complete end-to-end flow for all personas (Super Admin, RM, Customer) | GBA Implementation Team |

---

**END OF DOCUMENT**
