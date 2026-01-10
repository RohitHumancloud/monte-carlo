-- ═══════════════════════════════════════════════════════════════════════
-- SEED DATA: SUITABILITY ASSESSMENT QUESTIONNAIRE (TOP 8 QUESTIONS)
-- ═══════════════════════════════════════════════════════════════════════
-- Purpose: Insert MiFID II compliant suitability assessment questions
-- Regulatory Framework: MiFID II, FINRA Rule 2111, SEBI IA Regulations 2013
-- Total Questions: 8 (Optimized from 32-question version)
-- Assessment Time: 7-10 minutes (reduced from 15-20 minutes)
-- Version: 2.0 - December 2025
-- ═══════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────
-- STEP 1: Insert Main Assessment Questions (Top 8)
-- ───────────────────────────────────────────────────────────────────────

-- Question 1: Age Group (MiFID II Required)
INSERT INTO suitability_questions (
    question_code, question_text, question_type, category, display_order,
    weight, is_mandatory, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'SUIT_AGE_GROUP',
    'Please select your current age group:',
    'SINGLE_SELECT',
    'PERSONAL_INFO',
    1,
    1.0,
    TRUE,
    TRUE,
    'Your age helps us understand your investment timeline and financial life stage. Younger investors typically have more time to recover from market downturns, while those closer to retirement may prioritize capital preservation.',
    'MiFID II requires age for lifecycle investing approach. Correlate with investment time horizon for consistency check.',
    'This information is mandatory for regulatory compliance and helps us recommend age-appropriate investment strategies.'
);

-- Question 2: Annual Gross Income (MiFID II Required - MANDATORY)
INSERT INTO suitability_questions (
    question_code, question_text, question_type, category, display_order,
    weight, is_mandatory, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'SUIT_ANNUAL_INCOME',
    'What is your approximate annual gross income (before taxes)?',
    'SINGLE_SELECT',
    'FINANCIAL_SITUATION',
    2,
    1.5,
    TRUE,
    TRUE,
    'Your income level helps us understand your investment capacity and ability to sustain regular investments. This information is strictly confidential and required for regulatory compliance.',
    'MiFID II MANDATORY FIELD: Cannot proceed without this information. If "Prefer not to disclose" selected → Cannot proceed with suitability assessment.',
    'IMPORTANT: This information is mandatory for regulatory compliance under MiFID II and SEBI IA Regulations. Your data is strictly confidential and protected under data privacy regulations.'
);

-- Question 3: Total Net Worth (MiFID II Required - MANDATORY)
INSERT INTO suitability_questions (
    question_code, question_text, question_type, category, display_order,
    weight, is_mandatory, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'SUIT_NET_WORTH',
    'What is your approximate total net worth (total assets minus total liabilities)?',
    'SINGLE_SELECT',
    'FINANCIAL_SITUATION',
    3,
    1.5,
    TRUE,
    TRUE,
    'Your net worth helps us understand your overall financial strength and ability to absorb potential losses. This includes all assets (real estate, investments, savings) minus debts.',
    'MiFID II MANDATORY FIELD: Required for risk capacity assessment. Verify consistency with Annual Income.',
    'Include all assets (property, investments, savings, gold) and subtract all liabilities (loans, credit card debt).'
);

-- Question 4: Emergency Fund Status (GATE QUESTION)
INSERT INTO suitability_questions (
    question_code, question_text, question_type, category, display_order,
    weight, is_mandatory, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'SUIT_EMERGENCY_FUND',
    'Do you have an emergency fund covering at least 6 months of essential expenses in liquid instruments (savings account, liquid funds, FD)?',
    'SINGLE_SELECT',
    'FINANCIAL_SITUATION',
    4,
    2.0,
    TRUE,
    TRUE,
    'An emergency fund protects your investments from forced liquidation during crises. Without adequate emergency savings, you might need to sell long-term investments at unfavorable times.',
    'CRITICAL GATE QUESTION: Client MUST have 3+ months emergency fund before equity allocation. No emergency fund = Maximum 20% equity allocation.',
    'CRITICAL: An emergency fund is the foundation of financial planning. Without it, you may be forced to sell long-term investments during emergencies.'
);

