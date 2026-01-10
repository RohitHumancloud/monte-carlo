-- Monte Carlo Database Setup Script
-- Run this with: psql -U postgres -f setup_database.sql

-- Create development database
CREATE DATABASE monte_carlo_dev;

-- Create test database
CREATE DATABASE monte_carlo_test;

-- Create database user with password
CREATE USER monte_carlo_user WITH PASSWORD 'monte_carlo_pass';

-- Grant privileges on development database
GRANT ALL PRIVILEGES ON DATABASE monte_carlo_dev TO monte_carlo_user;

-- Grant privileges on test database
GRANT ALL PRIVILEGES ON DATABASE monte_carlo_test TO monte_carlo_user;

-- Display success message
\echo 'Databases created successfully!'
\echo 'Development DB: monte_carlo_dev'
\echo 'Test DB: monte_carlo_test'
\echo 'User: monte_carlo_user'
\echo 'Password: monte_carlo_pass'
