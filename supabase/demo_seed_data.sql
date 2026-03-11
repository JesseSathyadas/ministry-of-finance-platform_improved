-- ============================================
-- DEMO SEED DATA: Ministry of Finance Platform
-- ============================================
-- All column names verified against live Supabase database schema.
--
-- REAL TABLE COLUMNS (queried from information_schema):
--
-- financial_metrics : id, metric_name, metric_value, metric_type,
--                     department, fiscal_year, quarter, recorded_at
--
-- ai_insights       : id, insight_type, title, description,
--                     confidence_score, recommendations (jsonb),
--                     data_sources (array), generated_at, expires_at
--
-- anomalies         : id, metric_name, metric_category, detected_at,
--                     expected_value, actual_value, deviation, severity,
--                     explanation, is_investigated, investigated_by,
--                     investigation_notes, created_at
--
-- forecasts         : id, forecast_type, target_period,
--                     predicted_values (jsonb), confidence_interval (jsonb),
--                     model_version, created_at, updated_at
--
-- schemes           : id, title, description, category,
--                     eligibility_criteria (text), benefits_description,
--                     required_documents (array), max_applications,
--                     current_applications, deadline, status,
--                     created_at, updated_at
--
-- trend_results     : id, metric_name, metric_category, trend_direction,
--                     slope, confidence, period_start, period_end,
--                     data_points_analyzed, explanation, created_at
-- ============================================

-- Ensure UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- ============================================
-- 1. FINANCIAL METRICS (90 days)
-- ============================================

-- Daily Tax Revenue (last 90 days)
INSERT INTO financial_metrics (metric_name, metric_value, metric_type, department, fiscal_year, quarter, recorded_at)
SELECT
    'Daily Tax Revenue',
    (8500000000 + (random() * 2000000000))::numeric(20,2),
    'revenue',
    'Central Board of Direct Taxes',
    2026,
    CASE
        WHEN EXTRACT(MONTH FROM d) IN (4,5,6)    THEN 1
        WHEN EXTRACT(MONTH FROM d) IN (7,8,9)    THEN 2
        WHEN EXTRACT(MONTH FROM d) IN (10,11,12) THEN 3
        ELSE 4
    END,
    d
FROM generate_series(NOW() - INTERVAL '90 days', NOW(), INTERVAL '1 day') AS d;

-- Daily Government Expenditure (last 90 days)
INSERT INTO financial_metrics (metric_name, metric_value, metric_type, department, fiscal_year, quarter, recorded_at)
SELECT
    'Daily Government Expenditure',
    (7200000000 + (random() * 1800000000))::numeric(20,2),
    'expenditure',
    'Controller General of Accounts',
    2026,
    CASE
        WHEN EXTRACT(MONTH FROM d) IN (4,5,6)    THEN 1
        WHEN EXTRACT(MONTH FROM d) IN (7,8,9)    THEN 2
        WHEN EXTRACT(MONTH FROM d) IN (10,11,12) THEN 3
        ELSE 4
    END,
    d
FROM generate_series(NOW() - INTERVAL '90 days', NOW(), INTERVAL '1 day') AS d;

-- GDP Growth Rate (quarterly)
INSERT INTO financial_metrics (metric_name, metric_value, metric_type, department, fiscal_year, quarter, recorded_at)
VALUES
    ('GDP Growth Rate', 7.2, 'gdp', 'Ministry of Statistics', 2025, 3, NOW() - INTERVAL '270 days'),
    ('GDP Growth Rate', 7.5, 'gdp', 'Ministry of Statistics', 2025, 4, NOW() - INTERVAL '180 days'),
    ('GDP Growth Rate', 7.8, 'gdp', 'Ministry of Statistics', 2026, 1, NOW() - INTERVAL '90 days'),
    ('GDP Growth Rate', 8.1, 'gdp', 'Ministry of Statistics', 2026, 2, NOW());

