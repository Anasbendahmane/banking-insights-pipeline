with cte_transaction as(
    select

        *
    from {{ ref('int_transaction_enriched') }}

),cte_mcc as (

    select  

        mcc,
        edited_description as merchant_details
    from {{ ref('mcc_codes') }}
),cte_detailed_transactions as(

    select
        t.*,
        e.merchant_details
    from cte_transaction as t
    left join cte_mcc as e on e.mcc = t.mcc


),cte_final as (
    select
       merchant_id,
       mcc,
       merchant_details,
       count(*) as total_transactions,
       SUM(CASE WHEN transaction_category='Purchase' THEN amount ELSE 0 END)  as total_spent,
       SUM(CASE WHEN transaction_category='Refund' THEN amount ELSE 0 END)  as total_refund,
       AVG(amount) as avg_transaction_amount,
       COUNT(CASE WHEN is_fraud= 'true' then 1 else null END) as total_fraud_transactions,
       COUNT(CASE WHEN is_fraud= 'true' then 1 else null END) * 100 / count(*) as fraud_rate,
       MIN(transaction_timestamp)  as first_transaction_date,
       MAX(transaction_timestamp)  as last_transaction_date
    

    from cte_detailed_transactions
    group by merchant_id,mcc,merchant_details




)

select
    *
from cte_final
