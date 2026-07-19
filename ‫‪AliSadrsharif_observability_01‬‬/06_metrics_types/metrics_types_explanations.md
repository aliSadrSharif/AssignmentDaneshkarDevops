# Prometheus Metric Types

## 1. Counter

### What is it and what are its characteristics?

A **Counter** is a metric that only increases over time. It represents the cumulative number of events that have occurred since the application started.

**Characteristics:**
- Only increases (or resets to zero after an application restart).
- Cannot decrease manually.
- Best for counting events.
- Often used with PromQL functions such as `rate()` and `increase()`.

### When is it used?

Counters are used whenever you need to count how many times an event has occurred, such as:
- HTTP requests
- Errors
- Processed jobs
- Login attempts

### Example: `http_requests_total`

`http_requests_total` counts the total number of HTTP requests received by a server.

Example values:

| Time | Value |
|------|------:|
| 10:00 | 1,250 |
| 10:05 | 1,430 |
| 10:10 | 1,610 |

The value only increases unless the application restarts.

---

## 2. Gauge

### What is it and what are its characteristics?

A **Gauge** is a metric that represents a value that can both increase and decrease over time.

**Characteristics:**
- Can increase or decrease.
- Represents the current state of a resource.
- Shows instantaneous measurements.
- Does not require calculating a rate.

### When is it used?

Gauges are used for measurements that change continuously, such as:
- Memory usage
- CPU temperature
- Number of active users
- Queue size
- Disk usage

### Example: `memory_usage_bytes`

`memory_usage_bytes` shows the current amount of memory used by an application.

Example values:

| Time | Value |
|------|------:|
| 10:00 | 420 MB |
| 10:05 | 480 MB |
| 10:10 | 395 MB |

The value may increase or decrease depending on memory usage.

---

## 3. Histogram

### What is it and what are its characteristics?

A **Histogram** measures the distribution of observed values by placing them into configurable buckets.

**Characteristics:**
- Stores observations in buckets.
- Automatically generates three metrics:
  - `_bucket`
  - `_sum`
  - `_count`
- Can calculate percentiles using PromQL (`histogram_quantile()`).
- Suitable for aggregating data across multiple instances.

### When is it used?

Histograms are commonly used for measuring:
- HTTP request latency
- Response time
- Request size
- Database query duration
- Processing time

### Example: `http_request_duration_seconds`

This metric measures how long HTTP requests take.

Example bucket metrics:

```
http_request_duration_seconds_bucket{le="0.1"} 850
http_request_duration_seconds_bucket{le="0.5"} 980
http_request_duration_seconds_bucket{le="1"} 998
http_request_duration_seconds_bucket{le="+Inf"} 1000

http_request_duration_seconds_sum 245.7
http_request_duration_seconds_count 1000
```

This means:
- 850 requests completed in less than 100 ms.
- 980 requests completed in less than 500 ms.
- 1,000 requests were recorded in total.

---

## 4. Summary

### What is it and how is it different from Histogram?

A **Summary** also measures the distribution of observations, but it calculates quantiles (percentiles) directly on the client side instead of using buckets.

**Characteristics:**
- Calculates quantiles such as the 50th, 90th, and 99th percentiles.
- Also provides `_sum` and `_count`.
- Does not expose bucket metrics.
- Quantiles cannot be accurately aggregated across multiple application instances.

### Difference between Summary and Histogram

| Feature | Histogram | Summary |
|--------|-----------|---------|
| Uses buckets | Yes | No |
| Calculates quantiles | Server-side (PromQL) | Client-side |
| Aggregates across multiple instances | Yes | No |
| Suitable for distributed systems | Yes | Limited |
| Provides `_bucket` metrics | Yes | No |

### When is it used?

Summary is useful when:
- You need accurate latency percentiles for a single application instance.
- Aggregation across multiple instances is not required.
- Client-side quantile calculation is preferred.

### Example: `rpc_duration_seconds`

```
rpc_duration_seconds{quantile="0.5"} 0.12
rpc_duration_seconds{quantile="0.9"} 0.38
rpc_duration_seconds{quantile="0.99"} 0.91

rpc_duration_seconds_sum 132.6
rpc_duration_seconds_count 1200
```

This indicates:
- 50% of RPC calls finished within 0.12 seconds.
- 90% finished within 0.38 seconds.
- 99% finished within 0.91 seconds.

---

# Real Prometheus Metric Examples

| Metric Type | Real Metric | Description |
|-------------|-------------|-------------|
| Counter | `http_requests_total` | Total number of HTTP requests received. |
| Gauge | `memory_usage_bytes` | Current memory usage in bytes. |
| Histogram | `http_request_duration_seconds` | Distribution of HTTP request durations using buckets. |
| Summary | `rpc_duration_seconds` | Distribution of RPC request durations with calculated quantiles. |

---

# Summary

| Metric | Can Decrease? | Typical Usage |
|--------|---------------|---------------|
| Counter | ❌ No | Counting events such as requests, errors, and processed jobs |
| Gauge | ✅ Yes | Current values such as memory, CPU, and active connections |
| Histogram | Depends on observations | Measuring value distributions with buckets |
| Summary | Depends on observations | Measuring value distributions with client-side quantiles |