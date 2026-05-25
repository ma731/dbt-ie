-- Macro 2: if / elif / else — like Python conditionals, but at compile time.
-- The macro decides WHICH SQL to emit based on the `period` argument.
-- Default argument: if no period is passed, it defaults to 'month'.
-- Accepted values: 'day', 'week', 'month' (default), 'quarter', 'year'
{% macro date_trunc_to_period(date_col, period='month') %}
    {% if period == 'day' %}
        cast({{ date_col }} as date)
    {% elif period == 'week' %}
        strftime(cast({{ date_col }} as date), '%Y-W%W')
    {% elif period == 'month' %}
        strftime(cast({{ date_col }} as date), '%Y-%m')
    {% elif period == 'quarter' %}
        'Q' || quarter(cast({{ date_col }} as date)) || '-' || year(cast({{ date_col }} as date))
    {% elif period == 'year' %}
        cast(year(cast({{ date_col }} as date)) as varchar)
    {% else %}
        {{ exceptions.raise_compiler_error("date_trunc_to_period: invalid period '" ~ period ~ "'. Use: day, week, month, quarter, year") }}
    {% endif %}
{% endmacro %}
