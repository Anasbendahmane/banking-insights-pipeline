--=========================================================
-- Description: Merchant risk assessment identifying where
--              fraudulent transactions occur most frequently.
--              Helps detect high-risk merchants and suspicious
--              transaction patterns by location and category.
--===========================================================


with cte_merchant as (
    SELECT
        merchant_id,
        mcc,
        merchant_details,
        total_transactions,
        total_fraud_transactions,
        fraud_rate,
        risk_level,
        is_merchant_online


    from {{ ref('dim_merchant') }}

),cte_fraud as(

    SELECT
        *,
        RANK() over(order by fraud_rate desc) as fraud_rate_rnk ,
        RANK() over (order by total_fraud_transactions desc) as fraud_volume_rank
    from cte_merchant



)


select
    * 
from cte_fraud
