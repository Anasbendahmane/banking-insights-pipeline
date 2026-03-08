use role accountadmin;

-- Création de la storage integration
CREATE OR REPLACE storage integration S3_banking_storage  
    type = external_stage
    storage_provider ='S3'
    ENABLED= TRUE
    STORAGE_ALLOWED_LOCATIONS = ('s3://banking-insights-bucket/')
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::17348072454:role/role_access_snowflake';


-- Vérification : copier STORAGE_AWS_IAM_USER_ARN et STORAGE_AWS_EXTERNAL_ID
-- et les mettre dans la Trust Policy du rôle IAM sur AWS
DESC integration S3_banking_storage;