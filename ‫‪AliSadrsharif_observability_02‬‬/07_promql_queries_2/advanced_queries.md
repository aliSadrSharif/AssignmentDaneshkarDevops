# Advanced Queries Explained

## 1. Histogram quantile

```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

- **What it does:** Estimates the 95th percentile (p95) of request duration, based on histogram bucket data collected over the last 5 minutes.
- **Breaking it down:**
  - `http_request_duration_seconds_bucket[5m]` — the raw bucket counter samples over the last 5 minutes, grouped by the `le` (less-than-or-equal) label.
  - `rate(...)` — converts the cumulative bucket counters into a per-second rate for each bucket.
  - `histogram_quantile(0.95, ...)` — interpolates across the bucket boundaries to estimate the value below which 95% of observations fall.
- **Data type returned:** Instant vector — one estimated p95 duration value per label set (e.g., per instance, per endpoint).
- **Use case:** Monitoring tail latency — showing that "95% of requests complete within X seconds," which is far more meaningful than a simple average for spotting slow outliers.

## 2. Rate with multiple time ranges

```promql
rate(http_requests_total[5m]) / rate(http_requests_total[15m])
```

- **What it does:** Compares the short-term (5-minute) request rate against the longer-term (15-minute) request rate, as a ratio.
- **Breaking it down:**
  - `rate(http_requests_total[5m])` — recent, more reactive traffic rate.
  - `rate(http_requests_total[15m])` — smoother, longer-term baseline traffic rate.
  - Dividing the two gives a ratio: values above 1 mean traffic recently increased relative to the longer trend; values below 1 mean it recently decreased.
- **Data type returned:** Instant vector — one ratio value per matching series.
- **Use case:** Detecting sudden traffic spikes or drops relative to a recent baseline, useful for anomaly detection or auto-scaling triggers.

## 3. Conditional aggregation

```promql
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100
```

- **What it does:** Calculates the overall error rate as a percentage, across all instances/series combined.
- **Breaking it down:**
  - `http_requests_total{status=~"5.."}` — filters to only server-error (5xx) requests using a regex label matcher.
  - `rate(...[5m])` applied to both the filtered errors and the total requests, giving per-second rates.
  - `sum(...)` on each side collapses all individual series (e.g., per instance/path) into one total number.
  - Dividing errors by total and multiplying by 100 converts the ratio into a percentage.
- **Data type returned:** Instant vector — a single scalar-like value (one series with no remaining labels) representing the overall error percentage.
- **Use case:** A classic RED-metrics style alert or dashboard panel: "what percentage of all requests across the whole service are currently failing?" — often used directly in an alerting rule (e.g., alert if > 5%).

## 4. Label replacement

```promql
label_replace(up, "new_label", "$1", "instance", "(.*):.*")
```

- **What it does:** Creates a new label called `new_label` on the `up` metric, derived from part of the existing `instance` label (specifically, everything before the `:` — typically the hostname/IP, stripped of the port).
- **Breaking it down:**
  - `up` — the base vector being transformed.
  - `"new_label"` — the name of the label to add/overwrite.
  - `"$1"` — the replacement value, referencing the first regex capture group.
  - `"instance"` — the source label being matched against.
  - `"(.*):.*"` — the regex pattern; `(.*)` captures everything before the colon (the host part), and `:.*` matches the port (discarded).
- **Data type returned:** Instant vector — same series as `up`, but with an additional/modified label.
- **Use case:** Extracting a cleaner value from an existing label (e.g., turning `instance="10.0.0.5:9100"` into `new_label="10.0.0.5"`) for grouping, display, or joining with other metrics that don't include the port.

## 5. Time-based functions

```promql
time() - process_start_time_seconds
```

- **What it does:** Calculates how long (in seconds) a process has been running, i.e., its uptime.
- **Breaking it down:**
  - `time()` — returns the current Unix timestamp (seconds since epoch) at query evaluation time.
  - `process_start_time_seconds` — a standard metric exposed by most Prometheus client libraries, representing the Unix timestamp when the process started.
  - Subtracting the two gives the elapsed time in seconds since the process started.
- **Data type returned:** Instant vector — one uptime value (in seconds) per process/instance.
- **Use case:** Monitoring process uptime, detecting unexpected restarts (a sudden drop in this value indicates a crash/restart), or building an "uptime" panel on a dashboard.
