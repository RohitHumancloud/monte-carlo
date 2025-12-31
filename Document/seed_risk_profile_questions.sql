-- ═══════════════════════════════════════════════════════════════════════
-- SEED DATA: RISK PROFILE QUESTIONNAIRE (TOP 8 QUESTIONS)
-- ═══════════════════════════════════════════════════════════════════════
-- Purpose: Insert optimized risk profile assessment questions
-- Based on: Vanguard, Charles Schwab, RBC Wealth Management, CFA Institute
-- Total Questions: 8 (Optimized from 15-question version)
-- Scoring Range: 1-52 points (optimized from 8-35)
-- Assessment Time: 5-7 minutes (reduced from 10-15 minutes)
-- Version: 2.0 - December 2025
-- ═══════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────
-- STEP 1: Insert Questions (Top 8 Most Predictive)
-- ───────────────────────────────────────────────────────────────────────

-- Question 1: Age Group (Weight: 1.0)
INSERT INTO risk_profile_questions (
    question_code, question_text, question_type, category, display_order,
    weight, max_cap_points, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'AGE_GROUP',
    'What is your current age?',
    'SINGLE_SELECT',
    'DEMOGRAPHICS',
    1,
    1.0,
    NULL,
    TRUE,
    'Your age helps us understand your investment time horizon. Younger investors typically have more time to recover from market downturns.',
    'Age is a strong indicator of risk capacity. Younger clients (under 40) can generally accept higher volatility.',
    'Your age affects how long you can invest and how much market fluctuation you can withstand.'
);

-- Question 2: Investment Time Horizon (Weight: 1.5 - MOST CRITICAL)
INSERT INTO risk_profile_questions (
    question_code, question_text, question_type, category, display_order,
    weight, max_cap_points, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'TIME_HORIZON',
    'When do you expect to need a significant portion (more than 1/3) of this investment?',
    'SINGLE_SELECT',
    'DEMOGRAPHICS',
    2,
    1.5,
    NULL,
    TRUE,
    'Your investment time horizon is how long you plan to invest before needing the money. Longer horizons allow for more growth-focused strategies.',
    'THIS IS THE MOST CRITICAL FACTOR. Time horizon determines asset allocation more than any other single factor. <5 years = conservative mandatory.',
    'If you need the money soon, we''ll focus on stability. If it''s far in the future, we can aim for higher growth.'
);

-- Question 3: Primary Investment Objective (Weight: 1.0, Multi-Select, Cap: 8)
INSERT INTO risk_profile_questions (
    question_code, question_text, question_type, category, display_order,
    weight, max_cap_points, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'PRIMARY_OBJECTIVE',
    'What are your primary investment objectives? (Select all that apply)',
    'MULTI_SELECT',
    'GOALS',
    3,
    1.0,
    8,
    TRUE,
    'Your investment objectives guide the strategy we recommend. Different goals require different approaches.',
    'If client selects preservation + speculation, probe deeper. These are contradictory. Focus on priority ranking.',
    'You can have multiple goals, but we''ll need to prioritize them when creating your strategy.'
);

-- Question 4: Emergency Fund Status (Weight: 1.5 - CRITICAL FOR RISK CAPACITY)
INSERT INTO risk_profile_questions (
    question_code, question_text, question_type, category, display_order,
    weight, max_cap_points, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'EMERGENCY_FUND',
    'Do you have an emergency fund covering at least 6 months of living expenses saved separately from this investment?',
    'SINGLE_SELECT',
    'FINANCIAL_CAPACITY',
    4,
    1.5,
    NULL,
    TRUE,
    'An emergency fund protects your investments. Without one, you might need to sell investments at the wrong time during emergencies.',
    'CRITICAL: If no emergency fund exists, recommend establishing one before investing. This affects risk capacity significantly.',
    'Having emergency savings means you won''t need to touch your investments in a crisis, allowing them to grow long-term.'
);

