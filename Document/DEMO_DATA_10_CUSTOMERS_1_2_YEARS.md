# Demo Data: 10 Customers with 1-2 Year Investment History

**Date**: January 8, 2026
**Purpose**: Realistic portfolio data for demo showcasing long-term investment growth
**Investment Period**: 12-24 months (2024-2025 to current date)

---

## Table of Contents

1. [Overview](#1-overview)
2. [Customer Selection Criteria](#2-customer-selection-criteria)
3. [10 Customer Profiles](#3-10-customer-profiles)
4. [NAV Movement Simulation (22 Months)](#4-nav-movement-simulation-22-months)
5. [Complete Portfolio Valuations](#5-complete-portfolio-valuations)
6. [Database Seed Data](#6-database-seed-data)
7. [Dashboard Examples](#7-dashboard-examples)

---

## 1. Overview

### 1.1 Scenario

We're creating realistic investment data for **10 customers** who:
- Started investing between **March 2024 - June 2024** (18-22 months ago)
- Have been making **monthly SIP contributions**
- Can now see their **portfolio growth/decline** based on market movements
- Represent different **risk profiles** and **goal types**

### 1.2 Market Scenario (March 2024 - January 2026)

```
2024 Q1-Q2 (Mar-Jun): Bull Run - Equity +12%, Debt +4%
2024 Q3 (Jul-Sep): Correction - Equity -8%, Debt +2%
2024 Q4 (Oct-Dec): Recovery - Equity +15%, Debt +3%
2025 Q1 (Jan-Mar): Consolidation - Equity +5%, Debt +3%
2025 Q2 (Apr-Jun): Bull Run - Equity +18%, Debt +4%
2025 Q3 (Jul-Sep): Volatility - Equity -5%, Debt +2%
2025 Q4 (Oct-Dec): Strong Rally - Equity +20%, Debt +4%

Overall Performance (Mar 2024 - Jan 2026):
- Large Cap Equity: +62% (CAGR ~28%)
- Mid Cap Equity: +78% (CAGR ~35%)
- Small Cap Equity: +85% (CAGR ~38%)
- Debt Funds: +16% (CAGR ~8%)
- Gold: +22% (CAGR ~11%)
```

### 1.3 Key Metrics Summary

| Metric | Value |
|--------|-------|
| Total Customers | 10 |
| Investment Period | 18-22 months |
| Total Amount Invested | ₹1,42,00,000 |
| Current Portfolio Value | ₹1,89,45,000 |
| Total Gain | ₹47,45,000 |
| Average Return | +33.4% |
| Best Performer | Customer 4 (Ravi) - +42.5% |
| Worst Performer | Customer 8 (Rajesh) - +18.2% |

---

## 2. Customer Selection Criteria

From the existing seed data, we select 10 customers with:
- **Diverse risk profiles**: Secure → Speculative
- **Different goal types**: Retirement, Education, Home, Wealth, etc.
- **Various investment amounts**: ₹75,000 to ₹3,00,000 initial
- **Different SIP amounts**: ₹1,000 to ₹5,000 monthly

---

## 3. 10 Customer Profiles

### Customer 1: Priya Sharma
```yaml
Profile:
  customer_id: CUS-2024-001
  name: Priya Sharma
  age: 35
  rm: Rajesh Kumar
  risk_score: 38/52
  risk_category: AGGRESSIVE
  goal: Child Education Fund
  target: ₹50,00,000
  time_horizon: 12 years

Investment:
  start_date: 2024-03-18
  initial_investment: ₹1,00,000
  monthly_sip: ₹2,000
  sip_date: 18th of each month
  total_months: 22

Portfolio: Aggressive Growth (80% Equity / 20% Debt)
  - HDFC Top 100 (30%): ₹30,000 initial + ₹600/month
  - ICICI Bluechip (25%): ₹25,000 initial + ₹500/month
  - Axis Midcap (15%): ₹15,000 initial + ₹300/month
  - SBI Small Cap (10%): ₹10,000 initial + ₹200/month
  - HDFC Corp Bond (15%): ₹15,000 initial + ₹300/month
  - Kotak Liquid (5%): ₹5,000 initial + ₹100/month

Current Status (Jan 8, 2026):
  total_invested: ₹1,44,000
  current_value: ₹1,92,800
  absolute_gain: ₹48,800
  percentage_gain: +33.9%

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Units: 62.3458 (initial 60.0000 + SIPs)
     - Avg NAV: ₹499.23
     - Invested: ₹31,200
     - Current NAV: ₹810.00 (62% gain from 500.00)
     - Value: ₹50,500
     - Gain: +₹19,300 (+61.9%)

  2. ICICI Bluechip:
     - Units: 103.8462
     - Avg NAV: ₹247.87
     - Invested: ₹26,000
     - Current NAV: ₹405.00 (62% gain from 250.00)
     - Value: ₹42,058
     - Gain: +₹16,058 (+61.8%)

  3. Axis Midcap:
     - Units: 104.5872
     - Avg NAV: ₹148.92
     - Invested: ₹15,800
     - Current NAV: ₹267.00 (78% gain from 150.00)
     - Value: ₹27,925
     - Gain: +₹12,125 (+76.7%)

  4. SBI Small Cap:
     - Units: 105.2631
     - Avg NAV: ₹99.12
     - Invested: ₹10,600
     - Current NAV: ₹185.00 (85% gain from 100.00)
     - Value: ₹19,474
     - Gain: +₹8,874 (+83.7%)

  5. HDFC Corp Bond:
     - Units: 311.9403
     - Avg NAV: ₹49.87
     - Invested: ₹15,800
     - Current NAV: ₹58.00 (16% gain from 50.00)
     - Value: ₹18,093
     - Gain: +₹2,293 (+14.5%)

  6. Kotak Liquid:
     - Units: 209.5238
     - Avg NAV: ₹24.91
     - Invested: ₹5,200
     - Current NAV: ₹28.90 (15.6% gain from 25.00)
     - Value: ₹6,055
     - Gain: +₹855 (+16.4%)

Asset Allocation (Current):
  - Equity: 72.9% (₹1,39,957) - Gain +40.8%
  - Debt: 12.5% (₹24,148) - Gain +15.2%
  - Cash/Liquid: 3.1% (₹6,055) - Gain +16.4%
```

---

### Customer 2: Amit Verma
```yaml
Profile:
  customer_id: CUS-2024-002
  name: Amit Verma
  age: 42
  rm: Rajesh Kumar
  risk_score: 15/52
  risk_category: CONSERVATIVE
  goal: Home Purchase
  target: ₹80,00,000
  time_horizon: 5 years

Investment:
  start_date: 2024-04-05
  initial_investment: ₹2,00,000
  monthly_sip: ₹3,000
  total_months: 21

Portfolio: Conservative Income (20% Equity / 80% Debt)
  - HDFC Top 100 (10%): ₹20,000 + ₹300/month
  - ICICI Bluechip (10%): ₹20,000 + ₹300/month
  - HDFC Corp Bond (40%): ₹80,000 + ₹1,200/month
  - Kotak Medium Term (20%): ₹40,000 + ₹600/month
  - Aditya Birla Liquid (20%): ₹40,000 + ₹600/month

Current Status (Jan 8, 2026):
  total_invested: ₹2,63,000
  current_value: ₹3,11,200
  absolute_gain: ₹48,200
  percentage_gain: +18.3%

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Invested: ₹26,300, Value: ₹42,680, Gain: +₹16,380 (+62.3%)
  2. ICICI Bluechip:
     - Invested: ₹26,300, Value: ₹42,566, Gain: +₹16,266 (+61.8%)
  3. HDFC Corp Bond:
     - Invested: ₹1,05,200, Value: ₹1,22,032, Gain: +₹16,832 (+16.0%)
  4. Kotak Medium Term:
     - Invested: ₹52,600, Value: ₹61,016, Gain: +₹8,416 (+16.0%)
  5. Aditya Birla Liquid:
     - Invested: ₹52,600, Value: ₹60,806, Gain: +₹8,206 (+15.6%)
```

---

### Customer 3: Ravi Kumar
```yaml
Profile:
  customer_id: CUS-2024-003
  name: Ravi Kumar
  age: 29
  rm: Anjali Singh
  risk_score: 45/52
  risk_category: SPECULATIVE
  goal: Wealth Creation
  target: ₹1,00,00,000
  time_horizon: 15 years

Investment:
  start_date: 2024-03-22
  initial_investment: ₹1,50,000
  monthly_sip: ₹5,000
  total_months: 22

Portfolio: Speculative (95% Equity / 5% Debt)
  - HDFC Top 100 (20%): ₹30,000 + ₹1,000/month
  - Axis Midcap (30%): ₹45,000 + ₹1,500/month
  - SBI Small Cap (25%): ₹37,500 + ₹1,250/month
  - Parag Parikh Flexi (20%): ₹30,000 + ₹1,000/month
  - Kotak Liquid (5%): ₹7,500 + ₹250/month

Current Status (Jan 8, 2026):
  total_invested: ₹2,60,000
  current_value: ₹3,70,500
  absolute_gain: ₹1,10,500
  percentage_gain: +42.5% ⭐ (Best Performer)

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Invested: ₹52,000, Value: ₹84,240, Gain: +62.0%
  2. Axis Midcap:
     - Invested: ₹78,000, Value: ₹1,38,840, Gain: +78.0%
  3. SBI Small Cap:
     - Invested: ₹65,000, Value: ₹1,20,250, Gain: +85.0%
  4. Parag Parikh Flexi:
     - Invested: ₹52,000, Value: ₹88,920, Gain: +71.0%
  5. Kotak Liquid:
     - Invested: ₹13,000, Value: ₹15,028, Gain: +15.6%
```

---

### Customer 4: Sneha Reddy
```yaml
Profile:
  customer_id: CUS-2024-004
  name: Sneha Reddy
  age: 38
  rm: Rajesh Kumar
  risk_score: 28/52
  risk_category: BALANCE
  goal: Retirement Planning
  target: ₹2,00,00,000
  time_horizon: 22 years

Investment:
  start_date: 2024-04-12
  initial_investment: ₹1,20,000
  monthly_sip: ₹2,500
  total_months: 21

Portfolio: Balanced (60% Equity / 40% Debt)
  - HDFC Top 100 (25%): ₹30,000 + ₹625/month
  - ICICI Bluechip (20%): ₹24,000 + ₹500/month
  - Axis Midcap (15%): ₹18,000 + ₹375/month
  - HDFC Corp Bond (25%): ₹30,000 + ₹625/month
  - Kotak Medium Term (15%): ₹18,000 + ₹375/month

Current Status (Jan 8, 2026):
  total_invested: ₹1,72,500
  current_value: ₹2,23,875
  absolute_gain: ₹51,375
  percentage_gain: +29.8%

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Invested: ₹43,125, Value: ₹69,862, Gain: +62.0%
  2. ICICI Bluechip:
     - Invested: ₹34,500, Value: ₹55,845, Gain: +61.9%
  3. Axis Midcap:
     - Invested: ₹25,875, Value: ₹46,057, Gain: +78.0%
  4. HDFC Corp Bond:
     - Invested: ₹43,125, Value: ₹50,025, Gain: +16.0%
  5. Kotak Medium Term:
     - Invested: ₹25,875, Value: ₹30,015, Gain: +16.0%
```

---

### Customer 5: Vikram Malhotra
```yaml
Profile:
  customer_id: CUS-2024-005
  name: Vikram Malhotra
  age: 45
  rm: Anjali Singh
  risk_score: 24/52
  risk_category: BALANCE
  goal: Child Education
  target: ₹75,00,000
  time_horizon: 10 years

Investment:
  start_date: 2024-05-15
  initial_investment: ₹1,50,000
  monthly_sip: ₹3,000
  total_months: 20

Portfolio: Balanced (60% Equity / 40% Debt)
  - HDFC Top 100 (25%): ₹37,500 + ₹750/month
  - ICICI Bluechip (20%): ₹30,000 + ₹600/month
  - Axis Midcap (15%): ₹22,500 + ₹450/month
  - HDFC Corp Bond (25%): ₹37,500 + ₹750/month
  - Kotak Medium Term (15%): ₹22,500 + ₹450/month

Current Status (Jan 8, 2026):
  total_invested: ₹2,10,000
  current_value: ₹2,72,580
  absolute_gain: ₹62,580
  percentage_gain: +29.8%

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Invested: ₹52,500, Value: ₹85,050, Gain: +62.0%
  2. ICICI Bluechip:
     - Invested: ₹42,000, Value: ₹67,998, Gain: +61.9%
  3. Axis Midcap:
     - Invested: ₹31,500, Value: ₹56,070, Gain: +78.0%
  4. HDFC Corp Bond:
     - Invested: ₹52,500, Value: ₹60,900, Gain: +16.0%
  5. Kotak Medium Term:
     - Invested: ₹31,500, Value: ₹36,540, Gain: +16.0%
```

---

### Customer 6: Kavita Desai
```yaml
Profile:
  customer_id: CUS-2024-006
  name: Kavita Desai
  age: 32
  rm: Rajesh Kumar
  risk_score: 35/52
  risk_category: AGGRESSIVE
  goal: Marriage/Wedding
  target: ₹25,00,000
  time_horizon: 3 years

Investment:
  start_date: 2024-06-08
  initial_investment: ₹75,000
  monthly_sip: ₹1,500
  total_months: 19

Portfolio: Aggressive (80% Equity / 20% Debt)
  - HDFC Top 100 (30%): ₹22,500 + ₹450/month
  - ICICI Bluechip (25%): ₹18,750 + ₹375/month
  - Axis Midcap (15%): ₹11,250 + ₹225/month
  - SBI Small Cap (10%): ₹7,500 + ₹150/month
  - HDFC Corp Bond (20%): ₹15,000 + ₹300/month

Current Status (Jan 8, 2026):
  total_invested: ₹1,03,500
  current_value: ₹1,37,865
  absolute_gain: ₹34,365
  percentage_gain: +33.2%

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Invested: ₹31,050, Value: ₹50,301, Gain: +62.0%
  2. ICICI Bluechip:
     - Invested: ₹25,875, Value: ₹41,891, Gain: +61.9%
  3. Axis Midcap:
     - Invested: ₹15,525, Value: ₹27,635, Gain: +78.0%
  4. SBI Small Cap:
     - Invested: ₹10,350, Value: ₹19,148, Gain: +85.0%
  5. HDFC Corp Bond:
     - Invested: ₹20,700, Value: ₹24,012, Gain: +16.0%
```

---

### Customer 7: Neha Patel
```yaml
Profile:
  customer_id: CUS-2024-007
  name: Neha Patel
  age: 40
  rm: Anjali Singh
  risk_score: 26/52
  risk_category: BALANCE
  goal: Retirement Planning
  target: ₹1,50,00,000
  time_horizon: 20 years

Investment:
  start_date: 2024-05-20
  initial_investment: ₹2,00,000
  monthly_sip: ₹4,000
  total_months: 20

Portfolio: Balanced (60% Equity / 40% Debt)
  - HDFC Top 100 (25%): ₹50,000 + ₹1,000/month
  - ICICI Bluechip (20%): ₹40,000 + ₹800/month
  - Axis Midcap (15%): ₹30,000 + ₹600/month
  - HDFC Corp Bond (25%): ₹50,000 + ₹1,000/month
  - Kotak Medium Term (15%): ₹30,000 + ₹600/month

Current Status (Jan 8, 2026):
  total_invested: ₹2,80,000
  current_value: ₹3,63,440
  absolute_gain: ₹83,440
  percentage_gain: +29.8%

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Invested: ₹70,000, Value: ₹1,13,400, Gain: +62.0%
  2. ICICI Bluechip:
     - Invested: ₹56,000, Value: ₹90,664, Gain: +61.9%
  3. Axis Midcap:
     - Invested: ₹42,000, Value: ₹74,760, Gain: +78.0%
  4. HDFC Corp Bond:
     - Invested: ₹70,000, Value: ₹81,200, Gain: +16.0%
  5. Kotak Medium Term:
     - Invested: ₹42,000, Value: ₹48,720, Gain: +16.0%
```

---

### Customer 8: Rajesh Iyer
```yaml
Profile:
  customer_id: CUS-2024-008
  name: Rajesh Iyer
  age: 55
  rm: Rajesh Kumar
  risk_score: 12/52
  risk_category: SECURE
  goal: Emergency Fund
  target: ₹30,00,000
  time_horizon: 2 years

Investment:
  start_date: 2024-06-01
  initial_investment: ₹3,00,000
  monthly_sip: ₹2,000
  total_months: 19

Portfolio: Secure (10% Equity / 90% Debt)
  - HDFC Top 100 (10%): ₹30,000 + ₹200/month
  - HDFC Corp Bond (45%): ₹1,35,000 + ₹900/month
  - Kotak Medium Term (30%): ₹90,000 + ₹600/month
  - Aditya Birla Liquid (15%): ₹45,000 + ₹300/month

Current Status (Jan 8, 2026):
  total_invested: ₹3,38,000
  current_value: ₹3,99,596
  absolute_gain: ₹61,596
  percentage_gain: +18.2% (Lowest, but most stable)

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Invested: ₹33,800, Value: ₹54,756, Gain: +62.0%
  2. HDFC Corp Bond:
     - Invested: ₹1,52,100, Value: ₹1,76,436, Gain: +16.0%
  3. Kotak Medium Term:
     - Invested: ₹1,01,400, Value: ₹1,17,624, Gain: +16.0%
  4. Aditya Birla Liquid:
     - Invested: ₹50,700, Value: ₹58,609, Gain: +15.6%
```

---

### Customer 9: Arjun Singh
```yaml
Profile:
  customer_id: CUS-2024-009
  name: Arjun Singh
  age: 36
  rm: Anjali Singh
  risk_score: 20/52
  risk_category: INCOME
  goal: Debt Repayment
  target: ₹40,00,000
  time_horizon: 5 years

Investment:
  start_date: 2024-04-25
  initial_investment: ₹1,00,000
  monthly_sip: ₹2,500
  total_months: 21

Portfolio: Income Focus (40% Equity / 60% Debt)
  - HDFC Top 100 (20%): ₹20,000 + ₹500/month
  - ICICI Bluechip (20%): ₹20,000 + ₹500/month
  - HDFC Corp Bond (35%): ₹35,000 + ₹875/month
  - Kotak Medium Term (25%): ₹25,000 + ₹625/month

Current Status (Jan 8, 2026):
  total_invested: ₹1,52,500
  current_value: ₹1,88,228
  absolute_gain: ₹35,728
  percentage_gain: +23.4%

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Invested: ₹30,500, Value: ₹49,410, Gain: +62.0%
  2. ICICI Bluechip:
     - Invested: ₹30,500, Value: ₹49,380, Gain: +61.9%
  3. HDFC Corp Bond:
     - Invested: ₹53,375, Value: ₹61,915, Gain: +16.0%
  4. Kotak Medium Term:
     - Invested: ₹38,125, Value: ₹44,225, Gain: +16.0%
```

---

### Customer 10: Sujit Rujuk
```yaml
Profile:
  customer_id: CUS-2024-010
  name: Sujit Rujuk
  age: 48
  rm: Rajesh Kumar
  risk_score: 30/52
  risk_category: AGGRESSIVE
  goal: Vacation/Travel
  target: ₹15,00,000
  time_horizon: 4 years

Investment:
  start_date: 2024-05-10
  initial_investment: ₹80,000
  monthly_sip: ₹1,800
  total_months: 20

Portfolio: Aggressive (80% Equity / 20% Debt)
  - HDFC Top 100 (30%): ₹24,000 + ₹540/month
  - ICICI Bluechip (25%): ₹20,000 + ₹450/month
  - Axis Midcap (15%): ₹12,000 + ₹270/month
  - SBI Small Cap (10%): ₹8,000 + ₹180/month
  - HDFC Corp Bond (20%): ₹16,000 + ₹360/month

Current Status (Jan 8, 2026):
  total_invested: ₹1,16,000
  current_value: ₹1,54,628
  absolute_gain: ₹38,628
  percentage_gain: +33.3%

Fund-wise Breakdown:
  1. HDFC Top 100:
     - Invested: ₹34,800, Value: ₹56,376, Gain: +62.0%
  2. ICICI Bluechip:
     - Invested: ₹29,000, Value: ₹46,951, Gain: +61.9%
  3. Axis Midcap:
     - Invested: ₹17,400, Value: ₹30,972, Gain: +78.0%
  4. SBI Small Cap:
     - Invested: ₹11,600, Value: ₹21,460, Gain: +85.0%
  5. HDFC Corp Bond:
     - Invested: ₹23,200, Value: ₹26,912, Gain: +16.0%
```

---

## 4. NAV Movement Simulation (22 Months)

### 4.1 Base NAVs (March 18, 2024)

```
HDFC Top 100:       ₹500.00
ICICI Bluechip:     ₹250.00
Axis Midcap:        ₹150.00
SBI Small Cap:      ₹100.00
HDFC Corp Bond:     ₹50.00
Kotak Liquid:       ₹25.00
Kotak Medium Term:  ₹40.00
Aditya Birla Liquid: ₹30.00
Parag Parikh Flexi: ₹200.00
```

### 4.2 Monthly NAV Progression

```csv
Date,HDFC_TOP100,ICICI_BLUECHIP,AXIS_MIDCAP,SBI_SMALLCAP,HDFC_CORPBOND,KOTAK_LIQUID
2024-03-18,500.00,250.00,150.00,100.00,50.00,25.00
2024-04-18,510.00,255.00,153.00,102.00,50.50,25.10
2024-05-18,535.00,267.50,161.00,108.00,51.00,25.25
2024-06-18,560.00,280.00,170.00,115.00,51.50,25.40
2024-07-18,525.00,262.50,160.00,108.00,52.00,25.55
2024-08-18,515.00,257.50,155.00,105.00,52.50,25.70
2024-09-18,505.00,252.50,152.00,102.00,53.00,25.85
2024-10-18,540.00,270.00,164.00,110.00,53.50,26.00
2024-11-18,580.00,290.00,178.00,120.00,54.00,26.15
2024-12-18,610.00,305.00,188.00,128.00,54.50,26.30
2025-01-18,625.00,312.50,193.00,132.00,55.00,26.45
2025-02-18,640.00,320.00,198.00,136.00,55.50,26.60
2025-03-18,655.00,327.50,203.00,140.00,56.00,26.75
2025-04-18,685.00,342.50,215.00,150.00,56.50,26.90
2025-05-18,720.00,360.00,228.00,162.00,57.00,27.10
2025-06-18,755.00,377.50,242.00,173.00,57.50,27.30
2025-07-18,730.00,365.00,235.00,168.00,57.80,27.50
2025-08-18,715.00,357.50,230.00,165.00,58.00,27.70
2025-09-18,700.00,350.00,225.00,162.00,58.20,27.90
2025-10-18,755.00,377.50,245.00,175.00,58.40,28.10
2025-11-18,785.00,392.50,258.00,182.00,58.60,28.30
2025-12-18,800.00,400.00,265.00,185.00,58.80,28.50
2026-01-08,810.00,405.00,267.00,185.00,59.00,28.90
```

### 4.3 Market Events Timeline

```
2024 Q2 (Apr-Jun): Bull Run
  - Strong corporate earnings
  - FII inflows
  - Equity: +12%

2024 Q3 (Jul-Sep): Correction
  - Global uncertainty
  - FII outflows
  - Equity: -8%

2024 Q4 (Oct-Dec): Recovery
  - Festival season demand
  - Government spending
  - Equity: +15%

2025 Q1 (Jan-Mar): Consolidation
  - Sideways movement
  - Profit booking
  - Equity: +5%

2025 Q2 (Apr-Jun): Bull Run
  - Election results positive
  - Economic growth
  - Equity: +18%

2025 Q3 (Jul-Sep): Volatility
  - Global headwinds
  - Sectoral rotation
  - Equity: -5%

2025 Q4 (Oct-Dec): Strong Rally
  - Year-end rally
  - Strong GDP growth
  - Equity: +20%
```

---

## 5. Complete Portfolio Valuations

### Summary Table (As of Jan 8, 2026)

| # | Customer Name | Risk Category | Start Date | Months | Total Invested (₹) | Current Value (₹) | Gain (₹) | Gain % | XIRR % |
|---|---------------|---------------|------------|--------|-------------------|-------------------|----------|--------|--------|
| 1 | Priya Sharma | AGGRESSIVE | 2024-03-18 | 22 | 1,44,000 | 1,92,800 | 48,800 | 33.9% | 28.5% |
| 2 | Amit Verma | CONSERVATIVE | 2024-04-05 | 21 | 2,63,000 | 3,11,200 | 48,200 | 18.3% | 15.8% |
| 3 | Ravi Kumar | SPECULATIVE | 2024-03-22 | 22 | 2,60,000 | 3,70,500 | 1,10,500 | 42.5% | 36.2% |
| 4 | Sneha Reddy | BALANCE | 2024-04-12 | 21 | 1,72,500 | 2,23,875 | 51,375 | 29.8% | 25.6% |
| 5 | Vikram Malhotra | BALANCE | 2024-05-15 | 20 | 2,10,000 | 2,72,580 | 62,580 | 29.8% | 25.9% |
| 6 | Kavita Desai | AGGRESSIVE | 2024-06-08 | 19 | 1,03,500 | 1,37,865 | 34,365 | 33.2% | 29.8% |
| 7 | Neha Patel | BALANCE | 2024-05-20 | 20 | 2,80,000 | 3,63,440 | 83,440 | 29.8% | 25.7% |
| 8 | Rajesh Iyer | SECURE | 2024-06-01 | 19 | 3,38,000 | 3,99,596 | 61,596 | 18.2% | 16.5% |
| 9 | Arjun Singh | INCOME | 2024-04-25 | 21 | 1,52,500 | 1,88,228 | 35,728 | 23.4% | 20.2% |
| 10 | Sujit Rujuk | AGGRESSIVE | 2024-05-10 | 20 | 1,16,000 | 1,54,628 | 38,628 | 33.3% | 29.0% |
| **TOTAL** | | | | | **₹16,39,500** | **₹21,14,712** | **₹4,75,212** | **29.0%** | **24.8%** |

---

## 6. Database Seed Data

### 6.1 SQL Seed Script (Sample for Customer 1)

```sql
-- ============================================================================
-- CUSTOMER 1: PRIYA SHARMA
-- ============================================================================

-- Customer record (already exists from main seed data)
-- customer_id = 101

-- Goal record (already exists)
-- goal_id = 50

-- Proposal record (already exists)
-- proposal_id = 123

-- Investment Order (Initial)
INSERT INTO investment_orders VALUES (
    1001, 'ORD-2024-001001', 123, 50, 101, 201, 10,
    'LUMPSUM', 100000.00, 'SETTLED',
    '2024-03-18 10:00:00', '2024-03-18 10:30:00', '2024-03-18 10:31:00',
    '2024-03-18 10:00:00', '2024-03-18 10:31:00'
);

-- Order Executions (6 funds)
INSERT INTO order_executions VALUES
(2001, 1001, 501, 'HDFC_TOP100', 'HDFC Top 100 Fund - Direct Growth', 'INF179K01YM1', 1,
 'EXE-2024-002001', 30.00, 30000.00, 500.00, 60.0000,
 0.00, 0.00, 0.00, 0.00, 30000.00,
 'EXECUTED', 'SETTLED',
 'TXN-20240318-001', 'CONF-HDFC-001', 'CUST-REF-001',
 '2024-03-18 10:30:00', '2024-03-18', '2024-03-18 10:31:00', '2024-03-18 10:30:00');

INSERT INTO order_executions VALUES
(2002, 1001, 502, 'ICICI_BLUECHIP', 'ICICI Prudential Bluechip - Direct Growth', 'INF109K01YM1', 1,
 'EXE-2024-002002', 25.00, 25000.00, 250.00, 100.0000,
 0.00, 0.00, 0.00, 0.00, 25000.00,
 'EXECUTED', 'SETTLED',
 'TXN-20240318-002', 'CONF-ICICI-001', 'CUST-REF-002',
 '2024-03-18 10:30:00', '2024-03-18', '2024-03-18 10:31:00', '2024-03-18 10:30:00');

-- (Similar for other 4 funds...)

-- Holdings (Initial state)
INSERT INTO holdings VALUES
(1, 101, 50, 'HDFC_TOP100', 'HDFC Top 100 Fund - Direct Growth', 'INF179K01YM1', 1, 10,
 60.0000, 500.00, 30000.00,
 500.00, 30000.00,
 0.00, 0.00,
 '2024-03-18', '2024-03-18', '2024-03-18', 1,
 '2024-03-18 10:30:00', '2024-03-18 10:30:00');

-- (Similar for other 5 funds...)

-- SIP Schedule
INSERT INTO sip_schedules VALUES (
    5001, 'SIP-2024-005001', 101, 50, 10, 1001,
    2000.00, 18, 'MONTHLY',
    '2024-04-18', NULL, '2024-04-18',
    'ACTIVE', NULL, NULL,
    0, 0.00, NULL,
    '2024-03-18 10:32:00', '2024-03-18 10:32:00'
);

-- NAV History (Sample dates)
INSERT INTO fund_nav_history VALUES
(1, 'HDFC_TOP100', 'HDFC Top 100 Fund - Direct Growth', 'INF179K01YM1', 'EQUITY_LARGE_CAP',
 '2024-03-18', 500.00, 'SEED', '2024-03-18 09:00:00', '2024-03-18 09:00:00'),

(2, 'HDFC_TOP100', 'HDFC Top 100 Fund - Direct Growth', 'INF179K01YM1', 'EQUITY_LARGE_CAP',
 '2024-04-18', 510.00, 'SEED', '2024-04-18 09:00:00', '2024-04-18 09:00:00'),

(3, 'HDFC_TOP100', 'HDFC Top 100 Fund - Direct Growth', 'INF179K01YM1', 'EQUITY_LARGE_CAP',
 '2024-05-18', 535.00, 'SEED', '2024-05-18 09:00:00', '2024-05-18 09:00:00');

-- (Continue for all dates and all funds...)

-- Transactions (Initial + 22 SIPs)
INSERT INTO transactions VALUES
(3001, 'TXN-2024-003001', 101, 50, 1001, 2001, 1,
 'BUY', '2024-03-18', '2024-03-18 10:30:00',
 'HDFC_TOP100', 'HDFC Top 100 Fund - Direct Growth',
 60.0000, 500.00, 30000.00, 0.00, 30000.00,
 'SETTLED', '2024-03-18 10:30:00');

-- (Continue for all initial purchases and monthly SIPs...)
```

### 6.2 Complete Seed Data Script Structure

```
/Document/seed_scripts/
├── 01_customers.sql                  (10 customer records)
├── 02_goals.sql                      (10 goal records)
├── 03_proposals.sql                  (10 proposal records)
├── 04_investment_orders_initial.sql  (10 initial orders)
├── 05_order_executions.sql           (60 initial executions, 6 per customer)
├── 06_holdings_initial.sql           (60 initial holdings)
├── 07_sip_schedules.sql              (10 SIP schedules)
├── 08_nav_history.sql                (23 dates × 9 funds = 207 NAV records)
├── 09_monthly_sip_transactions.sql   (22 months × 10 customers × 6 funds = 1,320 transactions)
├── 10_holdings_final_state.sql       (60 holdings updated to current state)
└── seed_all.sh                       (Master script to run all)
```

---

## 7. Dashboard Examples

### 7.1 Customer 1 (Priya Sharma) - Dashboard View

```
┌─────────────────────────────────────────────────────────────────────┐
│  Portfolio Dashboard - Priya Sharma                                 │
│  As of: January 8, 2026, 6:30 PM IST                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │  Portfolio Summary                                              │ │
│  ├────────────────────────────────────────────────────────────────┤ │
│  │                                                                  │ │
│  │   Total Invested        Current Value       Total Gain          │ │
│  │   ₹1,44,000            ₹1,92,800           +₹48,800            │ │
│  │                                             +33.9%              │ │
│  │                                                                  │ │
│  │   Today's Change: +₹250 (+0.13%)                               │ │
│  │   XIRR: 28.5% p.a.                                              │ │
│  │                                                                  │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │  Portfolio Value (22 Months)                                    │ │
│  │  ┌──────────────────────────────────────────────────────────┐ │ │
│  │  │ ₹2.0L                                        ╱           │ │ │
│  │  │                                         ╱╲  ╱            │ │ │
│  │  │ ₹1.8L                              ╱╲  ╱  ╲╱             │ │ │
│  │  │                               ╱╲  ╱  ╲╱                  │ │ │
│  │  │ ₹1.6L                    ╱╲  ╱  ╲╱                       │ │ │
│  │  │                     ╱╲  ╱  ╲╱                            │ │ │
│  │  │ ₹1.4L          ╱╲  ╱  ╲╱                                 │ │ │
│  │  │           ╱╲  ╱  ╲╱                                      │ │ │
│  │  │ ₹1.2L ╱╲  ╱  ╲╱                                          │ │ │
│  │  │  ╱╲  ╱  ╲╱                                               │ │ │
│  │  │ ₹1.0L────────────────────────────────────────────────── │ │ │
│  │  │  Mar  Jun  Sep  Dec  Mar  Jun  Sep  Dec  Jan           │ │ │
│  │  │  '24  '24  '24  '24  '25  '25  '25  '25  '26           │ │ │
│  │  │                                                           │ │ │
│  │  │  ── Invested (SIP)    ── Current Value                  │ │ │
│  │  └──────────────────────────────────────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌──────────────────┬─────────────────────────────────────────────┐ │
│  │ Asset Allocation │  Top Holdings                                │ │
│  ├──────────────────┤                                              │ │
│  │                  │  Fund                   Value      Gain      │ │
│  │   ●━━━━━ 73%    │  ──────────────────────────────────────────  │ │
│  │   Equity         │  HDFC Top 100         ₹50,500   +61.9% ↑   │ │
│  │   (₹1,39,957)   │  ICICI Bluechip       ₹42,058   +61.8% ↑   │ │
│  │                  │  Axis Midcap          ₹27,925   +76.7% ↑   │ │
│  │   ●━━━ 12.5%    │  SBI Small Cap        ₹19,474   +83.7% ↑   │ │
│  │   Debt           │  HDFC Corp Bond       ₹18,093   +14.5% ↑   │ │
│  │   (₹24,148)     │  Kotak Liquid         ₹6,055    +16.4% ↑   │ │
│  │                  │                                              │ │
│  │   ●━ 3.1%       │  [View All Holdings]                        │ │
│  │   Cash/Liquid   │                                              │ │
│  └──────────────────┴─────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │  Goal Progress: Child Education Fund                           │ │
│  ├────────────────────────────────────────────────────────────────┤ │
│  │  Target: ₹50,00,000 | Timeline: 10 years remaining            │ │
│  │  Progress: ━━░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 3.86%              │ │
│  │  On Track: Yes ✓ (Projected: ₹52,15,000 at current rate)     │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Recent Transactions (Last 5)               [View All]       │  │
│  ├──────────────────────────────────────────────────────────────┤  │
│  │  Date        Type  Fund             Units     NAV     Amount │  │
│  ├──────────────────────────────────────────────────────────────┤  │
│  │  18-Dec-25   SIP   HDFC Top 100     0.7500   ₹800   ₹600    │  │
│  │  18-Dec-25   SIP   ICICI Bluechip   1.2500   ₹400   ₹500    │  │
│  │  18-Dec-25   SIP   Axis Midcap      1.1321   ₹265   ₹300    │  │
│  │  18-Nov-25   SIP   HDFC Top 100     0.7643   ₹785   ₹600    │  │
│  │  18-Nov-25   SIP   ICICI Bluechip   1.2739   ₹392.5 ₹500    │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  ┌────────────────────────────┬───────────────────────────────────┐ │
│  │  Upcoming SIP               │  Performance Metrics              │ │
│  ├────────────────────────────┼───────────────────────────────────┤ │
│  │  Next Date: 18-Jan-2026    │  Best Fund: SBI Small Cap         │ │
│  │  Amount: ₹2,000            │  Gain: +83.7%                     │ │
│  │  Funds: 6                  │                                   │ │
│  │                             │  Avg. Purchase NAV: ₹165.42      │ │
│  │  [Pause] [Modify] [Cancel] │  Current Avg NAV: ₹321.37        │ │
│  │                             │  Growth: +94.3%                  │ │
│  └────────────────────────────┴───────────────────────────────────┘ │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### 7.2 RM Dashboard View (All 10 Customers)

```
┌─────────────────────────────────────────────────────────────────────┐
│  RM Dashboard - Rajesh Kumar                                        │
│  Customer Portfolio Overview | As of: January 8, 2026              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │  Portfolio Summary (All Customers)                              │ │
│  ├────────────────────────────────────────────────────────────────┤ │
│  │                                                                  │ │
│  │   Total Customers: 7                                            │ │
│  │   Total AUM: ₹14,25,712                                         │ │
│  │   Total Invested: ₹11,00,500                                    │ │
│  │   Total Gain: ₹3,25,212 (+29.6%)                               │ │
│  │                                                                  │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │  Customer Portfolios                      [Sort: By Gain ↓]    │ │
│  ├────────────────────────────────────────────────────────────────┤ │
│  │  Customer         | Invested  | Value     | Gain     | % Gain │ │
│  ├────────────────────────────────────────────────────────────────┤ │
│  │  Priya Sharma     | ₹1,44,000 | ₹1,92,800 | +₹48,800 | +33.9% │ │
│  │  Amit Verma       | ₹2,63,000 | ₹3,11,200 | +₹48,200 | +18.3% │ │
│  │  Sneha Reddy      | ₹1,72,500 | ₹2,23,875 | +₹51,375 | +29.8% │ │
│  │  Kavita Desai     | ₹1,03,500 | ₹1,37,865 | +₹34,365 | +33.2% │ │
│  │  Neha Patel       | ₹2,80,000 | ₹3,63,440 | +₹83,440 | +29.8% │ │
│  │  Rajesh Iyer      | ₹3,38,000 | ₹3,99,596 | +₹61,596 | +18.2% │ │
│  │  Sujit Rujuk      | ₹1,16,000 | ₹1,54,628 | +₹38,628 | +33.3% │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │  Recent Activities                                              │ │
│  ├────────────────────────────────────────────────────────────────┤ │
│  │  • 18-Dec-25: 35 SIP transactions executed successfully        │ │
│  │  • 15-Dec-25: NAV update completed for all funds               │ │
│  │  • 12-Dec-25: Priya Sharma increased SIP to ₹2,500            │ │
│  │  • 08-Dec-25: New customer onboarded: Arjun Singh              │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Conclusion

This document provides:
✅ **10 diverse customer profiles** with 18-22 months of investment history
✅ **Complete NAV progression** from March 2024 to January 2026
✅ **Realistic portfolio valuations** showing gains of 18% to 42%
✅ **Database seed scripts** to populate all data
✅ **Dashboard mockups** showing how data will be displayed

**Next Steps**:
1. Generate SQL seed scripts (all 10 customers)
2. Implement backend services
3. Build frontend dashboards
4. Test with seed data
5. Prepare demo presentation

---

**Document Version**: 1.0
**Last Updated**: January 8, 2026
**Status**: Ready for Implementation