-- Consumer Price Index / Inflation (monthly)
INSERT INTO financial_metrics (metric_name, metric_value, metric_type, department, fiscal_year, quarter, recorded_at)
SELECT
    'Consumer Price Index',
    (4.5 + (random() * 1.5))::numeric(20,2),
    'inflation',
    'Reserve Bank of India',
    2026,
    CASE
        WHEN EXTRACT(MONTH FROM d) IN (4,5,6)    THEN 1
        WHEN EXTRACT(MONTH FROM d) IN (7,8,9)    THEN 2
        WHEN EXTRACT(MONTH FROM d) IN (10,11,12) THEN 3
        ELSE 4
    END,
    d
FROM generate_series(NOW() - INTERVAL '90 days', NOW(), INTERVAL '30 days') AS d;

-- Fiscal Deficit (quarterly)
INSERT INTO financial_metrics (metric_name, metric_value, metric_type, department, fiscal_year, quarter, recorded_at)
VALUES
    ('Fiscal Deficit', 5.8, 'deficit', 'Ministry of Finance', 2025, 3, NOW() - INTERVAL '270 days'),
    ('Fiscal Deficit', 5.6, 'deficit', 'Ministry of Finance', 2025, 4, NOW() - INTERVAL '180 days'),
    ('Fiscal Deficit', 5.4, 'deficit', 'Ministry of Finance', 2026, 1, NOW() - INTERVAL '90 days'),
    ('Fiscal Deficit', 5.2, 'deficit', 'Ministry of Finance', 2026, 2, NOW());

-- Department Budget Allocations FY2026
INSERT INTO financial_metrics (metric_name, metric_value, metric_type, department, fiscal_year, quarter, recorded_at)
VALUES
    ('Ministry of Agriculture Budget',   50000000000, 'budget_allocation', 'Budget Division', 2026, 1, NOW()),
    ('Ministry of Housing Budget',       75000000000, 'budget_allocation', 'Budget Division', 2026, 1, NOW()),
    ('Ministry of Education Budget',     40000000000, 'budget_allocation', 'Budget Division', 2026, 1, NOW()),
    ('Ministry of Health Budget',        60000000000, 'budget_allocation', 'Budget Division', 2026, 1, NOW()),
    ('Agriculture Scheme Disbursed',      5000000000, 'expenditure', 'Ministry of Agriculture', 2026, 1, NOW() - INTERVAL '10 days'),
    ('Agriculture Scheme Disbursed',      7500000000, 'expenditure', 'Ministry of Agriculture', 2026, 1, NOW() - INTERVAL '2 days'),
    ('Housing Scheme Disbursed',         15000000000, 'expenditure', 'Ministry of Housing',     2026, 1, NOW() - INTERVAL '5 days');


-- ============================================
-- 2. GOVERNMENT SCHEMES
-- ============================================
-- Note: real columns are title, description, category, eligibility_criteria (TEXT),
-- benefits_description, required_documents (ARRAY), max_applications,
-- current_applications, deadline, status