-- Question 5: Years of Investment Experience (Weight: 1.0)
INSERT INTO risk_profile_questions (
    question_code, question_text, question_type, category, display_order,
    weight, max_cap_points, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'YEARS_EXPERIENCE',
    'How many years of investment experience do you have?',
    'SINGLE_SELECT',
    'EXPERIENCE',
    5,
    1.0,
    NULL,
    TRUE,
    'Experience with investing helps you understand market cycles and stay calm during volatility.',
    'Inexperienced investors tend to panic-sell during downturns. Factor this into behavioral coaching needed.',
    'Experience helps you make rational decisions during market ups and downs.'
);

-- Question 6: Maximum Acceptable Loss (Weight: 2.0 - KEY RISK METRIC)
INSERT INTO risk_profile_questions (
    question_code, question_text, question_type, category, display_order,
    weight, max_cap_points, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'MAX_LOSS_TOLERANCE',
    'What is the maximum percentage decline in your portfolio value you could tolerate in a single year before you would reconsider your investment strategy?',
    'SINGLE_SELECT',
    'RISK_TOLERANCE',
    6,
    2.0,
    NULL,
    TRUE,
    'During the 2008 financial crisis, some portfolios fell 40-50%. Knowing your comfort level helps us prepare the right strategy.',
    'Historical context: 2008 crisis = 50% drop, 2020 COVID = 35% drop, 2022 = 20% drop. Use these as reference points.',
    'Think about your reaction if you saw your investment drop by this amount. Would you panic sell or stay invested?'
);

-- Question 7: Market Downturn Response (Weight: 2.0 - BEST BEHAVIORAL PREDICTOR)
INSERT INTO risk_profile_questions (
    question_code, question_text, question_type, category, display_order,
    weight, max_cap_points, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'MARKET_DOWNTURN_RESPONSE',
    'The market has just experienced a sudden 25% decline. Your portfolio is down ₹2,50,000 on an initial investment of ₹10,00,000. What would you do?',
    'SINGLE_SELECT',
    'BEHAVIORAL',
    7,
    2.0,
    NULL,
    TRUE,
    'This tests your likely real-world reaction to a major market drop. Historical context: This happened in March 2020 during COVID-19.',
    'CRITICAL: This predicts actual behavior better than theoretical questions. Use client''s answer to calibrate risk capacity vs tolerance gap.',
    'Be honest about your gut reaction. Many people say they can handle drops but panic when it actually happens.'
);

-- Question 8: Recovery Time Acceptance (Weight: 2.0 - TIME-RISK ALIGNMENT)
INSERT INTO risk_profile_questions (
    question_code, question_text, question_type, category, display_order,
    weight, max_cap_points, is_active, description_for_all, rm_notes, client_notes
) VALUES (
    'RECOVERY_TIME_ACCEPTANCE',
    'If your portfolio experienced a significant decline, how long are you willing to wait for it to recover to its original value?',
    'SINGLE_SELECT',
    'BEHAVIORAL',
    8,
    2.0,
    NULL,
    TRUE,
    'Recovery from major declines can take years. Your patience determines whether aggressive strategies are suitable.',
    'Historical recovery periods: 2008 crisis = 5 years, 2000 dot-com = 7 years, 2020 COVID = 6 months. Set realistic expectations.',
    'Major market drops can take 3-7 years to fully recover. If you need the money sooner, we''ll reduce risk.'
);

-- ───────────────────────────────────────────────────────────────────────
-- STEP 2: Insert Options for Each Question
-- ───────────────────────────────────────────────────────────────────────

-- Q1: Age Group Options
INSERT INTO risk_profile_options (question_id, option_text, points, display_order) VALUES
((SELECT id FROM risk_profile_questions WHERE question_code = 'AGE_GROUP'), 'Under 25', 4, 1),
((SELECT id FROM risk_profile_questions WHERE question_code = 'AGE_GROUP'), '25-35', 3, 2),
((SELECT id FROM risk_profile_questions WHERE question_code = 'AGE_GROUP'), '36-50', 2, 3),
((SELECT id FROM risk_profile_questions WHERE question_code = 'AGE_GROUP'), '51-65', 1, 4),
((SELECT id FROM risk_profile_questions WHERE question_code = 'AGE_GROUP'), 'Over 65', 0, 5);

