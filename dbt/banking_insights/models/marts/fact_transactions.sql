{{
  config(
    materialized = 'incremental',
    unique_key='transaction_id',
    incremental_strategy='merge'
    )
}}

with ref as (
    SELECT
        *
    from {{ ref('int_transaction_enriched') }}
    {% if is_incremental() %}

        where transaction_timestamp > (select max(transaction_timestamp) from {{this}})

    {% endif %}

),cte_transact as(
    select
        card_id,
        user_id,
        transaction_date,
        transaction_timestamp,
        amount,
        CASE
            when amount > 500 THEN 'High value'
            ELSE 'Normal Value'
        END as is_high_value,
        transaction_category,
        transaction_type,
        merchant_id,
        merchant_city,
        merchant_state,
        mcc,
        errors,
        is_fraud


    from ref


), cte_final as(
    select

        {{dbt_utils.generate_surrogate_key(['card_id','transaction_timestamp','merchant_id'])}} as transaction_id,
        *
    from cte_transact



)

SELECT
    *

FROM cte_final


