-- =============================================================
-- Model: fact_fraud_over_time
-- Description: Monthly fraud trends analysis with cumulative
--              fraud counts per year and month-over-month
--              variation. Helps identify seasonal patterns
--              and detect fraud spikes over time.
-- =============================================================


with cte_time as(
    select
        *
    from {{ ref('fact_transactions') }}
),cte_calcul as (


    select
        date_part(year,transaction_date) as year,
        date_part(month,transaction_date) as month,
        count(case when is_fraud ='true' then 1 else null end) as fraud_count,
        count(*) as total_transactions

    from cte_time
    group by date_part(year,transaction_date) ,date_part(month,transaction_date)
    order by date_part(year,transaction_date) ,date_part(month,transaction_date)

),cte_calcul1 as (

    select 
        *,
        lag(fraud_count) over( order by year,month  ) as fraud_count_lag,
        sum(fraud_count) over ( partition by year order by year,month  rows between unbounded preceding and current row  ) as cumul_fraud_per_year


    from cte_calcul


)

SELECT
    *,
    (fraud_count - fraud_count_lag) as variation_fraud_monthly,
    (fraud_count / total_transactions) * 100 as fraud_rate

from cte_calcul1