-- Question 5: Years of Investment Experience (MiFID II Required)
INSERT INTO suitability_questions (
    question_code, question_text, question_type, category, display_order,
    weight, is_mandatory, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'SUIT_YEARS_EXPERIENCE',
    'How many years of experience do you have in investing in financial instruments (mutual funds, stocks, bonds, etc.)?',
    'SINGLE_SELECT',
    'INVESTMENT_EXPERIENCE',
    5,
    1.0,
    TRUE,
    TRUE,
    'Your investment experience helps us recommend products at an appropriate complexity level. Experienced investors understand market cycles and can handle more sophisticated strategies.',
    'MiFID II REQUIREMENT: Experience assessment mandatory for product suitability. <1 year = Limit to diversified equity MF only.',
    'Experience with investing helps you understand market cycles, stay calm during volatility, and make rational decisions.'
);

-- Question 6: Past Performance Behavior (CRITICAL BEHAVIORAL QUESTION)
INSERT INTO suitability_questions (
    question_code, question_text, question_type, category, display_order,
    weight, is_mandatory, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'SUIT_PAST_PERFORMANCE',
    'Have you ever experienced a significant loss (>20% decline) in your investment portfolio? If yes, what did you do?',
    'SINGLE_SELECT',
    'INVESTMENT_EXPERIENCE',
    6,
    2.0,
    TRUE,
    TRUE,
    'Your behavior during past market downturns is the best indicator of your true risk tolerance. Historical context: 2008 financial crisis (-50%), 2020 COVID crash (-35%), 2022 correction (-20%).',
    'MOST IMPORTANT BEHAVIORAL QUESTION: Past behavior predicts future behavior. "Loss and Sold" = Reduce equity by 20% from model portfolio.',
    'Be honest about your gut reaction during market drops. Your actual behavior is more important than what you think you would do.'
);

-- Question 7: Investment Knowledge Quiz (MiFID II Required)
INSERT INTO suitability_questions (
    question_code, question_text, question_type, category, display_order,
    weight, is_mandatory, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'SUIT_KNOWLEDGE_QUIZ',
    'Please answer the following 7 questions to assess your investment knowledge. This is required for regulatory compliance to ensure we only recommend products you understand.',
    'QUIZ',
    'INVESTMENT_KNOWLEDGE',
    7,
    1.5,
    TRUE,
    TRUE,
    'This short quiz validates your understanding of basic investment concepts. It''s not a test to "pass" or "fail" - it helps us ensure we recommend only those products you''re comfortable with.',
    'MiFID II REQUIREMENT: Objective knowledge assessment mandatory. If score <60% (4 or fewer correct) → Limit to simple products only.',
    'This quiz helps us comply with regulations requiring that investment recommendations match your knowledge level. Take your time and answer honestly.'
);

-- Question 8: Primary Investment Objective (MiFID II Required)
INSERT INTO suitability_questions (
    question_code, question_text, question_type, category, display_order,
    weight, is_mandatory, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'SUIT_PRIMARY_OBJECTIVE',
    'What is your primary objective for this investment?',
    'SINGLE_SELECT',
    'INVESTMENT_OBJECTIVES',
    8,
    1.5,
    TRUE,
    TRUE,
    'Your investment objective should align with your financial goals, time horizon, and risk capacity. Different objectives require different investment strategies.',
    'MiFID II REQUIREMENT: Investment objectives mandatory. Cross-check consistency with time horizon.',
    'Be realistic about what you''re trying to achieve - unrealistic expectations lead to poor investment decisions.'
);

-- ───────────────────────────────────────────────────────────────────────
-- STEP 2: Insert Options for Main Questions
-- ───────────────────────────────────────────────────────────────────────

-- Q1: Age Group Options
INSERT INTO suitability_options (question_id, option_text, option_value, risk_capacity_score, display_order) VALUES
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_AGE_GROUP'), 'Under 25 years', 'UNDER_25', 4, 1),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_AGE_GROUP'), '25-35 years', 'AGE_25_35', 3, 2),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_AGE_GROUP'), '36-45 years', 'AGE_36_45', 2, 3),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_AGE_GROUP'), '46-55 years', 'AGE_46_55', 1, 4),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_AGE_GROUP'), '56-65 years', 'AGE_56_65', 0, 5),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_AGE_GROUP'), 'Over 65 years', 'OVER_65', 0, 6);

