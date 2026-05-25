-- Macro 3: for loop — iterate over a list to generate multiple SQL columns.
-- Python concept: for item in list. Jinja loops work exactly the same way.
-- Also introduces default arguments (like Macro 2): `suffix` defaults to empty string.
-- loop.last is a Jinja built-in that tells us if we're on the final iteration,
-- so we can avoid printing a trailing comma.
--
-- Usage: {{ generate_status_flags('status', ['completed', 'cancelled', 'refunded'], suffix='_order') }}
-- Generates:
--   case when status = 'completed' then true else false end as is_completed_order,
--   case when status = 'cancelled' then true else false end as is_cancelled_order,
--   case when status = 'refunded'  then true else false end as is_refunded_order
{% macro generate_status_flags(column, values, suffix='') %}
    {% for value in values %}
        case when {{ column }} = '{{ value }}' then true else false end as is_{{ value }}{{ suffix }}
        {%- if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}
