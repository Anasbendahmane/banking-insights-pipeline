use role rl_ingestion;
use warehouse banking_warehouse;
use database banking_db;
use schema RAW;


CREATE OR REPLACE procedure proc_user()
    RETURNS string
    language sql
    execute as caller
AS
$$
BEGIN
    COPY INTO USERS_RAW(Person, current_age, retirement_age, birth_year, birth_month, gender, address, appartment, city, state, zipcode, latitude, longitude, PER_CAPITA_INCOME_ZIPCODE, yearly_income, total_debt, fico_score, num_credit_cards)
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
            $18 as num_credit_cards
        
        from @BANKING_DB.RAW.USERS_STAGE);
    return 'loading ok !!';
END;

$$;

