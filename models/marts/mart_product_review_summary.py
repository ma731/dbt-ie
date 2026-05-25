import polars as pl


def model(dbt, session):
    """
    Product review aggregation using Polars.

    Shows the Polars style: method chaining, lazy expressions, and
    .when().then().otherwise() — Polars' equivalent of SQL CASE WHEN,
    but written as Python method calls inside .with_columns().

    To get a Polars DataFrame from dbt.ref():
      dbt.ref() → DuckDBPyRelation → .arrow() → PyArrow Table → pl.from_arrow()
    """
    dbt.config(materialized="table")

    # Load upstream models and convert to Polars via Arrow
    reviews = pl.from_arrow(dbt.ref("stg_reviews").arrow())
    products = pl.from_arrow(dbt.ref("stg_products").arrow())

    summary = (
        reviews
        # Step 1 — aggregate: one row per product
        .group_by("product_id")
        .agg([
            pl.col("rating").mean().round(2).alias("avg_rating"),
            pl.col("rating").count().alias("review_count"),
            (pl.col("rating") >= 4).sum().alias("positive_count"),
            (pl.col("rating") <= 2).sum().alias("negative_count"),
            pl.col("helpful_votes").sum().alias("total_helpful_votes"),
        ])
        # Step 2 — add derived columns with Polars expressions
        .with_columns([
            (pl.col("positive_count") / pl.col("review_count") * 100)
            .round(1)
            .alias("pct_positive"),
            # when/then/otherwise is Polars' CASE WHEN — written as chained Python calls
            pl.when(pl.col("avg_rating") >= 4.0)
            .then(pl.lit("well_reviewed"))
            .when(pl.col("avg_rating") >= 3.0)
            .then(pl.lit("mixed"))
            .otherwise(pl.lit("poorly_reviewed"))
            .alias("review_tier"),
        ])
        # Step 3 — join product metadata
        .join(
            products.select(["product_id", "product_name", "price"]),
            on="product_id",
            how="left",
        )
        .select([
            "product_id",
            "product_name",
            "price",
            "avg_rating",
            "review_count",
            "positive_count",
            "negative_count",
            "pct_positive",
            "total_helpful_votes",
            "review_tier",
        ])
        .sort("avg_rating", descending=True)
    )

    return summary
