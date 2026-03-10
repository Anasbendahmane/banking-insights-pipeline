-- CREATE warehouse
create or replace warehouse banking_warehouse
    with warehouse_size ='X-SMALL'
      AUTO_SUSPEND = 60
      AUTO_RESUME =TRUE;
--create database
create or replace database banking_db;

--create schema
create or replace schema banking_db.RAW;
create or replace schema banking_db.staging;
create or replace schema banking_db.marts;
create or replace schema banking_db.snapshots;

DROP schema banking_db.PUBLIC;

-- create roles

create role if not exists rl_analyst;
create role if not exists rl_dbt;
create role if not exists rl_ingestion;


--grant PRIVILEGES
--------rl_ingestion
GRANT USAGE on warehouse banking_warehouse to role rl_ingestion;
GRANT USAGE on database banking_db to role rl_ingestion;
GRANT usage ,create pipe , create task ,create procedure, create table, create stage on schema banking_db.RAW to role rl_ingestion;
GRANT select , insert on future tables in schema banking_db.RAW to role rl_ingestion;
GRANT OPERATE ON FUTURE PIPES in schema banking_db.RAW to role rl_ingestion;
GRANT OPERATE ON FUTURE TASKS IN SCHEMA banking_db.RAW to role rl_ingestion;

--------rl_dbt
GRANT USAGE ON WAREHOUSE banking_warehouse to role rl_dbt;
GRANT USAGE ON database banking_db to role rl_dbt;
--raw schema
GRANT USAGE ON SCHEMA banking_db.raw to role rl_dbt;
GRANT SELECT ON FUTURE TABLES IN SCHEMA banking_db.raw to role rl_dbt;
--staging schema
GRANT USAGE , CREATE TABLE ,CREATE VIEW on schema banking_db.staging to role rl_dbt;
GRANT SELECT ON FUTURE TABLES in SCHEMA banking_db.staging to role rl_dbt;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA banking_db.staging to role rl_dbt;
--marts schema
GRANT USAGE ,create table,create view on schema banking_db.marts to role rl_dbt;
GRANT select on future tables in schema banking_db.marts to role rl_dbt;
GRANT SELECT ON FUTURE VIEWS in schema banking_db.marts to role rl_dbt;
-- snapshots schema 
GRANT USAGE ,create table on schema banking_db.snapshots to role rl_dbt;
GRANT select on future tables in schema banking_db.snapshots to role rl_dbt;

-- rl_analyst
GRANT USAGE ON WAREHOUSE banking_warehouse to role rl_analyst;
GRANT USAGE ON DATABASE banking_db to role rl_analyst;
GRANT USAGE ON SCHEMA banking_db.staging to role rl_analyst;
GRANT USAGE ON SCHEMA banking_db.marts to role rl_analyst;
GRANT SELECT ON FUTURE TABLES IN schema banking_db.marts to role rl_analyst;
GRANT SELECT ON FUTURE TABLES IN schema banking_db.staging to role rl_analyst;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA banking_db.marts to role rl_analyst;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA banking_db.staging to role rl_analyst;


--- create users
create user usr_ingestion password='ingestion1234' ;
create user usr_dbt password ='dbt1234';
create user usr_analyst password='analyst1234' ;

-- GRANT roles to users
GRANT ROLE rl_ingestion to role  sysadmin;
GRANT ROLE rl_dbt to role sysadmin;
GRANT ROLE rl_analyst to role sysadmin;

GRANT ROLE rl_ingestion to user usr_ingestion;
GRANT ROLE rl_dbt to user usr_dbt;
GRANT ROLE rl_analyst to user usr_analyst;



