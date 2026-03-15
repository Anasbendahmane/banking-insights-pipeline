use role accountadmin;

-- Create storage integration between Snowflake and AWS S3
CREATE OR REPLACE storage integration S3_banking_storage  
    type = external_stage
    storage_provider ='S3'
    ENABLED= TRUE
    STORAGE_ALLOWED_LOCATIONS = ('s3://banking-insights-bucket/')
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::17348072454:role/role_access_snowflake';

-- Copy STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID
-- and add them to the Trust Policy of the IAM role on AWS
DESC integration S3_banking_storage;