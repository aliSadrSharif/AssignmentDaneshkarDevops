# Question 1.1 — Understanding RED Metrics

## 1. What is RED Metrics? What does each letter mean?

RED is a monitoring model designed for request-driven services (especially microservices). It tracks three key metrics:

- **R — Rate**: the number of requests a service receives per unit of time (typically requests per second)
- **E — Errors**: the rate or percentage of requests that fail
- **D — Duration**: the amount of time it takes to respond to a request (latency)

Together, these three metrics give a complete picture of a service's health and performance.

## 2. What is Rate and how is it calculated? Give a practical example

Rate is the number of requests a service handles per unit time (usually per second). In Prometheus, it's typically calculated using the `rate()` function applied to a counter metric, since counters only increase and `rate()` computes the average per-second increase over a time window.

**Practical example:**
```promql
rate(http_requests_total[5m])
```
This returns the average number of requests per second over the last 5 minutes.

## 3. What is Errors? What types of errors should be monitored? How is it measured in Prometheus?

Errors that impact user experience or system correctness should be monitored, such as:
- Server-side HTTP errors (5xx status codes)
- Application-level/business logic errors
- Timeouts or failures when calling dependent services

In Prometheus, this is typically measured by filtering the status code label on the same counter used for Rate:
```promql
rate(http_requests_total{status=~"5.."}[5m])
```
And for the error percentage:
```promql
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])
```

## 4. What is Duration and how does it differ from Latency? How is it measured?

Duration is the total time it takes to fully process a request and return a response. In practice, Duration and Latency are often used interchangeably, but a distinction is sometimes made:
- **Latency** typically refers to the delay before processing begins (e.g., network or queue time)
- **Duration** refers to the total end-to-end processing time of the request

In Prometheus, this is usually measured using a **Histogram** or **Summary** metric, which allows calculating percentiles like p95 or p99:
```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

## 5. Why is RED Metrics important for microservices?

In a microservices architecture with dozens or hundreds of independently deployed services:
- Each service can be monitored independently using a consistent standard
- It's quick to identify which service is having problems (high error rate or high latency)
- It provides a uniform basis for alerting and defining SLOs/SLAs
- It simplifies debugging issues across a chain of interconnected services (root cause analysis)

## 6. How can RED Metrics be implemented in Prometheus?

1. In the application code, define a **counter** for total requests per endpoint (with labels like `method`, `status`, `path`) and a **histogram** for request duration — typically using a client library (e.g., `prometheus-client`).
2. Prometheus scrapes these metrics from each service's `/metrics` endpoint.
3. Query with PromQL:
   - Rate → `rate(http_requests_total[5m])`
   - Errors → `rate(http_requests_total{status=~"5.."}[5m])`
   - Duration → `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))`
4. These queries can be wired into Grafana dashboards or Alertmanager rules.
