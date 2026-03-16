-- ============================================================
-- Stored procedures for full reload of RAW tables from S3
-- Each procedure truncates the target table before loading
-- to avoid duplicates on re-run
-- ============================================================

use role rl_ingestion;
use warehouse banking_warehouse;
use database banking_db;
use schema RAW;

-- Load users data from S3 into USERS_RAW
CREATE OR REPLACE procedure proc_user()
    RETURNS string
    language sql
    execute as caller
AS
$$
BEGIN

    TRUNCATE TABLE BANKING_DB.RAW.USERS_RAW;
    COPY INTO USERS_RAW(Person, current_age, retirement_age, birth_year, birth_month, gender, address, appartment, city, state, zipcode, latitude, longitude, PER_CAPITA_INCOME_ZIPCODE, yearly_income, total_debt, fico_score, num_credit_cards,loaded_at)
    from
        (select
            $1 as Person,
            $2 as current_age,
            $3 as retirement_age,
            $4 as birth_year,
            $5 as birth_month,
            $6 as gender,
            $7 as address,
            $8 as appartment,
            $9 as city,
            $10 as state,
            $11 as zipcode,
            $12 as latitude,
            $13 as longitude,
            $14 as PER_CAPITA_INCOME_ZIPCODE,
            $15 as yearly_income,
            $16 as total_debt,
            $17 as fico_score,
            $18 as num_credit_cards,
            METADATA$FILE_LAST_MODIFIED
            
        
        from @BANKING_DB.RAW.USERS_STAGE);
    return 'loading ok !!';
END;

$$;


-- Load cards data from S3 into CARDS_RAW

CREATE OR REPLACE PROCEDURE proc_card()
    RETURNS string
    LANGUAGE sql
    EXECUTE as caller
AS
$$
BEGIN
    TRUNCATE TABLE BANKING_DB.RAW.CARDS_RAW;
    COPY INTO BANKING_DB.RAW.CARDS_RAW(User, Card_index, Card_brand, Card_type, Card_number, Expires, CVV, Has_chip, Cards_issued, Credit_Limit, Acct_open_date, Year_pin_last_changed, Card_On_Dark_Web,loaded_at)
    from(
        select
            $1 as User,
            $2 as Card_index,
            $3 as Card_brand,
            $4 as Card_type,
            $5 as Card_number,
            $6 as Expires,
            $7 as CVV,
            $8 as Has_chip,
            $9 as Cards_issued,
            $10 as Credit_Limit,
            $11 as Acct_open_date,
            $12 as Year_pin_last_changed,
            $13 as Card_On_Dark_Web,
            METADATA$FILE_LAST_MODIFIED

        from @BANKING_DB.RAW.CARDS_STAGE


    );
    Return 'load ok!!';

END;
$$;

CREATE OR REPLACE PROCEDURE proc_transactions()
    RETURNS string
    LANGUAGE sql
    EXECUTE AS caller

AS
$$
BEGIN
    TRUNCATE TABLE BANKING_DB.RAW.TRANSACTIONS_RAW;
    COPY INTO BANKING_DB.RAW.TRANSACTIONS_RAW(User, Card, Year, Month, Day, Time, Amount, Use_Chip, Merchant_Name, Merchant_City, Merchant_State, Zip, MCC, Errors, is_fraud,loaded_at)
    FROM(
        select
            $1 as User,
            $2 as Card,
            $3 as Year,
            $4 as Month,
            $5 as Day,
            $6 as Time,
            $7 as Amount,
            $8 as Use_chip,
            $9 as Merchant_Name,
            $10 as Merchant_city,
            $11 as Merchant_state,
            $12 as Zip,
            $13 as MCC,
            $14 as Errors,
            $15 as is_fraud,
            METADATA$FILE_LAST_MODIFIED

        from @BANKING_DB.RAW.TRANSACTION_STAGE
    );

    return 'load ok!!';


END;

$$;