USE ROLE RL_INGESTION;
use warehouse banking_warehouse;
use database banking_db;
use schema RAW;

CREATE OR REPLACE TASK task_user
warehouse = banking_warehouse
schedule = '60 MINUTES'
AS 
    call BANKING_DB.RAW.PROC_USER();


CREATE OR REPLACE TASK task_card
warehouse = banking_warehouse
SCHEDULE = '60 MINUTES'
AS 
    call BANKING_DB.RAW.PROC_CARD();



CREATE OR REPLACE TASK task_transactions
warehouse = banking_warehouse
SCHEDULE = '60 MINUTES'
AS
    call BANKING_DB.RAW.PROC_TRANSACTIONS();


EXECUTE TASK task_user ;
EXECUTE TASK task_card;
EXECUTE TASK task_transactions;