-- Q2: Annual Income Options
INSERT INTO suitability_options (question_id, option_text, option_value, risk_capacity_score, display_order) VALUES
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_ANNUAL_INCOME'), 'Below ₹3,00,000', 'BELOW_3L', 0, 1),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_ANNUAL_INCOME'), '₹3,00,000 - ₹6,00,000', '3L_6L', 1, 2),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_ANNUAL_INCOME'), '₹6,00,000 - ₹12,00,000', '6L_12L', 2, 3),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_ANNUAL_INCOME'), '₹12,00,000 - ₹25,00,000', '12L_25L', 3, 4),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_ANNUAL_INCOME'), '₹25,00,000 - ₹50,00,000', '25L_50L', 4, 5),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_ANNUAL_INCOME'), 'Above ₹50,00,000', 'ABOVE_50L', 5, 6),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_ANNUAL_INCOME'), 'Prefer not to disclose', 'NOT_DISCLOSED', NULL, 7);

-- Q3: Net Worth Options
INSERT INTO suitability_options (question_id, option_text, option_value, risk_capacity_score, display_order) VALUES
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_NET_WORTH'), 'Below ₹5,00,000', 'BELOW_5L', 0, 1),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_NET_WORTH'), '₹5,00,000 - ₹25,00,000', '5L_25L', 1, 2),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_NET_WORTH'), '₹25,00,000 - ₹50,00,000', '25L_50L', 2, 3),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_NET_WORTH'), '₹50,00,000 - ₹1,00,00,000', '50L_1CR', 3, 4),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_NET_WORTH'), '₹1,00,00,000 - ₹5,00,00,000', '1CR_5CR', 4, 5),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_NET_WORTH'), 'Above ₹5,00,00,000', 'ABOVE_5CR', 5, 6),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_NET_WORTH'), 'Prefer not to disclose', 'NOT_DISCLOSED', NULL, 7);

-- Q4: Emergency Fund Options
INSERT INTO suitability_options (question_id, option_text, option_value, risk_capacity_score, display_order) VALUES
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_EMERGENCY_FUND'), 'Yes, 6+ months covered', 'YES_ADEQUATE', 4, 1),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_EMERGENCY_FUND'), 'Yes, 3-6 months covered', 'YES_PARTIAL', 3, 2),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_EMERGENCY_FUND'), 'Less than 3 months covered', 'INADEQUATE', 1, 3),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_EMERGENCY_FUND'), 'No emergency fund', 'NO_FUND', 0, 4);

-- Q5: Years of Experience Options
INSERT INTO suitability_options (question_id, option_text, option_value, experience_level, display_order) VALUES
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_YEARS_EXPERIENCE'), 'No experience (first-time investor)', 'NO_EXPERIENCE', 1, 1),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_YEARS_EXPERIENCE'), 'Less than 1 year', 'LESS_1_YEAR', 2, 2),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_YEARS_EXPERIENCE'), '1-3 years', '1_3_YEARS', 3, 3),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_YEARS_EXPERIENCE'), '3-5 years', '3_5_YEARS', 4, 4),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_YEARS_EXPERIENCE'), '5-10 years', '5_10_YEARS', 5, 5),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_YEARS_EXPERIENCE'), 'More than 10 years', 'ABOVE_10_YEARS', 5, 6);

-- Q6: Past Performance Behavior Options
INSERT INTO suitability_options (question_id, option_text, option_value, behavioral_adjustment, display_order) VALUES
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PAST_PERFORMANCE'), 'No, never experienced significant loss', 'NO_LOSS', -1, 1),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PAST_PERFORMANCE'), 'Yes, and I sold investments during decline', 'LOSS_SOLD', -2, 2),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PAST_PERFORMANCE'), 'Yes, and I held investments without selling', 'LOSS_HELD', 0, 3),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PAST_PERFORMANCE'), 'Yes, and I invested more during decline', 'LOSS_BOUGHT_MORE', 1, 4),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PAST_PERFORMANCE'), 'Never invested during market volatility', 'NO_VOLATILITY_EXP', -1, 5);

