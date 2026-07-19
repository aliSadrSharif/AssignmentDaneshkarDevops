# Grafana Explore Usage

## 1. What is the difference between `prometheus_http_requests_total` and `rate(prometheus_http_requests_total[5m])`?

### `prometheus_http_requests_total`
- This is a **Counter** metric.
- It shows the **total number of HTTP requests** since the application started.
- The value only increases (except when the application restarts).
- It is useful for seeing the cumulative number of requests.

**Example:**
```
prometheus_http_requests_total = 15000
```
This means the application has processed 15,000 requests since startup.

### `rate(prometheus_http_requests_total[5m])`
- The `rate()` function calculates the **average increase per second** over the last 5 minutes.
- It shows the current request rate instead of the total count.
- It is commonly used for monitoring traffic and creating dashboards.

**Example:**
```
rate(prometheus_http_requests_total[5m]) = 25
```
This means the application is handling approximately **25 requests per second** during the last 5 minutes.

---

## 2. When should you use the Table visualization?

Use **Table** visualization when:
- Displaying raw metric values.
- Comparing multiple metrics or labels.
- Viewing detailed information.
- Listing data with columns such as instance, job, status, or value.

**Example:**
| Instance | Status | Requests |
|----------|--------|----------|
| server-1 | UP | 1200 |
| server-2 | UP | 980 |

---

## 3. When should you use the Graph visualization?

Use **Graph** visualization when:
- Displaying metrics that change over time.
- Monitoring CPU, memory, network traffic, or request rates.
- Identifying trends, spikes, or performance issues.
- Comparing multiple time series.

**Example:**
- CPU usage over the last 24 hours.
- HTTP requests per second.
- Memory usage during application execution.

---

## 4. How does the Time Range affect the results?

The selected **Time Range** determines the period from which Grafana retrieves data from Prometheus.

For example:
- **Last 5 minutes:** Shows only recent metric values.
- **Last 1 hour:** Displays a longer trend.
- **Last 24 hours:** Shows historical behavior and long-term patterns.

The time range also affects:
- The number of returned data points.
- The calculated values of functions like `rate()`, `increase()`, and `avg_over_time()`.
- Dashboard performance, since larger time ranges require more data to be queried.

Choosing an appropriate time range helps provide accurate analysis while keeping dashboards responsive.