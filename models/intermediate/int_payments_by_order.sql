with payments as (

    select
        order_id,
        cast(payment_date as timestamp) as payment_date,
        payment_method,
        amount,
        status
    from {{ ref('stg_payments') }}

),

summary as (

    select
        order_id,
        count(*) as payment_count,
        count(*) filter (where status = 'completed') as successful_payment_count,
        sum(amount) filter (where status = 'completed') as total_paid_amount,
        arg_max(payment_method, payment_date) as primary_payment_method,
        bool_or(status = 'completed') as has_successful_payment,
        case
            when count(*) filter (where status = 'completed') = 0 then 'unpaid'
            when count(*) filter (where status not in ('completed')) > 0 then 'partially_paid'
            when count(*) filter (where status = 'completed') > 0 then 'paid'
            else 'unknown'
        end as payment_status_summary
    from payments
    group by order_id

)

select * from summary