-- Q7: Knowledge Quiz Options (This is parent question - sub-questions below)
-- No options for parent quiz question

-- Q8: Primary Investment Objective Options
INSERT INTO suitability_options (question_id, option_text, option_value, typical_equity_allocation, display_order) VALUES
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PRIMARY_OBJECTIVE'), 'Capital Preservation (protect what I have)', 'PRESERVATION', 10, 1),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PRIMARY_OBJECTIVE'), 'Generate Regular Income', 'INCOME', 20, 2),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PRIMARY_OBJECTIVE'), 'Balanced Growth & Income', 'BALANCED', 40, 3),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PRIMARY_OBJECTIVE'), 'Long-term Capital Growth', 'GROWTH', 60, 4),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PRIMARY_OBJECTIVE'), 'Aggressive Wealth Accumulation', 'AGGRESSIVE_GROWTH', 80, 5),
((SELECT id FROM suitability_questions WHERE question_code = 'SUIT_PRIMARY_OBJECTIVE'), 'Speculation / Maximum Returns', 'SPECULATION', 95, 6);

-- ───────────────────────────────────────────────────────────────────────
-- STEP 3: Insert Knowledge Quiz Sub-Questions (7 questions)
-- ───────────────────────────────────────────────────────────────────────

-- Quiz Q1: Risk-Return Relationship
INSERT INTO knowledge_quiz_questions (
    parent_question_id, question_code, question_text, display_order
) VALUES (
    (SELECT id FROM suitability_questions WHERE question_code = 'SUIT_KNOWLEDGE_QUIZ'),
    'QUIZ_RISK_RETURN',
    'Which of the following statements about investment risk and return is TRUE?',
    1
);

INSERT INTO knowledge_quiz_options (
    quiz_question_id, option_text, is_correct, display_order
) VALUES
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_RISK_RETURN'), 'Higher returns always guarantee higher risk', FALSE, 1),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_RISK_RETURN'), 'Government bonds typically offer higher returns than equity stocks', FALSE, 2),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_RISK_RETURN'), 'Generally, there is a positive relationship between risk and potential return over the long term', TRUE, 3),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_RISK_RETURN'), 'Fixed deposits have the same risk as equity mutual funds', FALSE, 4);

-- Quiz Q2: Diversification
INSERT INTO knowledge_quiz_questions (
    parent_question_id, question_code, question_text, display_order
) VALUES (
    (SELECT id FROM suitability_questions WHERE question_code = 'SUIT_KNOWLEDGE_QUIZ'),
    'QUIZ_DIVERSIFICATION',
    'What is the primary benefit of diversification in an investment portfolio?',
    2
);

INSERT INTO knowledge_quiz_options (
    quiz_question_id, option_text, is_correct, display_order
) VALUES
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_DIVERSIFICATION'), 'Guarantees higher returns', FALSE, 1),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_DIVERSIFICATION'), 'Eliminates all investment risk', FALSE, 2),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_DIVERSIFICATION'), 'Reduces portfolio risk by spreading investments across different assets', TRUE, 3),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_DIVERSIFICATION'), 'Maximizes returns from a single best-performing asset', FALSE, 4);

-- Quiz Q3: Inflation Impact
INSERT INTO knowledge_quiz_questions (
    parent_question_id, question_code, question_text, display_order
) VALUES (
    (SELECT id FROM suitability_questions WHERE question_code = 'SUIT_KNOWLEDGE_QUIZ'),
    'QUIZ_INFLATION',
    'If inflation is 6% per year and your investment returns 5% per year, what is your REAL return?',
    3
);

INSERT INTO knowledge_quiz_options (
    quiz_question_id, option_text, is_correct, display_order
) VALUES
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_INFLATION'), '+11%', FALSE, 1),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_INFLATION'), '+5%', FALSE, 2),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_INFLATION'), '-1%', TRUE, 3),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_INFLATION'), '0%', FALSE, 4);

-- Quiz Q4: Mutual Fund NAV
INSERT INTO knowledge_quiz_questions (
    parent_question_id, question_code, question_text, display_order
) VALUES (
    (SELECT id FROM suitability_questions WHERE question_code = 'SUIT_KNOWLEDGE_QUIZ'),
    'QUIZ_NAV',
    'What does NAV (Net Asset Value) represent in a mutual fund?',
    4
);

