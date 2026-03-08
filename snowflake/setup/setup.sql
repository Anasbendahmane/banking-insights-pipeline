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
