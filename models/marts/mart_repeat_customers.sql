with sequences as (
    select
        customer_id,
        order_date,
        days_since_previous_order
    from {{ ref('int_customer_order_sequence') }}
),

aggregated as (
    select
        customer_id,
        count(order_date) as total_orders,
        round(avg(days_since_previous_order), 1) as avg_days_between_orders,
        min(days_since_previous_order) as min_days_between_orders,
        max(days_since_previous_order) as max_days_between_orders,
        max(order_date) as last_order_date
    from sequences
    group by customer_id
    having count(order_date) > 1
)

select
    customer_id,
    total_orders,
    avg_days_between_orders,
    min_days_between_orders,
    max_days_between_orders,
    last_order_date
from aggregated