INSERT INTO schemes (title, description, category, eligibility_criteria, benefits_description, required_documents, max_applications, current_applications, deadline, status)
VALUES
(
    'National Agriculture Relief Fund',
    'Direct income support to rural farmers covering crop losses and input costs. Disbursed directly to bank accounts.',
    'Agriculture',
    'Occupation: Farmer | Max Annual Income: ₹5 Lakhs | Residence: Rural',
    '₹6,000 per year direct bank transfer. Crop loss compensation up to ₹50,000.',
    ARRAY['Aadhaar Card', 'Land Ownership Proof', 'Bank Passbook', 'Farmer Registration Certificate'],
    50000, 0, NOW() + INTERVAL '180 days', 'active'
),
(
    'Urban Housing Subsidy Scheme',
    'Interest subsidies and financial assistance for affordable housing in urban areas for the economically weaker section.',
    'Housing',
    'Residence: Urban | Max Annual Income: ₹8 Lakhs',
    '6% interest subsidy on home loans. Financial assistance up to ₹2.5 Lakhs for construction.',
    ARRAY['Aadhaar Card', 'Income Certificate', 'Property Documents', 'Bank Statement'],
    20000, 0, NOW() + INTERVAL '120 days', 'active'
),
(
    'Merit-Based Student Scholarship',
    'Annual scholarships for meritorious students from economically weaker sections pursuing higher education.',
    'Education',
    'Occupation: Student | Max Annual Family Income: ₹2.5 Lakhs | Age: 16–28 years',
    '₹50,000 per year tuition fee waiver. Monthly maintenance allowance of ₹2,000.',
    ARRAY['Aadhaar Card', 'Mark Sheets (last 2 years)', 'Income Certificate', 'College Admission Proof'],
    30000, 0, NOW() + INTERVAL '90 days', 'active'
),
(
    'MSME Digital Transformation Grant',
    'Grants to micro, small, and medium enterprises to adopt digital tools and technology for business modernization.',
    'Commerce',
    'Business Type: MSME | Occupation: Self-Employed / Employed',
    'Up to ₹5 Lakhs grant. Free digital literacy and tools training included.',
    ARRAY['MSME Registration Certificate', 'Bank Account Details', 'Business Plan', 'GST Certificate'],
    10000, 0, NOW() + INTERVAL '150 days', 'active'
),
(
    'Green Energy Adoption Subsidy',
    'Subsidy for households and businesses adopting renewable energy systems including solar and wind installations.',
    'Energy',
    'Residence: Rural or Urban | No income restriction',
    '40% subsidy on solar panel installation. 20% subsidy on wind energy systems.',
    ARRAY['Aadhaar Card', 'Property Ownership Proof', 'Electricity Bill', 'Installation Quotation'],
    25000, 0, NOW() + INTERVAL '200 days', 'active'
),
(
    'Startup India Innovation Fund',
    'Seed funding and mentorship for technology and innovation startups at proof-of-concept stage.',
    'Commerce',
    'Age: 21–40 years | Occupation: Employed or Unemployed with a business idea',
    'Up to ₹20 Lakhs seed grant. 12 months free incubation support and mentorship.',
    ARRAY['Aadhaar Card', 'Business Proposal Document', 'Educational Certificates', 'Bank Account Details'],
    5000, 0, NOW() + INTERVAL '90 days', 'active'
),
(
    'Senior Citizen Health and Welfare Scheme',
    'Comprehensive health coverage and regular pension support for senior citizens above 60 years.',
    'Health',
    'Min Age: 60 years',
    '₹5 Lakhs annual health insurance coverage. Monthly pension based on contribution history.',
    ARRAY['Aadhaar Card', 'Age Proof', 'Bank Passbook', 'Medical Certificate'],
    100000, 0, NULL, 'active'
),
(
    'Women Entrepreneurship Mission',
    'Collateral-free finance and business development training for women-led businesses across India.',
    'Women and Child Development',
    'Gender: Female | Min Age: 21 years',
    'Collateral-free loans up to ₹10 Lakhs. Free business development and marketing training.',
    ARRAY['Aadhaar Card', 'Business Registration Certificate', 'Bank Account Details', 'Business Plan'],
    15000, 0, NOW() + INTERVAL '180 days', 'active'
);


-- ============================================
-- 3. TREND RESULTS
-- ============================================
INSERT INTO trend_results (metric_name, metric_category, trend_direction, slope, confidence, period_start, period_end, data_points_analyzed, explanation)
VALUES
(
    'Daily Tax Revenue', 'revenue', 'upward', 0.0351, 91.2,
    NOW() - INTERVAL '90 days', NOW(), 90,
    'Tax revenue demonstrates a strong upward trend (slope: 0.0351) with 91.2% confidence. Consistent daily collections over 90 days indicate structural improvements in compliance and robust economic activity in Q4 FY2026.'
),
(
    'Daily Government Expenditure', 'expenditure', 'stable', 0.0089, 78.4,
    NOW() - INTERVAL '90 days', NOW(), 90,
    'Government expenditure is broadly stable with a minor upward drift (slope: 0.0089). The 78.4% confidence reflects minor day-to-day variability typical of scheme disbursement cycles throughout the quarter.'
),
(
    'GDP Growth Rate', 'gdp', 'upward', 0.3000, 93.5,
    NOW() - INTERVAL '365 days', NOW(), 4,
    'GDP growth rate shows strong positive momentum across quarters, rising from 7.2% to 8.1%. This confirms robust economic expansion driven by manufacturing PMI at 57.2 and services PMI at 59.8.'
),
(
    'Consumer Price Index', 'inflation', 'stable', 0.0120, 79.8,
    NOW() - INTERVAL '90 days', NOW(), 3,
    'Inflation remains within the RBI target band of 4–6%, indicating that monetary policy interventions are effective. Minor month-to-month variation but no structural upward drift detected.'
),
(
    'Fiscal Deficit', 'deficit', 'downward', -0.2000, 86.7,
    NOW() - INTERVAL '365 days', NOW(), 4,
    'Fiscal deficit as a percentage of GDP is declining steadily from 5.8% to 5.2%, reflecting improved fiscal consolidation. At current trajectory, the FY2026 target of 5.1% is achievable.'
);


