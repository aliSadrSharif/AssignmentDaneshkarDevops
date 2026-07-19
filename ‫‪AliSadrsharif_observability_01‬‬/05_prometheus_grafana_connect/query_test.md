# Prometheus Metrics

## 1. What does the `up` query show?

The **`up`** metric is one of the default metrics provided by Prometheus. It indicates whether Prometheus can successfully scrape a target.

Possible values:

- **`1`** – The target is **up** and Prometheus successfully collected metrics from it.
- **`0`** – The target is **down** or Prometheus failed to scrape metrics from it.

Example query:

```promql
up
```

Example output:

| Instance | Job | Value |
|----------|-----|------:|
| localhost:9090 | prometheus | 1 |
| localhost:9100 | node_exporter | 1 |

This metric is commonly used to monitor the availability of monitored services and to trigger alerts when a target becomes unreachable.

---

## 2. What other metrics are available in Prometheus by default?

Prometheus exposes many built-in metrics about its own operation. Some common default metrics include:

| Metric | Description |
|---------|-------------|
| `up` | Indicates whether a target was successfully scraped. |
| `scrape_duration_seconds` | Time taken to scrape a target. |
| `scrape_samples_scraped` | Number of samples collected during a scrape. |
| `scrape_samples_post_metric_relabeling` | Number of samples after metric relabeling. |
| `prometheus_build_info` | Version and build information for Prometheus. |
| `prometheus_engine_queries` | Number of executed PromQL queries. |
| `prometheus_http_requests_total` | Total HTTP requests handled by Prometheus. |
| `prometheus_tsdb_head_series` | Number of active time series stored in memory. |
| `process_cpu_seconds_total` | Total CPU time used by the Prometheus process. |
| `process_resident_memory_bytes` | Memory currently used by the Prometheus process. |
| `go_goroutines` | Number of active Go routines. |
| `go_memstats_alloc_bytes` | Memory allocated by the Go runtime. |

When exporters (such as Node Exporter or cAdvisor) are connected, many additional metrics become available, including CPU usage, memory usage, disk I/O, filesystem statistics, and network traffic.

---

## 3. How can you view the list of all metrics?

There are several ways to view all available metrics in Prometheus:

### Method 1: Prometheus Expression Browser

1. Open the Prometheus web interface (typically `http://localhost:9090`).
2. Go to the **Graph** page.
3. Click the **Metrics** drop-down list.
4. Browse or search for available metric names.

### Method 2: Use the `__name__` query

Run the following PromQL query:

```promql
{__name__=~".+"}
```

This returns all available metric names currently stored in Prometheus.

### Method 3: Metrics endpoint

Open the Prometheus metrics endpoint:

```
http://localhost:9090/metrics
```

This endpoint displays all metrics that Prometheus exposes about itself in plain text format.

### Method 4: Grafana Query Editor

If Prometheus is configured as a Grafana data source:

1. Create a new panel.
2. Select **Prometheus** as the data source.
3. Click the **Metrics** selector or start typing a metric name.
4. Grafana will display all available metrics with autocomplete.