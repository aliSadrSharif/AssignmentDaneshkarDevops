# RED Metrics — PromQL Examples for a Web Service

## 1. Rate — requests per second

```promql
rate(http_requests_total[5m])
```

**What it does:** Calculates the average number of requests per second over the last 5 minutes, based on a counter metric.

**When to use it:** To monitor traffic volume and detect sudden spikes or drops in load.

---

## 2. Errors — error percentage

```promql
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) * 100
```

**What it does:** Filters requests with a 5xx status code, divides their rate by the total request rate, and multiplies by 100 to get a percentage.

**When to use it:** To track service reliability and trigger alerts when the error percentage exceeds a defined threshold (e.g., an SLO).

---

## 3. Duration — response time (p95)

```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

**What it does:** Computes the 95th percentile of request duration from a histogram metric, meaning 95% of requests complete within this time.

**When to use it:** To monitor latency and user-perceived performance, especially useful for catching slow outliers that averages would hide.
