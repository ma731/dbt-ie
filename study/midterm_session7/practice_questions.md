# Midterm Practice Questions — 50 Multiple Choice

**Format:** Same as the exam — pick the single best answer. Work through all 50 first, then check the answer key at the bottom. Re-attempt any you missed.

Difficulty progression: **Session 1 (Q1-6) → Session 7 (Q44-50)**. The harder distractors are usually plausible-but-wrong — the kind Dani writes to catch students who half-read.

---

## Session 1 — Analytics Engineering & dbt Basics

**Q1.** In the modern data stack, dbt is responsible for which letter of ELT?
- A) Extract
- B) Load
- C) Transform
- D) All three

**Q2.** Which of the following is **not** a stage of the Analytics Development Lifecycle (ADLC)?
- A) Build
- B) Collaborate
- C) Deploy
- D) Visualize

**Q3.** Which role typically sits between the Data Engineer and the Data Analyst, focused on modeling/testing/docs?
- A) Data Scientist
- B) ML Engineer
- C) Analytics Engineer
- D) Backend Developer

**Q4.** What is the key technical reason ELT scales better than ETL?
- A) ELT uses Python instead of SQL
- B) ELT leverages the warehouse's compute for transformation
- C) ELT requires less storage
- D) ELT is faster to write

**Q5.** Which two roles does dbt simultaneously serve, internally?
- A) Extractor and loader
- B) Compiler and runner
- C) Orchestrator and scheduler
- D) BI tool and database

**Q6.** Of the following, which is **not** part of dbt's "control plane" purpose?
- A) Testing
- B) Documentation
- C) Lineage
- D) Data ingestion

---

## Session 2 — Setup, Project Structure, ref()

**Q7.** DuckDB is best described as:
- A) A cloud data warehouse like Snowflake
- B) A streaming platform like Kafka
- C) A serverless, in-process OLAP database (SQLite for analytics)
- D) A Python library for visualizing data

**Q8.** Where does dbt look for `profiles.yml` *first*?
- A) The user's home directory (`~/.dbt/profiles.yml`)
- B) The `--profiles-dir` CLI flag, if provided
- C) The project directory (next to `dbt_project.yml`)
- D) The `DBT_PROFILES_DIR` environment variable

**Q9.** Which file is the entrypoint that defines a dbt project's name, paths, and default materializations?
- A) `profiles.yml`
- B) `dbt_project.yml`
- C) `packages.yml`
- D) `manifest.json`

**Q10.** Which folder should be in `.gitignore`?
- A) `models/`
- B) `seeds/`
- C) `target/`
- D) `macros/`

**Q11.** What does the `ref()` macro NOT do?
- A) Resolve to the model's database/schema/table at compile time
- B) Build the project's DAG
- C) Connect to the data warehouse via the profile
- D) Help dbt determine model execution order

**Q12.** After `dbt run`, where would you find the **rendered SQL** (Jinja resolved) **without** the materialization DDL wrapping it?
- A) `target/run/`
- B) `target/compiled/`
- C) `logs/dbt.log`
- D) `target/manifest.json`

**Q13.** Which command verifies that dbt can connect to your warehouse using `profiles.yml`?
- A) `dbt build`
- B) `dbt compile`
- C) `dbt debug`
- D) `dbt deps`

**Q14.** Which naming convention is correct?
- A) `staging_customers`
- B) `customers_stg`
- C) `stg_customers`
- D) `stage.customers`

---

## Session 2b — Foundations: DuckDB / dbt fit

**Q15.** Which statement is true?
- A) dbt extracts data from APIs and loads it into the warehouse
- B) dbt is a warehouse-agnostic SQL compiler and runner; you supply the warehouse
- C) dbt comes with built-in scheduling
- D) dbt replaces the warehouse and BI tools

**Q16.** Which file is **disposable** — safe to delete and regenerate?
- A) `dbt_project.yml`
- B) `target/`
- C) `models/staging/stg_customers.sql`
- D) `packages.yml`

**Q17.** In `dbt run`'s flow, when does Jinja get rendered into pure SQL?
- A) Before the DAG is built
- B) After the DAG is built, before execution against the warehouse
- C) During each model's execution, on the fly
- D) Never — dbt sends Jinja directly to the warehouse

