

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="'1990-01-01'",
        end_date="'2021-01-01'"
    ) }}


),cte_date as (
    select
        cast(date_day as date) as date_day

    from date_spine


),cte_detail as(
    select
        date_day,
        date_part(year,date_day ) as year,
        date_part(month, date_day)as month,
        {{ dbt_date.month_name('date_day') }} as month_short_name,
        {{saison("date_part(month,date_day )")}} as saison,
        date_part(week,date_day) as week,
        dayname(date_day) as day_name,
        {{get_day("dayname(date_day)")}} as day_



    from cte_date

)

select
    *
from cte_detail