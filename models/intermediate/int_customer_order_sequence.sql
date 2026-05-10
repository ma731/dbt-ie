with orders as (

    select
        order_id,
        customer_id,
        order_date,
        status,
        total_amount,
        is_completed_order,
        is_paid
    from {{ ref('int_orders_enriched') }}

),

sequenced as (

    select
        order_id,
        customer_id,
        order_date,
        status,
        total_amount,
        is_completed_order,
        is_paid,
        row_number() over (
            partition by customer_id
            order by order_date, order_id
        ) as customer_order_number,
        row_number() over (
            partition by customer_id
            order by order_date, order_id
        ) = 1 as is_first_order,
        lag(order_date) over (
            partition by customer_id
            order by order_date, order_id
        ) as previous_order_date,
        date_diff(
            'day',
            cast(lag(order_date) over (
                partition by customer_id
                order by order_date, order_id
            ) as date),
            cast(order_date as date)
        ) as days_since_previous_order
    from orders

)

select * from sequenced
