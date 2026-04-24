with customers as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        country,
        customer_segment
    from {{ ref('stg_customers') }}

),

customer_segments as (

    select
        segment_id,
        customer_segment
    from {{ ref('segments') }}

),

merged as (

    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.country,
        c.customer_segment,
        cs.segment_id
    from customers c
    left join customer_segments cs
        using (customer_segment)

)

select * from merged

