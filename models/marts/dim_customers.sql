with customers as (
    select
        customer_id,
        full_name,
        email,
        email_domain,
        country,
        customer_segment,
        segment_id
    from {{ ref('int_customers_enriched') }}
),

order_metrics as (
    select
        customer_id,
        count(order_id) as total_orders,
        sum(case when is_completed_order then total_amount else 0 end) as total_spent,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date,
        avg(case when is_completed_order then total_amount end) as average_order_value
    from {{ ref('int_orders_enriched') }}
    group by customer_id
),

final as (
    select
        customers.customer_id,
        customers.full_name,
        customers.email,
        customers.email_domain,
        customers.country,
        customers.customer_segment,
        customers.segment_id,
        coalesce(order_metrics.total_orders, 0) as total_orders,
        coalesce(order_metrics.total_spent, 0) as total_spent,
        order_metrics.first_order_date,
        order_metrics.last_order_date,
        coalesce(order_metrics.average_order_value, 0) as average_order_value,
        case when coalesce(order_metrics.total_orders, 0) > 1 then true else false end as is_repeat_customer
    from customers
    left join order_metrics using (customer_id)
)

select
    customer_id,
    full_name,
    email,
    email_domain,
    country,
    customer_segment,
    segment_id,
    total_orders,
    total_spent,
    first_order_date,
    last_order_date,
    average_order_value,
    is_repeat_customer
from final
