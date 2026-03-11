-- CREATE TEST APPLICATIONS
-- Run this in Supabase SQL Editor to create sample applications for testing

-- First, let's create some test users if they don't exist
-- (Assuming user_profiles table exists and has some users)

-- Get some scheme IDs to create applications for
-- These should match the schemes from demo_seed_data.sql

INSERT INTO scheme_applications (citizen_id, scheme_id, status, application_data, submitted_at, review_notes, reviewed_at, reviewed_by)
VALUES 
    -- Test application 1: Pending
    (
        (SELECT id FROM user_profiles WHERE role = 'citizen' LIMIT 1),
        (SELECT id FROM schemes WHERE title = 'National Agriculture Relief Fund' LIMIT 1),
        'pending',
        '{"age": 35, "occupation": "farmer", "annual_income": 300000, "state": "Punjab", "land_acres": 5, "bank_account": "1234567890"}',
        NOW() - INTERVAL '2 days',
        NULL,
        NULL,
        NULL
    ),
    -- Test application 2: Under Review
    (
        (SELECT id FROM user_profiles WHERE role = 'citizen' LIMIT 1),
        (SELECT id FROM schemes WHERE title = 'Urban Housing Subsidy Scheme' LIMIT 1),
        'under_review',
        '{"age": 28, "occupation": "teacher", "annual_income": 600000, "state": "Maharashtra", "city": "Mumbai", "bank_account": "0987654321"}',
        NOW() - INTERVAL '5 days',
        'Application is being reviewed for eligibility verification',
        NOW() - INTERVAL '1 day',
        (SELECT id FROM user_profiles WHERE role = 'analyst' LIMIT 1)
    ),
    -- Test application 3: Approved
    (
        (SELECT id FROM user_profiles WHERE role = 'citizen' OFFSET 1 LIMIT 1),
        (SELECT id FROM schemes WHERE title = 'Merit-Based Student Scholarship' LIMIT 1),
        'approved',
        '{"age": 20, "occupation": "student", "annual_family_income": 200000, "state": "Karnataka", "college": "IIT Bangalore", "course": "Computer Science", "bank_account": "1122334455"}',
        NOW() - INTERVAL '10 days',
        'Student scholarship approved based on merit and family income criteria',
        NOW() - INTERVAL '3 days',
        (SELECT id FROM user_profiles WHERE role = 'admin' LIMIT 1)
    ),
    -- Test application 4: Rejected
    (
        (SELECT id FROM user_profiles WHERE role = 'citizen' OFFSET 2 LIMIT 1),
        (SELECT id FROM schemes WHERE title = 'MSME Digital Transformation Grant' LIMIT 1),
        'rejected',
        '{"age": 45, "occupation": "business_owner", "annual_income": 1500000, "state": "Gujarat", "business_type": "manufacturing", "bank_account": "5544332211"}',
        NOW() - INTERVAL '7 days',
        'Business income exceeds the MSME eligibility criteria of ₹25 Lakhs per annum',
        NOW() - INTERVAL '4 days',
        (SELECT id FROM user_profiles WHERE role = 'analyst' LIMIT 1)
    ),
    -- Test application 5: Another pending
    (
        (SELECT id FROM user_profiles WHERE role = 'citizen' OFFSET 1 LIMIT 1),
        (SELECT id FROM schemes WHERE title = 'Green Energy Adoption Subsidy' LIMIT 1),
        'pending',
        '{"age": 38, "occupation": "engineer", "annual_income": 800000, "state": "Rajasthan", "property_type": "residential", "bank_account": "9988776655"}',
        NOW() - INTERVAL '1 day',
        NULL,
        NULL,
        NULL
    );

-- Verification query
SELECT 
    sa.id,
    sa.status,
    sa.submitted_at,
    s.title as scheme_title,
    up.email as citizen_email
FROM scheme_applications sa
JOIN schemes s ON sa.scheme_id = s.id
LEFT JOIN user_profiles up ON sa.citizen_id = up.id
ORDER BY sa.submitted_at DESC;
