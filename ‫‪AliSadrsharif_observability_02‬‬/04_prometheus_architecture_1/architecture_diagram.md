# Prometheus Architecture Diagram

## 1. How Prometheus scrapes Exporters (Pull model)

```
   +------------------+           HTTP GET /metrics            +--------------------+
   |                  |  ------------------------------------> |   Node Exporter    |
   |                  |         (every scrape_interval)        |   (port 9100)      |
   |                  |  <------------------------------------ +--------------------+
   |                  |         returns metrics text
   |                  |
   |   Prometheus     |           HTTP GET /metrics            +--------------------+
   |   Server         |  ------------------------------------> |  Application /     |
   |   (port 9090)    |                                        |  Custom Exporter   |
   |                  |  <------------------------------------ +--------------------+
   |                  |
   |                  |           HTTP GET /metrics            +--------------------+
   |                  |  ------------------------------------> |  Other Exporters   |
   |                  |  <------------------------------------ |  (MySQL, Redis...) |
   +------------------+                                        +--------------------+
```

Prometheus initiates every request (**PULL**). Targets are defined via `static_configs` or Service Discovery. Scraped samples are written into Prometheus's local TSDB with a timestamp.

---

## 2. How Alertmanager communicates with Prometheus

```
   +------------------+                                       +--------------------+
   |   Prometheus     |   evaluates alerting rules against    |                    |
   |   Server         |   stored metrics (e.g. every 15s)     |                    |
   |                  |                                       |                    |
   |   Rule Engine    |---- fires alert when condition -----> |   Alertmanager     |
   |                  |   is true (HTTP POST /api/v2/alerts)  |   (port 9093)      |
   +------------------+                                       |                    |
                                                              |  - Deduplicate     |
                                                              |  - Group           |
                                                              |  - Silence         |
                                                              |  - Route           |
                                                              +---------+----------+
                                                                         |
                                                     sends notification  |
                                                                         v
                                                       +----------------------------+
                                                       | Email / Slack / PagerDuty  |
                                                       | / Webhook / etc.           |
                                                       +----------------------------+
```

Prometheus **pushes alerts** to Alertmanager (Prometheus → Alertmanager, one-way). Alertmanager never scrapes Prometheus; it only receives alert events from it.

---

## 3. How Grafana gets data from Prometheus

```
   +------------------+        PromQL query over HTTP          +--------------------+
   |                  |  ------------------------------------> |                    |
   |     Grafana      |     GET /api/v1/query_range?query=...  |    Prometheus      |
   |   (port 3000)    |                                        |    Server          |
   |                  |  <------------------------------------ |   (port 9090)      |
   |   Dashboards     |     JSON result (time series data)     |                    |
   +------------------+                                        +--------------------+
```

Grafana is configured with Prometheus as a **data source** (its HTTP API URL, e.g. `http://prometheus:9090`). When a dashboard panel loads or refreshes, Grafana sends a PromQL query to Prometheus's HTTP API and renders the JSON response as graphs/tables. Grafana never scrapes targets directly — it only queries Prometheus, which already holds the scraped and stored data.

---

## Summary of Data Flow

```
Exporters/Apps --(pulled by)--> Prometheus Server --(stores in)--> TSDB
Prometheus Server --(fires alerts to)--> Alertmanager --(notifies)--> Email/Slack/etc.
Grafana --(queries via PromQL)--> Prometheus Server --(reads from)--> TSDB
```