INSERT INTO knowledge_quiz_options (
    quiz_question_id, option_text, is_correct, display_order
) VALUES
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_NAV'), 'The total number of investors in the fund', FALSE, 1),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_NAV'), 'The per-unit market value of the fund''s holdings', TRUE, 2),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_NAV'), 'The annual return of the fund', FALSE, 3),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_NAV'), 'The fund manager''s performance fee', FALSE, 4);

-- Quiz Q5: Equity vs Debt
INSERT INTO knowledge_quiz_questions (
    parent_question_id, question_code, question_text, display_order
) VALUES (
    (SELECT id FROM suitability_questions WHERE question_code = 'SUIT_KNOWLEDGE_QUIZ'),
    'QUIZ_EQUITY_DEBT',
    'Which statement about equity and debt investments is CORRECT?',
    5
);

INSERT INTO knowledge_quiz_options (
    quiz_question_id, option_text, is_correct, display_order
) VALUES
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_EQUITY_DEBT'), 'Debt investments typically have higher volatility than equity', FALSE, 1),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_EQUITY_DEBT'), 'Equity investments offer fixed returns like debt', FALSE, 2),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_EQUITY_DEBT'), 'Equity investments have higher long-term growth potential but more short-term volatility', TRUE, 3),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_EQUITY_DEBT'), 'Debt investments can never lose money', FALSE, 4);

-- Quiz Q6: SIP Benefit
INSERT INTO knowledge_quiz_questions (
    parent_question_id, question_code, question_text, display_order
) VALUES (
    (SELECT id FROM suitability_questions WHERE question_code = 'SUIT_KNOWLEDGE_QUIZ'),
    'QUIZ_SIP',
    'What is the main advantage of investing through SIP (Systematic Investment Plan)?',
    6
);

INSERT INTO knowledge_quiz_options (
    quiz_question_id, option_text, is_correct, display_order
) VALUES
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_SIP'), 'Guarantees positive returns in all market conditions', FALSE, 1),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_SIP'), 'Allows you to time the market perfectly', FALSE, 2),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_SIP'), 'Averages out purchase cost over time through rupee cost averaging', TRUE, 3),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_SIP'), 'Provides higher returns than lump-sum investments', FALSE, 4);

-- Quiz Q7: LTCG Tax
INSERT INTO knowledge_quiz_questions (
    parent_question_id, question_code, question_text, display_order
) VALUES (
    (SELECT id FROM suitability_questions WHERE question_code = 'SUIT_KNOWLEDGE_QUIZ'),
    'QUIZ_LTCG_TAX',
    'What is the current LTCG (Long-Term Capital Gains) tax rate on equity mutual funds in India (as of 2025)?',
    7
);

INSERT INTO knowledge_quiz_options (
    quiz_question_id, option_text, is_correct, display_order
) VALUES
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_LTCG_TAX'), '0% (completely tax-free)', FALSE, 1),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_LTCG_TAX'), '10% above ₹1 lakh exemption', FALSE, 2),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_LTCG_TAX'), '12.5% above ₹1.25 lakh exemption', TRUE, 3),
((SELECT id FROM knowledge_quiz_questions WHERE question_code = 'QUIZ_LTCG_TAX'), '20% with indexation', FALSE, 4);

-- ───────────────────────────────────────────────────────────────────────
-- STEP 4: Verification Queries
-- ───────────────────────────────────────────────────────────────────────

-- Verify all 8 main questions inserted
SELECT
    question_code,
    question_text,
    question_type,
    category,
    is_mandatory,
    weight,
    display_order,
    COUNT(o.id) as option_count
FROM suitability_questions q
LEFT JOIN suitability_options o ON q.id = o.question_id
WHERE q.is_active = TRUE
GROUP BY q.id, q.question_code, q.question_text, q.question_type, q.category, q.is_mandatory, q.weight, q.display_order
ORDER BY q.display_order;

