with shipping as (
    select
        carrier,
        shipping_method,
        is_late,
        days_to_ship,
        days_late
    from {{ ref('int_order_shipping_status') }}
    where carrier is not null
),

aggregated as (
    select
        carrier,
        shipping_method,
        count(*) as total_shipments,
        sum(case when not is_late then 1 else 0 end) as on_time_count,
        sum(case when is_late then 1 else 0 end) as late_count,
        round(
            100.0 * sum(case when not is_late then 1 else 0 end) / nullif(count(*), 0),
            2
        ) as on_time_rate,
        round(avg(days_to_ship), 2) as avg_days_to_ship,
        round(avg(case when is_late then days_late end), 2) as avg_days_late
    from shipping
    group by carrier, shipping_method
)

select
    carrier,
    shipping_method,
    total_shipments,
    on_time_count,
    late_count,
    on_time_rate,
    avg_days_to_ship,
    avg_days_late
from aggregated
