# Docker Compose Explanation — Prometheus + Grafana + Node Exporter Stack

## 1. Why do we use a Docker Network?

A Docker Network (in this case, the custom bridge network `monitoring`) is used to enable **communication between containers**. When multiple services (Prometheus, Grafana, Node Exporter) are attached to the same network, they can reach each other using their **container/service name as a hostname**, without needing to know IP addresses or expose ports to the host.

For example, because Prometheus and Node Exporter are on the same `monitoring` network, Prometheus can scrape Node Exporter using:
```
node_exporter:9100
```
instead of relying on the host's IP or a published port. This also improves security and isolation, since containers on the same custom network can talk to each other, while services not meant to be reachable from outside don't need to expose ports on the host at all.

## 2. What role does `depends_on` play?

`depends_on` defines the **startup order** of services. In this compose file, Grafana has:
```yaml
depends_on:
  - prometheus
```
This ensures that the `prometheus` container is **started before** the `grafana` container.

**Important caveat:** `depends_on` only guarantees the container has *started* — it does **not** wait for Prometheus to be fully ready (i.e., its HTTP API responding). For full readiness checks, a `healthcheck` combined with `condition: service_healthy` would be needed. But for this basic setup, `depends_on` is enough to make sure Prometheus begins starting up first.

## 3. What data do the different Volumes store?

Two named volumes are defined in this stack:

- **`prometheus_data`** → mounted at `/prometheus` inside the Prometheus container. It stores the **Time Series Database (TSDB)** — all the scraped metrics data. Without this volume, all historical metrics would be lost whenever the container is removed or recreated.

- **`grafana_data`** → mounted at `/var/lib/grafana` inside the Grafana container. It stores Grafana's **internal SQLite database**, including dashboards, data source configurations, users, and settings. Without this volume, any dashboards or configuration created in the Grafana UI would be lost on container recreation.

Both volumes ensure that data **persists independently of the container's lifecycle** — containers can be stopped, removed, or recreated without losing stored data.

## 4. How can services be restarted individually?

Instead of restarting the entire stack, a single service can be restarted using:
```bash
docker compose restart <service>
```

For example, to restart only Prometheus after a config change:
```bash
docker compose restart prometheus
```

Or to restart only Grafana:
```bash
docker compose restart grafana
```

This stops and starts just that one container, without affecting the others — useful for applying changes (e.g., environment variables, mounted config files) to a single service without disrupting the rest of the monitoring stack.

**Note:** For Prometheus specifically, if only the scrape configuration changed (not the compose file itself), a full restart isn't even necessary — a hot reload via `--web.enable-lifecycle` and `curl -X POST http://localhost:9090/-/reload` can be used instead, avoiding any downtime.