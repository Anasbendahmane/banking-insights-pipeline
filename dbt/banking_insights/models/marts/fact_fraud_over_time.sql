-- =============================================================
-- Model: fact_fraud_over_time
-- Description: Monthly fraud trends analysis with cumulative
--              fraud counts per year and month-over-month
--              variation. Helps identify seasonal patterns
--              and detect fraud spikes over time.
-- =============================================================


with cte_time as(
    SELECT
        d.year,
        d.month,
        d.month_short_name,
        d.saison,
        f.*

    from {{ ref('fact_transactions') }} as f
    left join {{ ref('dim_date') }} as d on d.date_day = f.transaction_date
),cte_calcul as (


    select

        year,
        month,
        month_short_name,
        saison,
        count(case when is_fraud ='true' then 1 else null end) as fraud_count,
        count(*) as total_transactions

    from cte_time
    group by year,month,month_short_name,saison
    order by year,month

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