-- Q2: Time Horizon Options
INSERT INTO risk_profile_options (question_id, option_text, points, display_order) VALUES
((SELECT id FROM risk_profile_questions WHERE question_code = 'TIME_HORIZON'), 'Less than 3 years', 0, 1),
((SELECT id FROM risk_profile_questions WHERE question_code = 'TIME_HORIZON'), '3-5 years', 1, 2),
((SELECT id FROM risk_profile_questions WHERE question_code = 'TIME_HORIZON'), '6-10 years', 2, 3),
((SELECT id FROM risk_profile_questions WHERE question_code = 'TIME_HORIZON'), '11-15 years', 3, 4),
((SELECT id FROM risk_profile_questions WHERE question_code = 'TIME_HORIZON'), 'More than 15 years', 4, 5);

-- Q3: Primary Investment Objective Options (Multi-Select, Cap: 8)
INSERT INTO risk_profile_options (question_id, option_text, points, display_order) VALUES
((SELECT id FROM risk_profile_questions WHERE question_code = 'PRIMARY_OBJECTIVE'), 'Capital preservation (protect what I have)', 1, 1),
((SELECT id FROM risk_profile_questions WHERE question_code = 'PRIMARY_OBJECTIVE'), 'Generate regular income', 2, 2),
((SELECT id FROM risk_profile_questions WHERE question_code = 'PRIMARY_OBJECTIVE'), 'Long-term capital growth', 3, 3),
((SELECT id FROM risk_profile_questions WHERE question_code = 'PRIMARY_OBJECTIVE'), 'Wealth accumulation for retirement', 3, 4),
((SELECT id FROM risk_profile_questions WHERE question_code = 'PRIMARY_OBJECTIVE'), 'Save for a major purchase (home, education)', 2, 5),
((SELECT id FROM risk_profile_questions WHERE question_code = 'PRIMARY_OBJECTIVE'), 'Speculation / maximize returns', 4, 6);

-- Q4: Emergency Fund Status Options
INSERT INTO risk_profile_options (question_id, option_text, points, display_order) VALUES
((SELECT id FROM risk_profile_questions WHERE question_code = 'EMERGENCY_FUND'), 'No emergency fund, this investment might be needed for emergencies', 0, 1),
((SELECT id FROM risk_profile_questions WHERE question_code = 'EMERGENCY_FUND'), 'Less than 3 months of expenses', 1, 2),
((SELECT id FROM risk_profile_questions WHERE question_code = 'EMERGENCY_FUND'), '3-6 months of expenses', 2, 3),
((SELECT id FROM risk_profile_questions WHERE question_code = 'EMERGENCY_FUND'), '6-12 months of expenses', 3, 4),
((SELECT id FROM risk_profile_questions WHERE question_code = 'EMERGENCY_FUND'), 'More than 12 months of expenses saved', 4, 5);

-- Q5: Years of Investment Experience Options
INSERT INTO risk_profile_options (question_id, option_text, points, display_order) VALUES
((SELECT id FROM risk_profile_questions WHERE question_code = 'YEARS_EXPERIENCE'), 'None, I am a first-time investor', 0, 1),
((SELECT id FROM risk_profile_questions WHERE question_code = 'YEARS_EXPERIENCE'), 'Less than 2 years', 1, 2),
((SELECT id FROM risk_profile_questions WHERE question_code = 'YEARS_EXPERIENCE'), '2-5 years', 2, 3),
((SELECT id FROM risk_profile_questions WHERE question_code = 'YEARS_EXPERIENCE'), '5-10 years', 3, 4),
((SELECT id FROM risk_profile_questions WHERE question_code = 'YEARS_EXPERIENCE'), 'More than 10 years', 4, 5);