-- Expected output: 8 questions
-- Q1 (SUIT_AGE_GROUP): 6 options
-- Q2 (SUIT_ANNUAL_INCOME): 7 options (including "Prefer not to disclose")
-- Q3 (SUIT_NET_WORTH): 7 options (including "Prefer not to disclose")
-- Q4 (SUIT_EMERGENCY_FUND): 4 options
-- Q5 (SUIT_YEARS_EXPERIENCE): 6 options
-- Q6 (SUIT_PAST_PERFORMANCE): 5 options
-- Q7 (SUIT_KNOWLEDGE_QUIZ): 0 options (has 7 sub-questions instead)
-- Q8 (SUIT_PRIMARY_OBJECTIVE): 6 options

-- Verify knowledge quiz sub-questions
SELECT
    q.question_code as parent_question,
    kq.question_code as quiz_question_code,
    kq.question_text,
    COUNT(ko.id) as option_count,
    SUM(CASE WHEN ko.is_correct THEN 1 ELSE 0 END) as correct_options
FROM knowledge_quiz_questions kq
LEFT JOIN knowledge_quiz_options ko ON kq.id = ko.quiz_question_id
LEFT JOIN suitability_questions q ON kq.parent_question_id = q.id
GROUP BY q.question_code, kq.id, kq.question_code, kq.question_text, kq.display_order
ORDER BY kq.display_order;

-- Expected output: 7 quiz questions, each with 4 options and 1 correct answer

-- ═══════════════════════════════════════════════════════════════════════
-- EXAMPLE SUITABILITY ASSESSMENT: Priya Sharma (Moderate Profile)
-- ═══════════════════════════════════════════════════════════════════════
--
-- Q1 (Age): 25-35 → 3 points
-- Q2 (Income): ₹6-12L → 2 points
-- Q3 (Net Worth): ₹25-50L → 2 points
-- Q4 (Emergency Fund): 6+ months → 4 points (multiplier: 1.0x)
--
-- Risk Capacity Calculation:
--   Raw Score = (3 + 2 + 2) / 3 = 2.33
--   Final Score = 2.33 × 1.0 = 2.33 → Level 3 (Moderate)
--
-- Q5 (Experience): 1-3 years → 3 points
-- Q6 (Past Behavior): Held during loss → +0 adjustment
--   Experience Level = 3 + 0 = 3 → Level 3 (Intermediate)
--
-- Q7 (Knowledge Quiz): 5 correct out of 7 → Level 3 (Good Knowledge)
--
-- Q8 (Objective): Long-term Capital Growth → Aligns with 60% equity
--
-- FINAL SUITABILITY = MIN(3, 3, 3) = LEVEL 3 (MODERATE)
-- Recommended Allocation: 60% Equity / 40% Debt
-- Suitable Products: All standard diversified MF products
--
-- ═══════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════
-- SUITABILITY LEVEL TO INVESTMENT GUIDELINES MAPPING
-- ═══════════════════════════════════════════════════════════════════════
--
-- Level | Category        | Max Equity % | Suitable Products
-- ------|-----------------|--------------|----------------------------------
-- 1     | Conservative    | 20%          | Large-cap equity MF, Debt MF only
-- 2     | Moderate-Low    | 40%          | Diversified equity MF, no sectoral
-- 3     | Moderate        | 60%          | All diversified MF, limited sectoral
-- 4     | Moderate-High   | 80%          | All MF products, PMS (if eligible)
-- 5     | Aggressive      | 95%          | All products (subject to eligibility)
--
-- ═══════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════
-- REGULATORY COMPLIANCE CHECKLIST
-- ═══════════════════════════════════════════════════════════════════════
--
-- ✓ MiFID II Article 25(2) - Knowledge and Experience (Q5, Q6, Q7)
-- ✓ MiFID II Article 25(2) - Financial Situation (Q2, Q3, Q4)
-- ✓ MiFID II Article 25(2) - Investment Objectives (Q8)
-- ✓ MiFID II Article 25(2) - Personal Circumstances (Q1)
-- ✓ FINRA Rule 2111 - Customer-Specific Suitability
-- ✓ SEBI IA Regulations 2013 - Client Profiling Requirements
-- ✓ CFA Institute Standards - Professional Suitability Assessment
--
-- ═══════════════════════════════════════════════════════════════════════

-- End of seed_suitability_questions.sql (Version 2.0 - Top 8 Questions)
