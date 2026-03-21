{{
  config(
    materialized = 'table'
    )
}}

with cte_usr as(
    select
        user_id,
        full_name,
        age,
        gender,
        PER_CAPITA_INCOME_ZIPCODE,
        yearly_income,
        total_debt,
        fico_score,
        num_credit_cards
    from {{ ref('stg_user') }}

), cte_crd as(

    select

        card_id,
        card_brand,
        card_type,
        has_chip,
        cards_issued,
        credit_limit,
        acct_open_date,
        card_on_dark_web

    from {{ ref('stg_card') }}

), cte_tran as(

    select
        card_id,
        user_id,
        transaction_date,
        transaction_timestamp,
        amount,
        transaction_category,
        transaction_type,
        merchant_id,
        merchant_city,
        merchant_state,
        mcc,
        errors,
        is_fraud

    from {{ ref('stg_transaction') }}

)


select  

    t.*,
    u.full_name,
    u.age,
    u.gender,
    u.PER_CAPITA_INCOME_ZIPCODE,
    u.yearly_income,
    u.total_debt,
    u.fico_score,
    u.num_credit_cards,
    c.card_brand,
    c.card_type,
    c.has_chip,
    c.cards_issued,
    c.credit_limit,
    c.acct_open_date,
    c.card_on_dark_web

from cte_tran as t 
inner join cte_crd as c on c.card_id = t.card_id
inner join cte_usr as u on t.user_id = u.user_id
