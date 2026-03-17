
with cte_users as (
    select
        row_number() over(order by (select NULL)) as user_id,
        Lower(TRIM(PERSON)) as full_name,
        CURRENT_AGE as age,
        retirement_age ,
        birth_year,
        birth_month,
        CASE 
            WHEN GENDER ='Female' THEN 'F'
            WHEN GENDER ='Male' THEN 'M'
            ELSE 'unkown'  
        END as gender,
        Address,
        CASE
            WHEN Trim(appartment)='-' then NULL
            ELSE trim(appartment)
        END appartment,
        city,
        state,
        zipcode,
        latitude,
        longitude,
        cast(replace(PER_CAPITA_INCOME_ZIPCODE,'$','') as int) as PER_CAPITA_INCOME_ZIPCODE,
        cast(replace(yearly_income,'$','') as int) as yearly_income,
        cast(replace(total_debt,'$','') as int) as total_debt,
        fico_score,
        num_credit_cards,
        loaded_at
    from {{ source('RAW', 'USERS_RAW') }}


)

select 
    *
from cte_users

