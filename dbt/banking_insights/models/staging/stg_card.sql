with source as (
    select
        *
    from {{ source('RAW', 'CARDS_RAW') }}

), cte_card as(

    select  
        
        user + 1 as user_id,-- user_id starts at 1 to match ROW_NUMBER() in stg_users
        card_index + 1 as card_index,
        trim(card_brand) as card_brand,
        trim(card_type) as card_type,
        card_number,
        date_trunc(month,to_date('01/' || Expires, 'DD/MM/YYYY'))as expires, -- Normalize expires to first day of month for date comparisons
        cvv,
        cast(Has_chip as boolean) as has_chip , -- Convert YES/NO to boolean for easier filtering
        cards_issued,
        cast(replace(Credit_Limit,'$','') as int) as credit_limit,
        date_trunc(month,to_date('01/' || Acct_open_date,'DD/MM/YYYY')) as acct_open_date,
        year_pin_last_changed,
        cast(Card_On_Dark_Web as boolean) as card_on_dark_web,
        loaded_at
        
    from source
),final_cte as(
    select
        {{ dbt_utils.generate_surrogate_key(['user_id', 'card_index']) }} as card_id, ---- Surrogate key generated from user_id + card_index to enable joins with stg_transactions

        *
    from cte_card
)

SELECT distinct
    card_type
FROM final_cte
--where Card_brand is null or Card_type is null