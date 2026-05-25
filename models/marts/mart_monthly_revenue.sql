with orders as (
    select
        order_date,
        total_amount,
        is_completed_order,
        is_cancelled_order,
        is_refunded_order
    from {{ ref('int_orders_enriched') }}
),

monthly as (
    select
        {{ date_trunc_to_period('order_date', 'month') }} as order_month,
        count(*) as order_count,
        sum(total_amount) as gross_revenue,
        sum(case when is_completed_order then total_amount else 0 end) as completed_revenue,
        sum(case when is_cancelled_order or is_refunded_order then total_amount else 0 end) as cancelled_or_refunded_revenue,
        avg(total_amount) as average_order_value
    from orders
    group by {{ date_trunc_to_period('order_date', 'month') }}
)

select
    order_month,
    order_count,
    gross_revenue,
    completed_revenue,
    cancelled_or_refunded_revenue,
    average_order_value
from monthly
order by order_month
