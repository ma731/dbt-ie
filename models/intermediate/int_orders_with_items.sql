with orders as (

    select
        order_id,
        customer_id,
        cast(order_date as timestamp) as order_date,
        status,
        subtotal,
        tax_amount,
        shipping_cost,
        discount_amount,
        total_amount,
        currency,
        payment_method
    from {{ ref('stg_orders') }}

),

items_summary as (

    select
        order_id,
        order_item_count,
        total_quantity,
        gross_item_revenue,
        total_item_discount_amount,
        net_item_revenue
    from {{ ref('int_order_items_summary') }}

),

joined as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,
        orders.subtotal,
        orders.tax_amount,
        orders.shipping_cost,
        orders.discount_amount,
        orders.total_amount,
        orders.currency,
        orders.payment_method,
        coalesce(items_summary.order_item_count, 0) as order_item_count,
        coalesce(items_summary.total_quantity, 0) as total_quantity,
        coalesce(items_summary.gross_item_revenue, 0) as gross_item_revenue,
        coalesce(items_summary.total_item_discount_amount, 0) as total_item_discount_amount,
        coalesce(items_summary.net_item_revenue, 0) as net_item_revenue,
        items_summary.order_id is not null as has_order_items
    from orders
    left join items_summary using (order_id)

)

select * from joined
