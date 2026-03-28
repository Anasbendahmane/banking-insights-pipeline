-- =============================================================
-- Model: dim_customers
-- Description: Complete customer profile with segmentation
--              and risk assessment based on financial metrics,
--              spending behavior and fraud history.
-- =============================================================


with cte_customer as(
    select
        *
    from {{ ref('int_customers_metrics') }}


),cte_user as (
    select
        user_id,
        full_name,
        age,
        gender,
        city,
        state,
        yearly_income,
        {{get_income_segment('yearly_income')}} as income_segment,
        total_debt,
        total_debt / yearly_income  as debt_income_ratio ,
        fico_score,
        {{get_fico_segment('fico_score')}} as fico_category
    from {{ ref('stg_user') }}


),cte_final as (

    select
        u.*,
        total_transactions,
        total_spent,
        total_refund,
        avg_transaction_amount,
        total_fraud_transactions,
        fraud_rate,
        first_transaction_date,
        last_transaction_date


    from cte_user as u 
    inner join cte_customer as c on c.user_id = u.user_id


)

select

    *
from cte_final