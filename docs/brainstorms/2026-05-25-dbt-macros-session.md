# dbt Macros Teaching Session

**Date:** 2026-05-25  
**Status:** Approved — ready for implementation

---

## Overview

Introduce dbt macros to beginner students by showing how Jinja templating brings Python-like programming concepts (functions, conditionals, loops) into SQL. Each macro refactors real code that already exists in the repo, so students see a direct before/after comparison.

**Core teaching narrative:** "Jinja is basically Python inside your SQL. Macros let you stop repeating yourself — and eventually generate SQL that would be impossible to write by hand."

---

## Goals

- Demonstrate 4 macro examples in increasing complexity order
- Highlight the specific Jinja/Python concept each macro introduces
- Refactor existing models where possible so students see the value immediately
- Create one new model to show dynamic SQL generation (macro 4)

---

## Non-goals

- Cross-database compatibility macros (only DuckDB is used)
- Generic tests as macros (separate topic)
- Macro packages / publishing macros externally
- Jinja filters or the `run_query` / `execute` pattern

---

## Macro Specifications

### Macro 1 — `datediff_days(start_col, end_col)`

**Python concept introduced:** Function definition and reuse  
**Jinja features:** Basic `{{ variable }}` interpolation, no control flow  
**Problem solved:** `datediff('day', cast(x as date), cast(y as date))` is verbose, DuckDB-specific, and appears twice in one model  
**Used in:** Refactor `models/intermediate/int_order_shipping_status.sql` (both `days_to_ship` and `days_late` columns)

```sql
-- Before
datediff('day', cast(orders.order_date as date), cast(shipping.ship_date as date))

-- After
{{ datediff_days('orders.order_date', 'shipping.ship_date') }}
```

---

### Macro 2 — `date_trunc_to_period(date_col, period='month')`

**Python concept introduced:** `if / elif / else` conditionals + default argument values  
**Jinja features:** `{% if %}` / `{% elif %}` / `{% else %}` / `{% endif %}`, default argument  
**Problem solved:** `mart_monthly_revenue.sql` hardcodes the monthly strftime pattern; other marts may need weekly or quarterly breakdowns  
**Used in:** Refactor `models/marts/mart_monthly_revenue.sql`; also available for future period-aware marts  
**Accepted `period` values:** `'day'`, `'week'`, `'month'` (default), `'quarter'`, `'year'`

**Key teaching point:** The macro makes decisions about *which SQL to emit* at compile time — different SQL comes out depending on the parameter. This is what separates macros from SQL functions.

---

### Macro 3 — `generate_status_flags(column, values)`

**Python concept introduced:** `for` loop over a list  
**Jinja features:** `{% for item in values %}`, `{% if not loop.last %}` (loop control)  
**Problem solved:** `int_orders_enriched.sql` has three identical `case when status = 'X' then true else false end as is_X_order` blocks that differ only in the value  
**Used in:** Refactor `models/intermediate/int_orders_enriched.sql` — replace the 3 manual flags with one macro call

```sql
-- Before (3 manual lines)
case when status = 'completed' then true else false end as is_completed_order,
case when status = 'cancelled' then true else false end as is_cancelled_order,
case when status = 'refunded'  then true else false end as is_refunded_order,

-- After (one macro call)
{{ generate_status_flags('status', ['completed', 'cancelled', 'refunded']) }}
```

**Key teaching point:** The loop generates SQL — the programmer no longer writes repetitive SQL, they describe *what* they want and the macro generates the SQL.

---

### Macro 4 — `pivot_count(column, values)`

**Python concept introduced:** Combining loops with logic (loop index control)  
**Jinja features:** `{% for %}`, `{{ loop.index }}`, comma handling with `{% if not loop.last %}`  
**Problem solved:** Pivoting a categorical column into multiple count columns requires repetitive SQL that grows linearly with cardinality — macros make this dynamic  
**Used in:** New model `models/marts/mart_payment_method_breakdown.sql`

```sql
-- Generates for values=['credit_card', 'paypal', 'bank_transfer']:
sum(case when payment_method = 'credit_card' then 1 else 0 end) as credit_card_count,
sum(case when payment_method = 'paypal' then 1 else 0 end) as paypal_count,
sum(case when payment_method = 'bank_transfer' then 1 else 0 end) as bank_transfer_count
```

**Key teaching point:** This SQL would need to change every time a new payment method is added. With a macro, you only update the values list.

---

## File Changes

| File | Action |
|------|--------|
| `macros/datediff_days.sql` | Create |
| `macros/date_trunc_to_period.sql` | Create |
| `macros/generate_status_flags.sql` | Create |
| `macros/pivot_count.sql` | Create |
| `models/intermediate/int_order_shipping_status.sql` | Refactor (use macro 1) |
| `models/marts/mart_monthly_revenue.sql` | Refactor (use macro 2) |
| `models/intermediate/int_orders_enriched.sql` | Refactor (use macro 3) |
| `models/marts/mart_payment_method_breakdown.sql` | Create (uses macro 4) |

---

## Success Criteria

- `dbt compile` produces identical (or logically equivalent) SQL for all refactored models
- `dbt run` completes without errors for all affected models and the new model
- Each macro has a clear, commented explanation of the Jinja concept it demonstrates
- Students can trace the before/after diff for each refactored model
