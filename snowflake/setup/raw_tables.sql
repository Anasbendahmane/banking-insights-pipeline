USE ROLE RL_INGESTION;
USE WAREHOUSE BANKING_WAREHOUSE;

USE DATABASE BANKING_DB;
USE SCHEMA RAW;

CREATE OR REPLACE Table USERS_RAW(
    Person string,
    Current_Age Number,
    Retirement_Age Number,
    Birth_year Number,
    Birth_month Number,
    Gender string,
    Address string,
    Appartment string,
    City string,
    State string,
    Zipcode Number,
    Latitude Float,
    Longitude Float,
    Per_capita_Income_Zipcode string,
    Yearly_Income string ,
    Total_Debt string,
    FICO_Score Number,
    Num_Credit_Cards Number,
    loaded_at timestamp_ntz

);

CREATE OR REPLACE Table CARDS_RAW(
    User int,
    Card_index int,
    Card_brand string,
    Card_type string,
    Card_number int,
    Expires string,
    CVV int,
    Has_chip string,
    Cards_issued int,
    Credit_Limit string,
    Acct_open_date string,
    Year_pin_last_changed int,
    Card_On_Dark_Web string,
    loaded_at timestamp_ntz


);

CREATE OR REPLACE TABLE TRANSACTIONS_RAW(
    User int,
    Card int,
    Year Number,
    Month Number,
    Day Number,
    Time string,
    Amount string,
    Use_Chip string,
    Merchant_Name VARCHAR(100),
    Merchant_City string,
    Merchant_State string,
    Zip float,
    MCC number,
    Errors string,
    is_fraud string,
    loaded_at timestamp_ntz
);

SHOW TABLES IN SCHEMA banking_db.RAW;