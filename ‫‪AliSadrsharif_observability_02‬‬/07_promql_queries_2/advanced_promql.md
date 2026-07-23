# Advanced PromQL

## 1. Histogram Queries: How do we use Histogram metrics?

A Histogram metric samples observations (like request durations) and counts them into configurable **buckets**, while also tracking a running `_sum` and `_count`. For a metric named `http_request_duration_seconds`, Prometheus automatically exposes:

- `http_request_duration_seconds_bucket{le="..."}` — cumulative count of observations less than or equal to each bucket boundary (`le` = "less than or equal")
- `http_request_duration_seconds_sum` — running total of all observed values
- `http_request_duration_seconds_count` — total number of observations

To use histogram data, you typically:
1. Apply `rate()` to the `_bucket` series over a time window to get per-second bucket counts.
2. Pass that into `histogram_quantile()` to estimate a percentile (see below).
3. Or divide `rate(_sum[5m]) / rate(_count[5m])` to get the **average** observed value over that window.

## 2. Quantiles: How do we calculate quantiles?

A quantile (e.g., p50, p95, p99) tells you the value below which a given percentage of observations fall. For Histogram metrics, quantiles are calculated using the `histogram_quantile()` function:

```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

- The first argument (`0.95`) is φ (phi), a number between 0 and 1 representing the desired quantile (0.95 = 95th percentile).
- The second argument must be a **rate of bucket counters**, grouped by the `le` label (Prometheus does this automatically based on bucket boundaries).
- The result is an **interpolated estimate** — since histograms use fixed buckets rather than storing every individual observation, the quantile value is approximated based on which buckets the data falls into, not computed with perfect precision.

**Note:** Summary metrics can also expose pre-calculated quantiles directly (e.g., `http_request_duration_seconds{quantile="0.95"}`), but those are calculated client-side per instance and can't be aggregated across instances the way histogram-based quantiles can.

## 3. Subqueries: What are they and when are they used?

A subquery allows you to run a **range query as the input to a range vector function**, essentially nesting an "instant query evaluated repeatedly over time" inside another function — something a plain range vector selector (like `[5m]`) can't do because it only reads raw samples, not the result of another expression evaluated over time.

Syntax: `<expression>[range:resolution]`

Example:
```promql
max_over_time(rate(http_requests_total[5m])[30m:1m])
```
This computes `rate(http_requests_total[5m])` at every 1-minute step over the past 30 minutes, then takes the max of those computed rate values.

**When used:**
- When you need to apply a function (like `max_over_time`, `avg_over_time`) to the *result of another function* (like `rate()`) evaluated repeatedly over time — not to raw metric samples.
- Useful for questions like "what was the highest 5-minute request rate at any point in the last hour?"

Subqueries are powerful but computationally expensive, since they force Prometheus to re-evaluate the inner expression at every resolution step — they should be used sparingly, and Recording Rules are often a better alternative for frequently-needed subquery-like calculations.

## 4. Recording Rules: What are they and what advantages do they offer?

Recording Rules let you **precompute frequently-used or computationally expensive PromQL expressions** and save the result as a new, regular time series — evaluated on a schedule (e.g., every `evaluation_interval`) rather than recalculated from scratch every time someone queries it.

```yaml
groups:
  - name: example_rules
    rules:
      - record: job:http_requests:rate5m
        expr: rate(http_requests_total[5m])
```

**Advantages:**
- **Performance**: Complex or expensive queries (e.g., involving `histogram_quantile`, subqueries, or heavy aggregations) are computed once on a schedule instead of on every dashboard load or every alert evaluation.
- **Consistency**: Dashboards, alerts, and other queries can all reference the same precomputed series, ensuring consistent values across the system.
- **Simpler downstream queries**: Other PromQL expressions (dashboards, alert rules, other recording rules) can reference the precomputed metric name directly instead of repeating a long, complex expression everywhere.
- **Reduced load at query time**: Especially valuable at scale, where thousands of dashboard queries or frequent alert evaluations would otherwise repeatedly recompute the same expensive expression.

## 5. Vector Matching: What is it and how does it work?

Vector matching defines how PromQL combines two instant vectors in a binary operation (arithmetic, comparison, or logical), based on **matching label sets** between the two sides.

**Types of matching:**
- **One-to-one matching** (default): Every series on the left is matched with exactly one series on the right that has the *same label set* (excluding the metric name). If labels don't match exactly on both sides, Prometheus can't pair them and drops that series from the result.
- **`on(...)` / `ignoring(...)`**: Explicitly control which labels are used (or ignored) when matching series between the two vectors, useful when the two metrics don't share identical label sets.
- **`group_left(...)` / `group_right(...)`**: Used for **many-to-one** or **one-to-many** matching, where one side has multiple series matching a single series on the other side (e.g., attaching extra metadata labels from a low-cardinality metric onto a high-cardinality one).

Example:
```promql
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100
```
Here, the two `sum()` results are matched implicitly (both reduce down to a single value with no remaining labels), and the division works because both sides end up with an empty/matching label set after aggregation.

Vector matching is essential for combining related metrics (like error rate ÷ total rate) or joining metadata from one series onto another.