-- ============================================
-- 4. ANOMALIES
-- ============================================
INSERT INTO anomalies (metric_name, metric_category, detected_at, expected_value, actual_value, deviation, severity, explanation, is_investigated)
VALUES
(
    'Daily Tax Revenue', 'revenue',
    NOW() - INTERVAL '15 days',
    9000000000, 7150000000, -20.6, 'high',
    'Significant 20.6% drop in daily tax revenue detected. Likely caused by a public holiday or CBDT system outage. Cross-check with CBDT daily reconciliation report to confirm cause.',
    false
),
(
    'Daily Government Expenditure', 'expenditure',
    NOW() - INTERVAL '7 days',
    7800000000, 11500000000, 47.4, 'critical',
    'Unusual 47.4% spike in government expenditure detected. May be related to emergency welfare disbursement or a batch processing error in the CGA feed. Requires immediate investigation.',
    false
),
(
    'Consumer Price Index', 'inflation',
    NOW() - INTERVAL '30 days',
    5.0, 6.8, 36.0, 'medium',
    'Inflation rate exceeded expected range. Primary driver: 22% surge in vegetable prices and 12% rise in fuel import costs. RBI and Ministry of Agriculture coordination recommended.',
    true
),
(
    'Daily Tax Revenue', 'revenue',
    NOW() - INTERVAL '45 days',
    9200000000, 12600000000, 36.9, 'medium',
    'Unexpectedly high tax revenue inflow detected. Possible cause: advance corporate tax payment deadline. Verify with CBDT if this is a scheduled bulk collection spike.',
    true
);


