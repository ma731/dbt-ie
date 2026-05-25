-- Macro 1: Basic function — wraps DuckDB's verbose date diff expression.
-- Python concept: defining a reusable function.
-- Instead of writing datediff('day', cast(x as date), cast(y as date)) every time,
-- we define it once and call it by name.
{% macro datediff_days(start_col, end_col) %}
    datediff('day', cast({{ start_col }} as date), cast({{ end_col }} as date))
{% endmacro %}