**Q18.** What's the right description of OLAP (data warehouse) workload characteristics?
- A) Many small reads/writes, single-row queries
- B) Big scans and aggregations over millions of rows
- C) Real-time transaction logging
- D) Storing user session state for an app

---

## Session 3 — Sources, Seeds, Tests, dbt build

**Q19.** How do you reference a raw `customers` table that's defined in `sources.yml` with source name `raw`?
- A) `from main.customers`
- B) `from {{ ref('customers') }}`
- C) `from {{ source('raw', 'customers') }}`
- D) `from {{ source('main.customers') }}`

**Q20.** Which is **NOT** an appropriate transformation in a staging model?
- A) Renaming columns to snake_case
- B) Casting `order_date::date`
- C) Joining `customers` to `orders`
- D) `coalesce(country, 'unknown')`

**Q21.** Which `dbt` command loads CSVs from `seeds/` as warehouse tables?
- A) `dbt run`
- B) `dbt build`
- C) `dbt seed`
- D) `dbt source freshness`

**Q22.** Which is a valid way to reference a loaded seed `segments.csv` in a model?
- A) `from {{ source('seeds', 'segments') }}`
- B) `from {{ ref('segments') }}`
- C) `from seeds.segments`
- D) `from main.segments_csv`

**Q23.** A `unique` test passes when:
- A) The column has at least one unique value
- B) Every value in the column is non-null
- C) No value in the column is repeated
- D) The column is a primary key

**Q24.** Which generic test enforces foreign-key integrity to another model?
- A) `accepted_values`
- B) `relationships`
- C) `not_null`
- D) `unique`

**Q25.** What does `dbt build` do that `dbt run` does NOT?
- A) Generate documentation
- B) Compile Jinja
- C) Also run tests, seeds, and snapshots in DAG order
- D) Connect to the warehouse

**Q26.** If a `not_null` test fails on `stg_orders.order_id`, what happens to models downstream of `stg_orders` in the same `dbt build`?
- A) They run normally — tests are advisory
- B) They are **skipped** to prevent bad data from propagating
- C) They run but mark their tests as failed too
- D) Only models with `+grants` are skipped

---

## Session 4 — Layers, DAG, Selectors, SQL Patterns

**Q27.** Which layer should contain joins of multiple staging models?
- A) Source
- B) Staging
- C) Intermediate
- D) Marts (always)

**Q28.** A DAG is **acyclic**, meaning:
- A) Models cannot reference each other
- B) A model cannot depend on itself, directly or transitively
- C) Models are unsorted
- D) Tests cannot reference models

**Q29.** What does `dbt build -s +int_orders_enriched` build?
- A) `int_orders_enriched` only
- B) `int_orders_enriched` and everything **downstream** of it
- C) `int_orders_enriched` and everything **upstream** of it
- D) The entire project, then `int_orders_enriched` again

**Q30.** Which selector builds everything inside the `models/marts/` folder?
- A) `dbt build -s marts`
- B) `dbt build -s tag:marts`
- C) `dbt build -s mart_*`
- D) `dbt build -s @marts`

**Q31.** You change `stg_orders` and want to know what could break. Best selector?
- A) `dbt build -s stg_orders`
- B) `dbt build -s +stg_orders`
- C) `dbt build -s stg_orders+`
- D) `dbt build -s @stg_orders+`

**Q32.** A model called `int_customer_orders_ranked` uses `row_number() over (partition by customer_id order by order_date)`. Which SQL pattern is this?
- A) Aggregation
- B) Window function
- C) Cleaning & casting
- D) Classification

**Q33.** Two marts both need orders joined to customers. According to DRY, where should this join live?
- A) Duplicated in each mart (faster execution)
- B) In an intermediate model both marts `ref()`
- C) In a database view created outside dbt
- D) Inline in each mart's CTE

---

## Session 5 — Practice: Foundation models

**Q34.** Joining `stg_orders` (1 row per order) directly to `stg_order_items` (N rows per order) without aggregation will:
- A) Return one row per order
- B) Cause "fan-out" — order header columns are duplicated N times
- C) Fail with a SQL syntax error
- D) Automatically deduplicate

**Q35.** Why build `int_order_items_summary` before joining to `stg_orders`?
- A) Saves storage
- B) Reduces the item table to one row per order, preserving order grain
- C) Required by dbt's compiler
- D) Avoids the need for `ref()`

