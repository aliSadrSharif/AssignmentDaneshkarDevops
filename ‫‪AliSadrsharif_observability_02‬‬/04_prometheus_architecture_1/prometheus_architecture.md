# Prometheus Architecture

## 1. Pull-based vs Push-based: What's the difference? Why does Prometheus use Pull?

**Pull-based model**: The monitoring system (Prometheus) actively reaches out to targets on a schedule and requests ("scrapes") their current metrics from an HTTP endpoint (typically `/metrics`).

**Push-based model**: Targets/applications actively send their metrics to a central collector whenever they want (or on their own schedule), without the collector initiating the request.

**Why Prometheus uses Pull:**
- **Simpler service discovery and control**: Prometheus decides when and how often to scrape, giving centralized control over load and timing.
- **Easier health/liveness detection**: If a scrape fails, Prometheus immediately knows the target is down (via the `up` metric), without needing a separate heartbeat mechanism.
- **No need for targets to know about Prometheus**: Targets just expose an endpoint; they don't need credentials or configuration to "know" where to push data.
- **Easier debugging**: You can manually curl a target's `/metrics` endpoint to see exactly what Prometheus would scrape.
- **Better for ephemeral/batch jobs**, Prometheus offers the **Pushgateway** as an exception, allowing short-lived jobs to push metrics since they may not exist long enough to be scraped.

## 2. Main Components of Prometheus — what role does each play?

- **Prometheus Server**: The core component. It scrapes and stores time-series metrics data, evaluates PromQL queries and rules, and serves the HTTP API/UI.
- **Exporters**: Small helper processes that expose metrics from third-party systems (databases, hardware, OS, etc.) in a Prometheus-compatible format (e.g., Node Exporter for host-level metrics).
- **Service Discovery**: Mechanism that allows Prometheus to automatically discover scrape targets dynamically (e.g., via Docker, Kubernetes, DNS, or file-based configuration) instead of relying on static lists.
- **Alertmanager**: A separate component that receives alerts fired by Prometheus's rule evaluation, then handles deduplication, grouping, silencing, and routing notifications (email, Slack, PagerDuty, etc.).

## 3. Storage: How does Prometheus store data? What is TSDB?

Prometheus uses its own **Time Series Database (TSDB)**, a purpose-built local storage engine optimized for time-stamped, numeric data. Key points:

- Data is stored on local disk, organized in **blocks** covering fixed time ranges (default 2 hours for recent data).
- Older blocks are periodically compacted into larger blocks to save space and improve query performance.
- Each time series is identified by a metric name plus a unique set of label key-value pairs.
- TSDB is optimized for high-throughput writes (from scraping) and efficient range queries.
- It is **not** a general-purpose database — it's not meant for long-term storage of years of data (for that, remote storage integrations like Thanos, Cortex, or Mimir are typically used).

## 4. Scraping: What is Scraping and how does it work?

Scraping is the process by which Prometheus **pulls metrics** from targets over HTTP at regular intervals. Each target exposes its current metric values as plain text at an endpoint (usually `/metrics`).

How it works:
1. Prometheus reads its `scrape_configs` to know which targets to scrape and how often (`scrape_interval`).
2. At each interval, Prometheus sends an HTTP GET request to each target's metrics endpoint.
3. The target responds with a plain-text list of current metric values (counters, gauges, histograms, summaries).
4. Prometheus parses this response, attaches a timestamp, and stores each metric sample in its TSDB along with all associated labels.
5. If a scrape fails or times out, Prometheus records the target as `up == 0`.

## 5. Retention: What is Retention policy and how is it configured?

Retention policy defines **how long Prometheus keeps historical data** before deleting it. It's controlled via server startup flags, such as:

```
--storage.tsdb.retention.time=15d
```
(keep data for 15 days), or by size:
```
--storage.tsdb.retention.size=10GB
```
(keep data until it reaches 10GB, then start deleting the oldest data).

Once data exceeds the retention window, Prometheus automatically removes the oldest blocks to free up disk space. Longer retention is often achieved by exporting/remote-writing data to a long-term storage system rather than increasing local retention indefinitely.

## 6. High Availability: How can Prometheus be made Highly Available?

Prometheus itself is a **single-node system by design** and doesn't natively support clustering or built-in replication. Common approaches to achieve HA include:

- **Running multiple identical Prometheus replicas** that scrape the same targets independently. If one instance goes down, the others continue collecting data (though each has its own independent, potentially slightly different, dataset).
- **Using Alertmanager in cluster mode**, so alerts are deduplicated across multiple Prometheus replicas.
- **Remote storage / long-term storage systems** like Thanos, Cortex, or Mimir, which can deduplicate data across replicas, provide a unified global query view, and offer long-term retention beyond local disk limits.
- **Federation**: A hierarchical setup where a higher-level Prometheus scrapes aggregated data from multiple lower-level Prometheus servers (useful for scaling across large environments, though not true HA by itself).