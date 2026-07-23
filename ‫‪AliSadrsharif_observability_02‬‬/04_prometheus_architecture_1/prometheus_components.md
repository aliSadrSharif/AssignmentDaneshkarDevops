# Prometheus Components

## 1. Prometheus Server — main responsibilities, how it works

The Prometheus Server is the core of the entire system. Its main responsibilities are:

- **Scraping**: Periodically pulling metrics from configured targets over HTTP.
- **Storage**: Persisting the scraped metrics as time series in its local TSDB.
- **Querying**: Evaluating PromQL queries submitted via the HTTP API, web UI, or Grafana.
- **Rule evaluation**: Continuously evaluating recording rules (to precompute expensive queries) and alerting rules (to detect conditions that should trigger alerts).
- **Alert forwarding**: Sending fired alerts to Alertmanager for routing and notification.

How it works: the server reads its configuration file (`prometheus.yml`), which defines scrape targets/intervals, rule files, and alerting configuration. On each scrape interval, it collects fresh data, stores it, evaluates rules against it, and makes everything queryable via its API and UI (port 9090 by default).

## 2. Exporters — types, how they work

Exporters are lightweight processes/agents that translate metrics from a third-party system into the Prometheus text exposition format, exposed over an HTTP endpoint (usually `/metrics`).

**How they work**: An exporter runs alongside (or as a sidecar to) the system being monitored, collects data from that system (via APIs, files, protocols, etc.), converts it to Prometheus format, and serves it so Prometheus can scrape it like any other target.

**Common types:**
- **Node Exporter**: Exposes hardware and OS-level metrics (CPU, memory, disk, network) for Linux/Unix hosts.
- **cAdvisor**: Exposes container resource usage and performance metrics.
- **Blackbox Exporter**: Probes endpoints over HTTP, TCP, DNS, or ICMP to check availability/latency from the outside.
- **MySQL/PostgreSQL/Redis Exporters**: Expose database-specific internal metrics.
- **Custom application exporters**: Built directly into applications using Prometheus client libraries to expose business/application-level metrics.

## 3. Pushgateway — when is it used?

The Pushgateway is used for **short-lived or batch jobs** that finish executing before Prometheus would have a chance to scrape them (e.g., a cron job or CI/CD pipeline step that runs for a few seconds).

Since Prometheus is pull-based, it can't scrape a job that no longer exists by the time the next scrape interval occurs. Instead, the job **pushes** its final metric values to the Pushgateway, which holds/caches them. Prometheus then scrapes the Pushgateway itself (like any regular target), picking up the last pushed values.

**Important note**: Pushgateway should only be used for this specific use case — it is **not** meant as a general replacement for the pull model, since metrics pushed to it persist until explicitly deleted, and using it for regular long-running services undermines Prometheus's staleness/health detection (the `up` metric no longer reflects individual job health).

## 4. Alertmanager — role in the alerting pipeline

Alertmanager is a separate component responsible for handling alerts **after** they've been fired by the Prometheus server's rule evaluation. Its role includes:

- **Receiving alerts**: Prometheus sends alerts to Alertmanager via its API whenever an alerting rule condition is met.
- **Deduplication**: Combines identical alerts coming from multiple Prometheus instances (useful in HA setups) into a single notification.
- **Grouping**: Bundles related alerts together into a single notification (e.g., all alerts for the same service or cluster) to avoid notification spam.
- **Silencing**: Allows alerts to be temporarily muted (e.g., during planned maintenance).
- **Inhibition**: Suppresses certain alerts if another, more critical alert is already firing (e.g., suppress "high latency" alerts if "service down" is already firing for the same service).
- **Routing**: Sends notifications to the correct destination (email, Slack, PagerDuty, webhook, etc.) based on configurable routing rules and labels.

In short: Prometheus **detects and fires** alert conditions, while Alertmanager **manages and delivers** the resulting notifications.