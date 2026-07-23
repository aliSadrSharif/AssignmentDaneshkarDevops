# Recording Rules Explanation

## 1. What are Recording Rules?

Recording Rules are pre-defined PromQL expressions that Prometheus **evaluates on a regular schedule** (e.g., every `interval`) and saves the result as a **new time series** in the TSDB, exactly as if it were a regularly scraped metric.

```yaml
groups:
  - name: example_rules
    interval: 30s
    rules:
      - record: job:http_requests:rate5m
        expr: rate(http_requests_total[5m])
```

Instead of recalculating `rate(http_requests_total[5m])` every single time it's queried (by a dashboard, an alert, or a person), Prometheus computes it once every 30 seconds and stores the result under the new metric name `job:http_requests:rate5m`. From then on, that name can be queried directly, just like any other metric.

## 2. Why do we use Recording Rules?

- **Performance**: Complex expressions (nested aggregations, `histogram_quantile`, subqueries) can be expensive to compute repeatedly. Precomputing them once reduces CPU/query load, especially when the same expression is queried frequently (e.g., by multiple dashboard panels or alert rules).
- **Consistency**: All consumers (dashboards, alerts, other rules) reference the exact same precomputed value, instead of each one potentially calculating slightly different results due to timing differences.
- **Simpler queries downstream**: Long, complex expressions can be referenced by a short, meaningful metric name instead of being repeated everywhere they're needed.
- **Faster dashboard loading**: Grafana panels that query a recording rule's output load much faster than ones that recompute an expensive expression from raw data on every refresh.
- **Building blocks for further aggregation**: Recording rules can be layered — one rule's output can be used as input to another rule or alert, similar to naming conventions used for RED metrics (e.g., `job:http_requests:rate5m`).

## 3. How do we enable Recording Rules in Prometheus?

1. Define the rules in a separate YAML file (e.g., `recording_rules.yml`), following the `groups` → `rules` structure with `record` and `expr` fields.
2. Reference that file in the main `prometheus.yml` configuration under the `rule_files` section:
   ```yaml
   rule_files:
     - "recording_rules.yml"
   ```
3. Mount/place the rules file so it's accessible to the Prometheus container (e.g., alongside `prometheus.yml`, via a Docker volume mount).
4. Restart Prometheus, or reload it without downtime if `--web.enable-lifecycle` is enabled:
   ```bash
   curl -X POST http://localhost:9090/-/reload
   ```
5. Verify the rules loaded correctly by checking the **Rules** page in the Prometheus web UI (`http://localhost:9090/rules`), or by querying the new metric name directly.

## 4. What is the difference between Recording Rules and Alerting Rules?

| | Recording Rules | Alerting Rules |
|---|---|---|
| **Purpose** | Precompute and store a new time series | Detect a condition and fire an alert |
| **`record` vs `alert` field** | Uses `record:` to name the new metric | Uses `alert:` to name the alert |
| **Output** | A new time series stored in the TSDB | An alert event sent to Alertmanager (when the expression evaluates to a non-empty result) |
| **Consumed by** | Dashboards, other queries, other rules | Alertmanager (for notifications, grouping, routing) |
| **Extra fields** | None beyond `record` and `expr` | Can include `for` (how long the condition must hold before firing), `labels`, and `annotations` (for alert metadata like severity and description) |

In short: **Recording Rules** answer "what is the current value of this expression?" and store it as data, while **Alerting Rules** answer "should we notify someone right now?" and produce alert events rather than stored metrics. Both are defined in the same `rule_files` structure and evaluated on the same `evaluation_interval`/`interval` mechanism, but they serve fundamentally different purposes in the monitoring pipeline.
