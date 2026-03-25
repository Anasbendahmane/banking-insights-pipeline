-- =============================================================
-- Model: dim_merchants
-- Description: Merchant dimension enriched with risk level
--              and online merchant flag derived from
--              transaction patterns and fraud metrics.
-- =============================================================


with cte_merchant as(

    select
        *,
        {{get_risk_level('fraud_rate')}} as risk_level

    from {{ ref('int_merchant_metrics') }}

),cte_merchant2 as (

    select
        merchant_id,
        CASE 
            WHEN merchant_state = 'N/A' THEN 'true'
            ELSE 'false'
        END as is_merchant_online

    from {{ ref('int_transaction_enriched') }}


),cte_join as(

    select
       m.merchant_id,
       m.mcc,
       m.merchant_details,
       m.total_transactions,
       t.is_merchant_online,
       m.total_spent,
       m.total_refund,
       m.avg_transaction_amount,
       m.total_fraud_transactions,
       m.fraud_rate,
       m.risk_level,
       m.first_transaction_date,
       m.last_transaction_date
    from cte_merchant as m 
    inner join cte_merchant2 as t on t.merchant_id = m.merchant_id


)

select
    *
from cte_join