-- Q6: Maximum Acceptable Loss Options
INSERT INTO risk_profile_options (question_id, option_text, points, display_order) VALUES
((SELECT id FROM risk_profile_questions WHERE question_code = 'MAX_LOSS_TOLERANCE'), 'Any loss makes me very anxious, I would reconsider immediately', 0, 1),
((SELECT id FROM risk_profile_questions WHERE question_code = 'MAX_LOSS_TOLERANCE'), '5% decline', 1, 2),
((SELECT id FROM risk_profile_questions WHERE question_code = 'MAX_LOSS_TOLERANCE'), '10% decline', 2, 3),
((SELECT id FROM risk_profile_questions WHERE question_code = 'MAX_LOSS_TOLERANCE'), '20% decline', 3, 4),
((SELECT id FROM risk_profile_questions WHERE question_code = 'MAX_LOSS_TOLERANCE'), '30% or more decline', 4, 5);

-- Q7: Market Downturn Response Options
INSERT INTO risk_profile_options (question_id, option_text, points, display_order) VALUES
((SELECT id FROM risk_profile_questions WHERE question_code = 'MARKET_DOWNTURN_RESPONSE'), 'Sell everything immediately to prevent further losses', 0, 1),
((SELECT id FROM risk_profile_questions WHERE question_code = 'MARKET_DOWNTURN_RESPONSE'), 'Sell 50% to reduce my exposure', 1, 2),
((SELECT id FROM risk_profile_questions WHERE question_code = 'MARKET_DOWNTURN_RESPONSE'), 'Hold and wait for recovery, but feel very anxious', 2, 3),
((SELECT id FROM risk_profile_questions WHERE question_code = 'MARKET_DOWNTURN_RESPONSE'), 'Hold and not worry, I''m invested for the long term', 3, 4),
((SELECT id FROM risk_profile_questions WHERE question_code = 'MARKET_DOWNTURN_RESPONSE'), 'Buy more to take advantage of lower prices', 4, 5);

-- Q8: Recovery Time Acceptance Options
INSERT INTO risk_profile_options (question_id, option_text, points, display_order) VALUES
((SELECT id FROM risk_profile_questions WHERE question_code = 'RECOVERY_TIME_ACCEPTANCE'), 'Less than 1 year - I cannot wait for recovery', 0, 1),
((SELECT id FROM risk_profile_questions WHERE question_code = 'RECOVERY_TIME_ACCEPTANCE'), '1-2 years', 1, 2),
((SELECT id FROM risk_profile_questions WHERE question_code = 'RECOVERY_TIME_ACCEPTANCE'), '3-4 years', 2, 3),
((SELECT id FROM risk_profile_questions WHERE question_code = 'RECOVERY_TIME_ACCEPTANCE'), '5-7 years', 3, 4),
((SELECT id FROM risk_profile_questions WHERE question_code = 'RECOVERY_TIME_ACCEPTANCE'), 'More than 7 years - I can wait as long as needed', 4, 5);

-- ───────────────────────────────────────────────────────────────────────
-- STEP 3: Verification Queries
-- ───────────────────────────────────────────────────────────────────────

-- Verify all 8 questions inserted
SELECT
    question_code,
    question_text,
    question_type,
    weight,
    max_cap_points,
    category,
    display_order,
    COUNT(o.id) as option_count
FROM risk_profile_questions q
LEFT JOIN risk_profile_options o ON q.id = o.question_id
WHERE q.is_active = TRUE
GROUP BY q.id, q.question_code, q.question_text, q.question_type, q.weight, q.max_cap_points, q.category, q.display_order
ORDER BY q.display_order;

-- Expected output: 8 questions with option counts
-- Q1 (AGE_GROUP): 5 options
-- Q2 (TIME_HORIZON): 5 options
-- Q3 (PRIMARY_OBJECTIVE): 6 options (multi-select, cap 8)
-- Q4 (EMERGENCY_FUND): 5 options
-- Q5 (YEARS_EXPERIENCE): 5 options
-- Q6 (MAX_LOSS_TOLERANCE): 5 options
-- Q7 (MARKET_DOWNTURN_RESPONSE): 5 options
-- Q8 (RECOVERY_TIME_ACCEPTANCE): 5 options