-- ============================================
-- 5. FORECASTS
-- Note: real columns are forecast_type, target_period,
-- predicted_values (jsonb), confidence_interval (jsonb), model_version
-- ============================================
INSERT INTO forecasts (forecast_type, target_period, predicted_values, confidence_interval, model_version)
VALUES
(
    'revenue',
    '30-day',
    '{"metric_name": "Daily Tax Revenue", "predicted_value": 9800000000, "forecast_days": 30}'::jsonb,
    '{"lower_bound": 9200000000, "upper_bound": 10400000000, "confidence": 85.5}'::jsonb,
    'Linear Regression v1.0'
),
(
    'revenue',
    '60-day',
    '{"metric_name": "Daily Tax Revenue", "predicted_value": 10100000000, "forecast_days": 60}'::jsonb,
    '{"lower_bound": 9300000000, "upper_bound": 10900000000, "confidence": 81.3}'::jsonb,
    'Linear Regression v1.0'
),
(
    'revenue',
    '90-day',
    '{"metric_name": "Daily Tax Revenue", "predicted_value": 10450000000, "forecast_days": 90}'::jsonb,
    '{"lower_bound": 9350000000, "upper_bound": 11550000000, "confidence": 77.9}'::jsonb,
    'Linear Regression v1.0'
),
(
    'gdp',
    '90-day',
    '{"metric_name": "GDP Growth Rate", "predicted_value": 8.3, "unit": "Percentage"}'::jsonb,
    '{"lower_bound": 7.8, "upper_bound": 8.8, "confidence": 88.2}'::jsonb,
    'Linear Regression v1.0'
),
(
    'gdp',
    '180-day',
    '{"metric_name": "GDP Growth Rate", "predicted_value": 8.6, "unit": "Percentage"}'::jsonb,
    '{"lower_bound": 7.9, "upper_bound": 9.3, "confidence": 82.5}'::jsonb,
    'Linear Regression v1.0'
),
(
    'inflation',
    '30-day',
    '{"metric_name": "Consumer Price Index", "predicted_value": 5.3, "unit": "Percentage"}'::jsonb,
    '{"lower_bound": 4.8, "upper_bound": 5.8, "confidence": 80.5}'::jsonb,
    'Exponential Smoothing v1.0'
),
(
    'inflation',
    '60-day',
    '{"metric_name": "Consumer Price Index", "predicted_value": 5.5, "unit": "Percentage"}'::jsonb,
    '{"lower_bound": 4.6, "upper_bound": 6.4, "confidence": 75.2}'::jsonb,
    'Exponential Smoothing v1.0'
),
(
    'expenditure',
    '30-day',
    '{"metric_name": "Daily Government Expenditure", "predicted_value": 8100000000, "forecast_days": 30}'::jsonb,
    '{"lower_bound": 7600000000, "upper_bound": 8600000000, "confidence": 82.0}'::jsonb,
    'Simple Moving Average v1.0'
),
(
    'expenditure',
    '60-day',
    '{"metric_name": "Daily Government Expenditure", "predicted_value": 8400000000, "forecast_days": 60}'::jsonb,
    '{"lower_bound": 7700000000, "upper_bound": 9100000000, "confidence": 78.1}'::jsonb,
    'Simple Moving Average v1.0'
);


