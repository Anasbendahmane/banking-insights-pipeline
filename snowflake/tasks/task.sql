USE ROLE RL_INGESTION;
use warehouse banking_warehouse;
use database banking_db;
use schema RAW;

CREATE OR REPLACE TASK insert_user
warehouse ='banking_warehouse'
schedule = '60 MINUTES'
AS 
    call BANKING_DB.RAW.PROC_USER();


EXECUTE TASK insert_user ;