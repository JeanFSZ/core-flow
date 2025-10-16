-- CoreFlow Database Initialization Script
-- This script runs when PostgreSQL container starts for the first time

-- Create databases for different services
CREATE DATABASE cms_service;
CREATE DATABASE api_gateway;
CREATE DATABASE ai_service;
CREATE DATABASE blockchain_service;
CREATE DATABASE payments_service;

-- Create users for each service (with limited permissions)
CREATE USER cms_user WITH PASSWORD 'cms_password';
CREATE USER gateway_user WITH PASSWORD 'gateway_password';
CREATE USER ai_user WITH PASSWORD 'ai_password';
CREATE USER blockchain_user WITH PASSWORD 'blockchain_password';
CREATE USER payments_user WITH PASSWORD 'payments_password';

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE cms_service TO cms_user;
GRANT ALL PRIVILEGES ON DATABASE api_gateway TO gateway_user;
GRANT ALL PRIVILEGES ON DATABASE ai_service TO ai_user;
GRANT ALL PRIVILEGES ON DATABASE blockchain_service TO blockchain_user;
GRANT ALL PRIVILEGES ON DATABASE payments_service TO payments_user;

-- Create shared schema for common tables (if needed)
-- \c cms_service;
-- CREATE SCHEMA IF NOT EXISTS shared;

-- Log completion
DO $$
BEGIN
    RAISE NOTICE 'CoreFlow database initialization completed successfully';
END $$;
