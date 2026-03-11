-- CHECK AND FIX USER ROLE
-- Run this in Supabase SQL Editor to check your current user role and fix it

-- First, let's see what users exist and their roles
SELECT 
    au.id as auth_user_id,
    au.email as auth_email,
    up.id as profile_id,
    up.email as profile_email,
    up.role,
    up.full_name,
    up.created_at
FROM auth.users au
LEFT JOIN user_profiles up ON au.id = up.id
ORDER BY au.created_at DESC;

-- If you see your user but the role is not 'admin' or 'analyst', run this to update it:
-- Replace 'your-email@example.com' with your actual email

-- UPDATE user_profiles 
-- SET role = 'admin' 
-- WHERE email = 'your-email@example.com';

-- If you don't see a profile for your user, create one:
-- Replace the values with your actual user info

-- INSERT INTO user_profiles (id, email, full_name, role, created_at, updated_at)
-- VALUES (
--     'your-auth-user-id',  -- Get this from the first query
--     'your-email@example.com',
--     'Your Name',
--     'admin',
--     NOW(),
--     NOW()
-- );

-- After fixing, run this to verify:
SELECT 
    au.email,
    up.role,
    CASE 
        WHEN up.role IN ('admin', 'analyst', 'super_admin') THEN '✅ Has permission'
        ELSE '❌ No permission'
    END as permission_status
FROM auth.users au
LEFT JOIN user_profiles up ON au.id = up.id
WHERE au.email = 'your-email@example.com';  -- Replace with your email
