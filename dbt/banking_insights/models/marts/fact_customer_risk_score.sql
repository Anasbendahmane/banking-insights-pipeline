-- =============================================================
-- Model: fact_customer_risk_score
-- Description: Customer risk scoring based on financial health
--              and fraud history. Combines FICO score, debt
--              to income ratio and fraud rate to rank customers
--              by overall risk level using window functions.
-- =============================================================

with cte_risk as(

    select

        user_id,
        full_name,
        yearly_income,
        income_segment,
        total_debt,
        debt_income_ratio,
        fico_score,
        fico_category,
        total_fraud_transactions,
        fraud_rate,
        NTILE(4) over(order by fraud_rate desc) as risk_segment,
        rank() over(order by fico_score asc ) as fico_risk,
        rank() over(order by debt_income_ratio desc) as debt_risk
    from {{ ref('dim_customers') }}



)

select
    *

from cte_risk