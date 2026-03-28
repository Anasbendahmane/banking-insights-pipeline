# 🏦 Banking Insights Pipeline

> End-to-end data pipeline for banking fraud detection and customer risk analysis — built on **AWS S3**, **Snowflake**, and **dbt**.

---

## 🗂️ Project Structure

```
banking-insights-pipeline/
│
├── snowflake/
│   ├── setup/
│   │   ├── setup.sql                  # Warehouse, database, schemas, roles, users
│   │   ├── raw_tables.sql             # DDL for RAW layer tables
│   │   └── storage_integration.sql   # AWS S3 ↔ Snowflake integration
│   ├── stages/
│   │   └── stages.sql                 # External S3 stages (users, cards, transactions)
│   ├── pipes/
│   │   └── pipe.sql                   # Snowpipe definitions (AUTO_INGEST via SQS)
│   ├── procedures/
│   │   └── procedure_load.sql         # Stored procedures for full reload
│   └── tasks/
│       └── task.sql                   # Scheduled tasks (60 min cadence)
│
└── dbt/banking_insights/
    ├── models/
    │   ├── source/                    # Source declarations (RAW schema)
    │   ├── staging/                   # stg_user, stg_card, stg_transaction
    │   ├── intermediate/              # int_transaction_enriched, int_*_metrics
    │   └── marts/                     # dim_*, fact_* models + dim_date
    ├── macros/                        # get_fico_segment, get_income_segment, saison, get_day, get_risk_level
    ├── seeds/
    │   └── mcc_codes.csv              # Merchant Category Code reference table
    └── tests/
        └── generic/                   # is_positive, valid_timestamp
```

---

## 🏗️ Architecture


<img width="1598" height="704" alt="image" src="https://github.com/user-attachments/assets/8242e131-535a-4984-902a-19da878b6f5d" />



---

## 🔄 Data Flow

<img width="1858" height="657" alt="image" src="https://github.com/user-attachments/assets/35e4321f-2448-4f50-9ce6-e57fc87890f5" />

## 🔐 Snowflake RBAC

| Role | Permissions |
|------|-------------|
| `rl_ingestion` | Create and write to RAW schema, manage pipes, tasks, and procedures |
| `rl_dbt` | Read RAW, write staging and marts schemas |
| `rl_analyst` | Read-only on staging and marts schemas |

---

## 🚀 Getting Started

### 1. Snowflake Setup

```sql
-- Run in order:

-- 1. Infrastructure (warehouse, database, schemas, roles, users)
snowflake/setup/setup.sql

-- 2. AWS S3 storage integration
snowflake/setup/storage_integration.sql
-- Copy STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID into your IAM Trust Policy

-- 3. External stages
snowflake/stages/stages.sql

-- 4. RAW tables DDL
snowflake/setup/raw_tables.sql

-- 5. Snowpipes
snowflake/pipes/pipe.sql

-- 6. Stored procedures + scheduled tasks
snowflake/procedures/procedure_load.sql
snowflake/tasks/task.sql
```

### 2. dbt Setup

```bash
cd dbt/banking_insights

# Install dbt-snowflake adapter
pip install dbt-snowflake

# Install dbt packages (dbt_utils, dbt_date)
dbt deps

# Validate connection
dbt debug

# Load seed data (MCC codes)
dbt seed

# Run all models
dbt run

# Run all tests
dbt test
```

### 3. Configure your profile (`profiles.yml`)

```yaml
banking_insights:
  outputs:
    dev:
      type: snowflake
      account: <your_account>
      user: <your_user>
      password: <your_password>
      role: rl_dbt
      database: banking_db
      warehouse: banking_warehouse
      schema: raw
      threads: 2
  target: dev
```

---

## 📦 dbt Packages

| Package | Version | Usage |
|---------|---------|-------|
| `dbt-labs/dbt_utils` | 1.3.3 | `generate_surrogate_key`, `date_spine`, `star` |
| `godatadriven/dbt_date` | 0.15.x | `month_name` for the date dimension |
