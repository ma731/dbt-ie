with orders as (

    select
        order_id,
        customer_id,
        cast(order_date as timestamp) as order_date,
        status as order_status
    from {{ ref('stg_orders') }}

),

shipping as (

    select
        order_id,
        carrier,
        shipping_method,
        shipping_status,
        cast(ship_date as date) as ship_date,
        cast(estimated_delivery as date) as estimated_delivery,
        cast(actual_delivery as date) as actual_delivery
    from {{ ref('stg_shipping') }}

),

joined as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.order_status,
        shipping.carrier,
        shipping.shipping_method,
        shipping.shipping_status,
        shipping.ship_date,
        shipping.estimated_delivery,
        shipping.actual_delivery,
        date_diff('day', cast(orders.order_date as date), shipping.ship_date) as days_to_ship,
        date_diff('day', shipping.estimated_delivery, shipping.actual_delivery) as days_late,
        case
            when shipping.ship_date is null then false
            when shipping.actual_delivery is null then false
            when shipping.actual_delivery > shipping.estimated_delivery then true
            else false
        end as is_late,
        case
            when shipping.ship_date is null then 'not_shipped'
            when shipping.actual_delivery is null then 'unknown'
            when shipping.actual_delivery < shipping.estimated_delivery then 'early'
            when shipping.actual_delivery = shipping.estimated_delivery then 'on_time'
            when shipping.actual_delivery > shipping.estimated_delivery then 'late'
            else 'unknown'
        end as shipping_performance_bucket
    from orders
    left join shipping using (order_id)

)

select * from joined