**Q36.** `mart_orders` is described as a "wide table" because:
- A) It has more rows than other marts
- B) It centralizes order facts so analysts don't have to join multiple tables in BI
- C) Its columns have wide data types (TEXT, BLOB)
- D) It includes data from multiple schemas

**Q37.** A Python model in dbt is appropriate when:
- A) The transformation is a simple `select`
- B) You need to read from a CSV
- C) Complex string parsing, ML, or API calls would be awkward in SQL
- D) Your warehouse does not support SQL

---

## Session 6 — Materializations & Grants

**Q38.** Which materialization creates a CTE that's inlined into downstream models, never persisted?
- A) `view`
- B) `table`
- C) `ephemeral`
- D) `incremental`

**Q39.** Default materializations by layer (per course best practice):
- A) staging=table, intermediate=view, marts=table
- B) staging=view, intermediate=ephemeral or view, marts=table
- C) staging=ephemeral, intermediate=table, marts=view
- D) staging=incremental, intermediate=view, marts=table

**Q40.** If `dbt_project.yml` says `staging: +materialized: view`, but a specific staging model has `{{ config(materialized='table') }}` at the top, what materialization is used for that model?
- A) `view` — project-level wins
- B) `table` — model-level overrides project-level
- C) `ephemeral` — they cancel each other out
- D) The model errors at compile time

**Q41.** Which materialization is generally **fastest to build** but **slowest to query**?
- A) `table`
- B) `view`
- C) `incremental`
- D) `ephemeral`

**Q42.** Where does dbt apply `+grants`?
- A) In `profiles.yml`
- B) In `dbt_project.yml`, under `models:`
- C) In `packages.yml`
- D) In the `tests/` directory

---

## Session 7 — Jinja, Macros & Packages

**Q43.** Which file declares external dbt packages to install with `dbt deps`?
- A) `dbt_project.yml`
- B) `requirements.txt`
- C) `packages.yml`
- D) `profiles.yml`

**Q44.** Which is **NOT** valid Jinja syntax inside a dbt model?
- A) `{{ my_var }}`
- B) `{% for col in cols %}{{ col }}{% endfor %}`
- C) `{# this is a comment #}`
- D) `<? echo my_var ?>`

**Q45.** Where should a custom macro file live?
- A) `models/`
- B) `macros/`
- C) `analyses/`
- D) `tests/`

**Q46.** What does `dbt_utils.generate_surrogate_key(['order_id', 'product_id'])` return?
- A) A SQL string that hashes the listed columns into a stable composite key
- B) A list of column names
- C) An auto-incrementing integer
- D) A foreign key constraint

**Q47.** In a Jinja `for` loop, which expression is true on the final iteration?
- A) `loop.first`
- B) `loop.last`
- C) `loop.end`
- D) `loop.finished`

**Q48.** A model has `{% if target.name == 'dev' %} where order_date > '2024-01-01' {% endif %}`. What does this achieve?
- A) Always filters data
- B) Filters data only in dev runs, not in prod
- C) Errors out unless `target` is explicitly set
- D) Forces dbt to skip this model in dev

**Q49.** What's the right git workflow phrase for one logical change per commit?
- A) Branchy commits
- B) Atomic commits
- C) Aggregated commits
- D) Lazy commits

**Q50.** Which of the following is a package commonly used in this course?
- A) `dbt_utils`
- B) `dbt_expectations`
- C) `codegen`
- D) **All of the above**

---

# Answer Key (with explanations)

