-- =============================================================================
-- SINGULAR TEST
-- =============================================================================
-- A singular test is a plain SQL file inside the tests/ folder.
-- dbt runs it and checks the number of rows returned:
--   0 rows  → TEST PASSES  (no violations found)
--   1+ rows → TEST FAILS   (violations returned for inspection)
--
-- Use singular tests for one-off business rules that are too specific
-- to turn into a reusable generic test.
--
-- Business rule: every completed order must have a successful payment.
-- This is a cross-model check — something column-level tests can't catch.
-- =============================================================================

select
    o.order_id,
    o.status,
    o.is_completed_order,
    o.is_paid
from {{ ref('mart_orders') }} as o
where
    o.is_completed_order = true
    and o.is_paid = false
