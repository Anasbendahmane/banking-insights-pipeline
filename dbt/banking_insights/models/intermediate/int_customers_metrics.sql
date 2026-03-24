{{
  config(
    materialized = 'table',
    )
}}

with cte_spent as (

    select
        *
    from {{ ref('int_transaction_enriched') }}

),cte_metrics as (
    select
       user_id,
       count(*) as total_transactions,
       SUM(CASE WHEN transaction_category='Purchase' THEN amount ELSE 0 END)  as total_spent,
       SUM(CASE WHEN transaction_category='Refund' THEN amount ELSE 0 END)  as total_refund,
       AVG(amount) as avg_transaction_amount,
       COUNT(CASE WHEN is_fraud= 'true' then 1 else null END) as total_fraud_transactions,
       COUNT(CASE WHEN is_fraud= 'true' then 1 else null END) * 100 / count(*) as fraud_rate,
       MIN(transaction_timestamp)  as first_transaction_date,
       MAX(transaction_timestamp)  as last_transaction_date

    from cte_spent  
    group by user_id
)

select
    *

from cte_metrics