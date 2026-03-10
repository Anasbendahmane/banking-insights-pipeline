USE ROLE RL_INGESTION;
USE WAREHOUSE BANKING_WAREHOUSE;



---stage for TRANSACTIONS
create or replace stage banking_db.RAW.transaction_stage 
file_format= (type=csv,field_delimiter=',',skip_header=1)
URL='s3://banking-insights-bucket/transactions/'
storage_integration = S3_banking_storage ;


----stage for users
create or replace stage banking_db.RAW.users_stage 
file_format= (type=csv,field_delimiter=',',skip_header=1)
URL='s3://banking-insights-bucket/users/'
storage_integration = S3_banking_storage ;


--- stage for cards

create or replace stage banking_db.RAW.cards_stage 
file_format= (type=csv,field_delimiter=',',skip_header=1)
URL='s3://banking-insights-bucket/cards/'
storage_integration = S3_banking_storage ;


LIST @banking_db.raw.transaction_stage;