| Q | Ans | Why |
|---|---|---|
| 1 | C | dbt is the "T" in ELT — transforms data already in the warehouse |
| 2 | D | ADLC = Build / Collaborate / Deploy / Monitor. "Visualize" is BI, not ADLC |
| 3 | C | The Analytics Engineer bridges Engineering and Analysis |
| 4 | B | ELT pushes transformation INTO the warehouse, using its compute (often elastic) |
| 5 | B | dbt is both a compiler (Jinja → SQL) and runner (executes against warehouse) |
| 6 | D | dbt does NOT do ingestion. Control plane = testing/docs/lineage/orchestration |
| 7 | C | DuckDB = in-process, serverless OLAP, "SQLite for analytics" |
| 8 | B | Resolution order: CLI flag → env var → project dir → ~/.dbt/. CLI flag wins |
| 9 | B | `dbt_project.yml` is the project's manifest |
| 10 | C | `target/` is disposable build artifacts — always gitignored |
| 11 | C | ref() resolves names and builds DAG. It does NOT manage the warehouse connection — that's `profiles.yml`'s job |
| 12 | B | `target/compiled/` = Jinja-rendered SQL, no DDL. `target/run/` = with DDL wrapping |
| 13 | C | `dbt debug` exercises the connection and prints config |
| 14 | C | `stg_*` is the standard naming for staging models |
| 15 | B | dbt is warehouse-agnostic. You bring the warehouse |
| 16 | B | `target/` is build artifacts. Delete + rerun = same result |
| 17 | B | DAG is built first (from `ref()`/`source()` calls), then Jinja → SQL, then execute |
| 18 | B | OLAP = analytical workloads = big scans + aggregations |
| 19 | C | `source(source_name, table_name)` — two-argument macro |
| 20 | C | Joins belong in intermediate, not staging. Staging is 1:1 with source |
| 21 | C | `dbt seed` loads CSVs. Or `dbt build` which includes seeds |
| 22 | B | Seeds are referenced exactly like models — via `ref()` |
| 23 | C | `unique` fails if any duplicate is found — passes only when all values are distinct |
| 24 | B | `relationships` enforces a FK to another model's column |
| 25 | C | `dbt build` = run + test + seed + snapshot in DAG order |
| 26 | B | Test failure on a model causes its descendants to be skipped — contains bad data |
| 27 | C | Intermediate is where joins of staging models live. Marts join intermediates |
| 28 | B | Acyclic = no cycles. A → B → A would be a cycle (illegal) |
| 29 | C | `+model` = include upstream. `model+` = include downstream |
| 30 | A | Plain folder name selects everything in that folder |
| 31 | C | `stg_orders+` selects this model and all descendants — the impact radius |
| 32 | B | `row_number() over (partition by ... order by ...)` is the window-function pattern |
| 33 | B | DRY says build once, ref many times. The intermediate is the canonical location |
| 34 | B | Fan-out: order columns duplicate N times when joined to an N-rows-per-order child |
| 35 | B | Aggregating first creates a 1:1 grain, making the join to orders safe |
| 36 | B | "Wide" = many columns from many sources joined in, so BI doesn't have to |
| 37 | C | Python models shine for text/ML/API work that's painful in SQL |
| 38 | C | Ephemeral = no DDL — dbt inlines as a CTE in downstream models |
| 39 | B | The course's stated best practice: views for staging, ephemeral/view for int, tables for marts |
| 40 | B | Model-level `config()` always overrides project-level defaults |
| 41 | B | Views are just stored queries — no data to write, but every query re-runs the SELECT |
| 42 | B | `+grants` is configured in `dbt_project.yml` under the `models:` key |
| 43 | C | `packages.yml` lists dbt packages (vs. `pyproject.toml`/`requirements.txt` for Python) |
| 44 | D | `<? ?>` is PHP-style, not Jinja. Jinja uses `{{ }}` (expression) and `{% %}` (statement) |
| 45 | B | Macros go in `macros/`. Models go in `models/`. Singular tests in `tests/` |
| 46 | A | Hash-based composite key for "primary key on multiple columns" |
| 47 | B | `loop.last` is true on the final iteration — commonly used to skip trailing commas |
| 48 | B | `target.name` differs per dbt target. The `if` filters dev only |
| 49 | B | "Atomic commits" = one logical change per commit. Standard git hygiene |
| 50 | D | All three are listed in the course's `packages.yml` |

---

## Scoring guide

- **45-50 right (90-100%)** — You're exam-ready. Drill the 1-5 you missed
- **40-44 (80-88%)** — Solid. Re-read the relevant study guide sections for misses
- **35-39 (70-78%)** — Decent but risky. Re-read sessions where you scored lowest
- **<35 (<70%)** — Re-read the full study guide and retake. There's still time

## What to do after

1. **Mark each miss** with the session it belongs to
2. **Re-read** that session's slides (`class_material/0X_*.md`)
3. **Re-attempt** the failed questions a day later
4. **Generate variations** — ask me for 20 more questions on the weakest topic
