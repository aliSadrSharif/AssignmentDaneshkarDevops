# Prometheus and Grafana Integration

## 1. Why should we connect Prometheus to Grafana?

Grafana is a visualization platform, while Prometheus is a monitoring system that collects and stores metrics. Grafana needs a data source to display graphs and dashboards, and Prometheus is one of the most commonly used data sources.

Connecting Prometheus to Grafana provides the following benefits:

- Visualize Prometheus metrics using charts and dashboards.
- Create real-time monitoring dashboards.
- Use PromQL (Prometheus Query Language) to query metrics.
- Configure alerts based on collected metrics.
- Monitor servers, containers, Kubernetes clusters, and applications from a single interface.
- Build customizable dashboards for infrastructure and application performance.

Without a data source such as Prometheus, Grafana cannot display monitoring data.

---

## 2. What settings are important when configuring a Data Source?

When adding Prometheus as a data source in Grafana, the following settings are important:

### Name
A descriptive name used to identify the data source (e.g., **Prometheus**).

### URL
The address where the Prometheus server is running.

Example:

```
http://localhost:9090
```

or

```
http://<server-ip>:9090
```

### Access
Specifies how Grafana connects to the data source.

Common options:
- **Server (Proxy)** – Grafana connects to Prometheus from the server side (recommended).
- **Browser (Direct)** – The user's browser connects directly to Prometheus.

### Authentication
Configure authentication if the Prometheus server requires credentials, API keys, or tokens.

### HTTP Settings
Optional settings such as:
- Custom headers
- TLS/SSL configuration
- Timeout values

### Save & Test
After entering the configuration, click **Save & Test** to verify that Grafana can successfully communicate with Prometheus.

---

## 3. What does the message "Data source is working" mean?

The message **"Data source is working"** indicates that Grafana has successfully connected to the configured data source.

This means:

- The data source URL is correct.
- The Prometheus server is reachable.
- Grafana can send queries to Prometheus.
- Prometheus is responding correctly.
- The data source configuration has been validated successfully.

Receiving this message confirms that the data source is ready to be used in dashboards, panels, and queries. It does **not** necessarily mean that metrics are already available; it only verifies that the connection between Grafana and the data source is functioning correctly.