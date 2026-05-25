-- This model uses the pivot_count macro to generate one column per payment method.
-- Without macros, you would need to write 5 separate CASE WHEN expressions by hand.
-- With the macro, adding a new payment method only requires updating the values list.
with payments as (
    select
        customer_id,
        payment_method,
        amount,
        status
    from {{ ref('stg_payments') }}
    where status = 'completed'
),

summary as (
    select
        customer_id,
        count(payment_method) as total_payments,
        sum(amount) as total_paid,
        {{ pivot_count('payment_method', ['credit_card', 'paypal', 'bank_transfer', 'apple_pay', 'google_pay']) }}
    from payments
    group by customer_id
)

select
    customer_id,
    total_payments,
    total_paid,
    credit_card_count,
    paypal_count,
    bank_transfer_count,
    apple_pay_count,
    google_pay_count
from summary