-- Verify scoring calculation
-- Example: Conservative investor profile
-- Age: 51-65 (1 pt × 1.0 = 1.0)
-- Time Horizon: 3-5 years (1 pt × 1.5 = 1.5)
-- Objectives: Capital preservation (1 pt × 1.0 = 1.0)
-- Emergency Fund: 3-6 months (2 pts × 1.5 = 3.0)
-- Experience: None (0 pts × 1.0 = 0.0)
-- Max Loss: 5% (1 pt × 2.0 = 2.0)
-- Downturn Response: Sell 50% (1 pt × 2.0 = 2.0)
-- Recovery Time: 1-2 years (1 pt × 2.0 = 2.0)
-- Total Score: 1.0 + 1.5 + 1.0 + 3.0 + 0.0 + 2.0 + 2.0 + 2.0 = 12.5
-- Risk Category: Conservative (2) [Score range: 10-17]

-- Verify scoring calculation
-- Example: Moderate investor profile (Priya Sharma)
-- Age: 25-35 (3 pts × 1.0 = 3.0)
-- Time Horizon: 3-5 years (1 pt × 1.5 = 1.5)
-- Objectives: Growth (3) + House Purchase (2) = 5 pts × 1.0 = 5.0
-- Emergency Fund: 6-12 months (3 pts × 1.5 = 4.5)
-- Experience: 2-5 years (2 pts × 1.0 = 2.0)
-- Max Loss: 10% (2 pts × 2.0 = 4.0)
-- Downturn Response: Hold and wait (2 pts × 2.0 = 4.0)
-- Recovery Time: 3-4 years (2 pts × 2.0 = 4.0)
-- Total Score: 3.0 + 1.5 + 5.0 + 4.5 + 2.0 + 4.0 + 4.0 + 4.0 = 28.0
-- Risk Category: Balance (4) [Score range: 27-34]

-- Example: Aggressive investor profile
-- Age: Under 25 (4 pts × 1.0 = 4.0)
-- Time Horizon: More than 15 years (4 pts × 1.5 = 6.0)
-- Objectives: Speculation (4) + Retirement (3) + Growth (3) = 8 (capped) × 1.0 = 8.0
-- Emergency Fund: More than 12 months (4 pts × 1.5 = 6.0)
-- Experience: More than 10 years (4 pts × 1.0 = 4.0)
-- Max Loss: 30%+ (4 pts × 2.0 = 8.0)
-- Downturn Response: Buy more (4 pts × 2.0 = 8.0)
-- Recovery Time: More than 7 years (4 pts × 2.0 = 8.0)
-- Total Score: 4.0 + 6.0 + 8.0 + 6.0 + 4.0 + 8.0 + 8.0 + 8.0 = 52.0
-- Risk Category: Speculative (6) [Score range: 44-52]

-- ═══════════════════════════════════════════════════════════════════════
-- RISK SCORE TO RISK CATEGORY MAPPING
-- ═══════════════════════════════════════════════════════════════════════
--
-- Score Range | Category      | Allocation          | Description
-- ------------|---------------|---------------------|---------------------------
-- 1-9         | Secure (1)    | 10% Equity / 90% Debt | Very conservative
-- 10-17       | Conservative (2) | 20% Equity / 80% Debt | Conservative
-- 18-26       | Income (3)    | 40% Equity / 60% Debt | Income-focused
-- 27-34       | Balance (4)   | 60% Equity / 40% Debt | Balanced growth
-- 35-43       | Aggressive (5)| 80% Equity / 20% Debt | Aggressive growth
-- 44-52       | Speculative (6) | 95% Equity / 5% Debt | Very aggressive
--
-- ═══════════════════════════════════════════════════════════════════════

-- End of seed_risk_profile_questions.sql (Version 2.0 - Top 8 Questions)
