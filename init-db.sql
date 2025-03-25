-- Set up any additional database configurations
ALTER SYSTEM SET shared_preload_libraries = 'pgvector';

-- Create extensions in template1 so they are available in all new databases
\c template1;
CREATE EXTENSION IF NOT EXISTS vector;

-- Create the database
CREATE DATABASE unichat_production;
\c unichat_production;

-- Enable pgvector extension in the new database
CREATE EXTENSION IF NOT EXISTS vector;
