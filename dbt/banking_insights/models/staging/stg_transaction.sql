with cte_source as(
    select
        *
    from {{ source('RAW', 'TRANSACTIONS_RAW') }}
), cte_transactions as(
    
    select
        user + 1 as user_id,
        card +1 as card_index,
        to_date(day||'/'||month||'/'||year,'DD/MM/YYYY') as transaction_date,
        time,
        cast(replace(amount,'$','') as float) as amount,
        TRIM(use_chip) as transaction_type,
        merchant_name as merchant_id,
        merchant_city,
        CASE 
            WHEN merchant_state is null then 'N/A'
            ELSE merchant_state
        END as merchant_state,
        ZIP,
        MCC,
        CASE 
            WHEN TRIM(replace(errors,'"','')) IS NULL THEN 'No Error'
            ELSE TRIM(replace(errors,'"','')) 
        END as errors,
        cast(is_fraud as boolean) as is_fraud,
        loaded_at

    from cte_source

),final_cte as(
    select
        {{ dbt_utils.generate_surrogate_key(['user_id', 'card_index']) }} as card_id,
        user_id,
        card_index,
        transaction_date,
        to_timestamp(transaction_date||' '||cast(time as time), 'YYYY-MM-DD HH24:MI:SS') as transaction_timestamp,
        amount,
        transaction_type,
        merchant_id,
        merchant_city,
        merchant_state,
        ZIP,
        MCC,
        errors,
        is_fraud,
        loaded_at

    from cte_transactions
)


select 
        *
from final_cte