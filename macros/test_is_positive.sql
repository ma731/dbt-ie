-- =============================================================================
-- GENERIC TEST
-- =============================================================================
-- A generic test is a macro that lives in macros/ and whose name starts
-- with "test_". dbt passes it two mandatory arguments automatically:
--   model       → the model being tested (as a relation)
--   column_name → the column being tested (as a string)
--
-- Just like singular tests, it returns a SELECT: rows = failures.
--
-- Once defined, it can be applied to any column in any model's YAML file:
--
--   columns:
--     - name: total_amount
--       tests:
--         - is_positive           ← use the macro name without "test_"
--
-- Use generic tests for rules that apply to many columns or models.
-- This one checks that a numeric column never contains zero or negative values.
-- =============================================================================

{% test is_positive(model, column_name) %}

select
    {{ column_name }}
from {{ model }}
where {{ column_name }} <= 0

{% endtest %}
