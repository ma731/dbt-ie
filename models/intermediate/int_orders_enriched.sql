with orders_with_items as (

    select * from {{ ref('int_orders_with_items') }}

),

shipping_info as (

    select
        order_id,
        ship_date,
        estimated_delivery,
        actual_delivery,
        shipping_status,
        days_to_ship,
        days_late,
        is_late,
        shipping_performance_bucket
    from {{ ref('int_order_shipping_status') }}

),

payments_info as (

    select
        order_id,
        payment_count,
        successful_payment_count,
        total_paid_amount,
        primary_payment_method,
        has_successful_payment,
        payment_status_summary
    from {{ ref('int_payments_by_order') }}

),

enriched as (

    select
        orders_with_items.order_id,
        orders_with_items.customer_id,
        orders_with_items.order_date,
        orders_with_items.status,
        orders_with_items.subtotal,
        orders_with_items.tax_amount,
        orders_with_items.shipping_cost,
        orders_with_items.discount_amount,
        orders_with_items.total_amount,
        orders_with_items.currency,
        orders_with_items.payment_method,
        orders_with_items.order_item_count,
        orders_with_items.total_quantity,
        orders_with_items.gross_item_revenue,
        orders_with_items.total_item_discount_amount,
        orders_with_items.net_item_revenue,
        orders_with_items.has_order_items,
        shipping_info.ship_date,
        shipping_info.estimated_delivery,
        shipping_info.actual_delivery,
        shipping_info.shipping_status,
        shipping_info.days_to_ship,
        shipping_info.days_late,
        shipping_info.is_late,
        shipping_info.shipping_performance_bucket,
        payments_info.payment_count,
        payments_info.successful_payment_count,
        payments_info.total_paid_amount,
        payments_info.primary_payment_method,
        payments_info.has_successful_payment,
        payments_info.payment_status_summary,
        orders_with_items.status = 'completed' as is_completed_order,
        orders_with_items.status = 'cancelled' as is_cancelled_order,
        orders_with_items.status = 'refunded' as is_refunded_order,
        coalesce(payments_info.has_successful_payment, false) as is_paid
    from orders_with_items
    left join shipping_info using (order_id)
    left join payments_info using (order_id)

)

select * from enriched