-- ============================================
-- 6. AI INSIGHTS
-- Note: real columns are insight_type, title, description,
-- confidence_score, recommendations (jsonb), data_sources (array),
-- generated_at, expires_at
-- ============================================
INSERT INTO ai_insights (insight_type, title, description, confidence_score, recommendations, data_sources, generated_at, expires_at)
VALUES
(
    'revenue_analysis',
    'Sustained Revenue Growth Confirmed',
    'Tax revenue has outperformed Q4 projections by 11.2% over the past 90 days. The linear regression on 90 data points (R²=0.91) confirms this is a structural improvement in collection efficiency — not a seasonal anomaly. Compliance improvements from GST rationalisation are the primary driver.',
    0.91,
    '{"primary": "Consider channelling excess collections into a fiscal buffer fund or pre-payment of short-term government securities to reduce borrowing costs.", "secondary": "Review the Q2 FY2026 budget assumptions and update the nominal revenue projection upwards by 8–10%."}'::jsonb,
    ARRAY['financial_metrics.revenue', 'CBDT Daily Collection Report', 'GST Council Data'],
    NOW() - INTERVAL '2 days',
    NOW() + INTERVAL '30 days'
),
(
    'expenditure_alert',
    'Critical Expenditure Spike Requires Immediate Review',
    'A 47.4% single-day expenditure spike was detected 7 days ago (₹11,500 Cr vs expected ₹7,800 Cr). The anomaly has not yet been investigated. This constitutes either an unrecorded emergency disbursement or a potential data integrity issue in the CGA daily feed.',
    0.89,
    '{"primary": "Initiate urgent review with the Controller General of Accounts within 24 hours.", "secondary": "If confirmed as a data error, correct the source record and re-validate downstream fiscal deficit calculations. If valid, file a supplementary budget note."}'::jsonb,
    ARRAY['financial_metrics.expenditure', 'CGA Daily Feed', 'anomalies'],
    NOW() - INTERVAL '7 days',
    NOW() + INTERVAL '14 days'
),
(
    'gdp_analysis',
    'GDP Acceleration Supports Optimistic FY2026 Budget Revision',
    'GDP growth rate accelerated from 7.2% (Q3 FY2025) to 8.1% (Q2 FY2026), exceeding the IMF projection of 7.4% by 0.7 percentage points. Both manufacturing (PMI: 57.2) and services (PMI: 59.8) are above the expansion threshold of 50.',
    0.94,
    '{"primary": "Upward revise the nominal GDP assumption in the Union Budget supplementary statement by 0.5–0.7 percentage points.", "secondary": "Reassess fiscal deficit target as a % of revised GDP — the 5.1% target may already be achieved at current trajectory without additional consolidation."}'::jsonb,
    ARRAY['financial_metrics.gdp', 'Ministry of Statistics Quarterly Report', 'PMI Manufacturing Index', 'PMI Services Index'],
    NOW() - INTERVAL '3 days',
    NOW() + INTERVAL '60 days'
),
(
    'inflation_alert',
    'Inflation Pressure Building in Food and Fuel Segment',
    'CPI at 6.8% exceeded the upper tolerance band of 6% for the most recent month. Food inflation is running at 9.1%, driven by a 22% surge in vegetable prices. Fuel and core inflation remain within target, suggesting this is a supply-side shock rather than demand-driven inflation.',
    0.80,
    '{"primary": "Coordinate Ministry of Agriculture and MoF to consider: (1) release of vegetable buffer stocks, (2) temporary reduction of import duties on key food commodities.", "secondary": "RBI to monitor closely. MPC may consider a hawkish hold at the next policy meeting."}'::jsonb,
    ARRAY['financial_metrics.inflation', 'Reserve Bank of India CPI Data', 'NAFED Buffer Stock Report'],
    NOW() - INTERVAL '5 days',
    NOW() + INTERVAL '30 days'
),
(
    'deficit_analysis',
    'Fiscal Deficit on Track for FY2026 Target',
    'Quarterly fiscal deficit data shows a consistent downward trend from 5.8% to 5.2% of GDP over four quarters. The linear trend (slope: -0.2 per quarter, R²=0.97) projects the FY2026 year-end deficit at 5.05–5.15% of GDP, within the 5.1% target.',
    0.87,
    '{"primary": "No immediate corrective action required. Maintain current expenditure discipline.", "secondary": "Capital expenditure prioritisation over revenue expenditure in Q3–Q4 will sustain the consolidation trajectory. Avoid ad hoc revenue expenditure additions."}'::jsonb,
    ARRAY['financial_metrics.deficit', 'Ministry of Finance Fiscal Monitor', 'trend_results'],
    NOW() - INTERVAL '1 day',
    NOW() + INTERVAL '90 days'
),
(
    'expenditure_alert',
    'Agriculture Scheme Disbursement Velocity Warning',
    'National Agriculture Relief Fund has disbursed ₹12,500 Cr of its ₹50,000 Cr annual allocation in the first 45 days — a velocity of ₹278 Cr/day. At this rate, the full allocation will be exhausted in approximately 134 days, well before fiscal year-end (March 2027).',
    0.88,
    '{"primary": "Monitor monthly disbursement against the approved phased plan. Initiate a supplementary demand for ₹15,000 Cr to Ministry of Agriculture if velocity continues.", "secondary": "Audit disbursement records to ensure there is no double-counting with state plan allocations. Verify beneficiary list for duplicates."}'::jsonb,
    ARRAY['financial_metrics.expenditure', 'Ministry of Agriculture Scheme Report', 'forecasts'],
    NOW() - INTERVAL '4 days',
    NOW() + INTERVAL '30 days'
);


-- ============================================
-- VERIFICATION QUERIES
-- (Uncomment and run to confirm data loaded)
-- ============================================
-- SELECT metric_type, COUNT(*) FROM financial_metrics GROUP BY metric_type ORDER BY metric_type;
-- SELECT category, COUNT(*) FROM schemes GROUP BY category;
-- SELECT metric_category, trend_direction, confidence FROM trend_results;
-- SELECT severity, is_investigated, COUNT(*) FROM anomalies GROUP BY severity, is_investigated;
-- SELECT forecast_type, target_period FROM forecasts ORDER BY forecast_type, target_period;
-- SELECT insight_type, title, confidence_score FROM ai_insights ORDER BY confidence_score DESC;
