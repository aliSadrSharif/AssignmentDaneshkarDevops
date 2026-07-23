# PromQL Basics

## 1. Instant Queries: What are they and when are they used?

An **Instant Query** returns the value of a metric (or expression) at a **single point in time** — either "now" or a specific timestamp you provide. The result is a single value per unique time series (a **vector**), not a range of values over time.

**When used:**
- Checking the current state of a metric (e.g., "is this target up right now?")
- Powering single-value panels/stat panels in dashboards (e.g., current CPU usage)
- Quick debugging in the Prometheus web UI's "Table" view
- Evaluating alerting rule conditions (Prometheus evaluates alert expressions as instant queries on each evaluation cycle)

Example:
```promql
up
```
This returns the current value of `up` (1 or 0) for every scrape target, at the current moment.

## 2. Range Queries: What are they and how do they differ from Instant Queries?

A **Range Query** returns a **series of values over a time interval**, evaluated at regular steps between a start and end time, rather than a single snapshot.

**Difference from Instant Queries:**
| | Instant Query | Range Query |
|---|---|---|
| Output | One value per series (a single point in time) | A series of values over time (a matrix) |
| Used for | Current state, alert evaluation, stat panels | Graphing trends over time |
| API endpoint | `/api/v1/query` | `/api/v1/query_range` |
| Parameters | `query`, optional `time` | `query`, `start`, `end`, `step` |

Range queries are what power the graph panels in Grafana or the Prometheus UI's "Graph" tab, showing how a metric changed over the selected time window.

Note: functions like `rate()` and `increase()` require a **range vector selector** (e.g., `[5m]`) as their input, which is different from a "range query" in the API sense — but both concepts work together: a range vector selector defines the time window used *inside* a single evaluation, while a range query repeats evaluation across multiple time steps to produce a graph.

## 3. Selectors: How do we use labels to filter?

A **selector** identifies which time series to select, based on the metric name and optionally a set of label matchers in curly braces `{}`.

**Label matcher operators:**
- `=` — exact match: `status="200"`
- `!=` — not equal: `status!="200"`
- `=~` — regex match: `status=~"5.."`
- `!~` — negative regex match: `status!~"2.."`

Example:
```promql
http_requests_total{method="GET", status="200"}
```
This selects only the time series of `http_requests_total` where the `method` label equals `"GET"` **and** the `status` label equals `"200"` (multiple matchers inside `{}` are combined with AND logic).

Selectors are the foundation of almost every PromQL query — they narrow down which specific time series a function or aggregation should operate on.

## 4. Operators: Types of operators in PromQL

PromQL supports several categories of operators:

- **Arithmetic operators**: `+`, `-`, `*`, `/`, `%`, `^` — used for math between two vectors or between a vector and a scalar (e.g., `rate(errors[5m]) * 100`).
- **Comparison operators**: `==`, `!=`, `>`, `<`, `>=`, `<=` — used to filter series based on their value (e.g., `up == 0` returns only targets that are down).
- **Logical/set operators**: `and`, `or`, `unless` — combine or filter results between two vectors based on matching label sets.
- **Aggregation operators**: `sum`, `avg`, `min`, `max`, `count`, `stddev`, `stdvar`, `topk`, `bottomk`, `quantile` — reduce many time series down to fewer series (or one), optionally grouped `by (...)` or `without (...)` specific labels.

Example combining several:
```promql
sum(rate(http_requests_total{status=~"5.."}[5m])) by (job) > 10
```

## 5. Functions: Important PromQL functions

Some of the most commonly used PromQL functions:

- **`rate(v range-vector)`** — calculates the per-second average rate of increase of a counter over the given time range; automatically handles counter resets.
- **`irate(v range-vector)`** — similar to `rate()`, but uses only the last two data points, useful for fast-moving, volatile counters.
- **`increase(v range-vector)`** — calculates the total increase of a counter over the given time range (essentially `rate()` multiplied by the number of seconds in the range).
- **`histogram_quantile(φ, b)`** — calculates a quantile (e.g., 0.95 for p95) from histogram bucket data.
- **`sum()`, `avg()`, `min()`, `max()`, `count()`** — aggregation functions that combine multiple time series into fewer series.
- **`abs()`, `round()`, `floor()`, `ceil()`** — mathematical utility functions.
- **`label_replace()`** — adds or modifies a label on a vector based on a regex match against another label's value.
- **`time()`** — returns the current Unix timestamp, useful for calculating durations (e.g., `time() - process_start_time_seconds`).
