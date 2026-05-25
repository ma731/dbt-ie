-- Macro 4: combining loops with logic — dynamic SQL generation.
-- Python concept: for loop + string manipulation to generate N columns from a list.
-- This is the "only possible with macros" moment: the number of columns is data-driven.
-- Adding a new value to the list adds a new column automatically — no SQL changes needed.
--
-- Usage: {{ pivot_count('payment_method', ['credit_card', 'paypal', 'bank_transfer']) }}
-- Generates:
--   sum(case when payment_method = 'credit_card' then 1 else 0 end) as credit_card_count,
--   sum(case when payment_method = 'paypal' then 1 else 0 end) as paypal_count,
--   sum(case when payment_method = 'bank_transfer' then 1 else 0 end) as bank_transfer_count
{% macro pivot_count(column, values) %}
    {% for value in values %}
        sum(case when {{ column }} = '{{ value }}' then 1 else 0 end) as {{ value | replace(' ', '_') }}_count
        {%- if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}
