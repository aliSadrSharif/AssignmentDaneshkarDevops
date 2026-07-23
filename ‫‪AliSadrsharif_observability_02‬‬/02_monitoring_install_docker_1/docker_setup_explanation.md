# Docker Setup Explanation — Prometheus with Docker

## 1. Why do we use Docker to install Prometheus?

Using Docker to install Prometheus offers several advantages:
- **Consistency**: The same image runs identically across any machine (dev, staging, production), avoiding "it works on my machine" issues.
- **Isolation**: Prometheus runs in its own container, isolated from the host system and other services, avoiding dependency conflicts.
- **Easy version management**: Switching Prometheus versions is as simple as changing the image tag.
- **Fast setup and teardown**: No manual installation of binaries or dependencies — a single `docker-compose up` gets it running.
- **Portability**: The same `docker-compose.yml` and config files can be shared and reproduced by anyone, exactly as intended by this assignment ("build exactly the same thing").
- **Simplified networking**: Docker Compose makes it easy to connect Prometheus with other services (Grafana, exporters, etc.) on the same network.

## 2. What role does the `prometheus_data` volume play?

The `prometheus_data` volume provides **persistent storage** for Prometheus's time-series database (TSDB). Without it, all collected metrics data would be stored inside the container's writable layer and would be **permanently lost** whenever the container is removed or recreated.

By mounting `prometheus_data:/prometheus`, the actual TSDB files are stored in a Docker-managed volume that exists independently of the container's lifecycle. This means:
- Metrics history survives container restarts, updates, or recreation.
- Data can be backed up or inspected separately from the container.

## 3. What does the `--web.enable-lifecycle` flag do?

This flag enables lifecycle management endpoints on the Prometheus HTTP API, specifically:
- `POST /-/reload` — reloads the Prometheus configuration without restarting the process
- `POST /-/quit` — allows Prometheus to be shut down gracefully via an API call

By default, these endpoints are disabled for safety. Enabling `--web.enable-lifecycle` allows Prometheus's configuration to be reloaded dynamically (e.g., after editing `prometheus.yml`) without needing to restart or recreate the container.

## 4. How can Prometheus's configuration be reloaded without restarting the container?

With `--web.enable-lifecycle` enabled, you can trigger a **hot reload** of the configuration by sending an HTTP POST request to the reload endpoint:

```bash
curl -X POST http://localhost:9090/-/reload
```

This causes Prometheus to re-read `prometheus.yml` (and any referenced rule files) and apply the changes immediately — without stopping the container, losing in-memory state, or interrupting metric collection.

**Note:** If the configuration file has a syntax error, Prometheus will reject the reload and keep running with the previous valid configuration, which can be verified by checking the logs:
```bash
docker logs prometheus | tail -20
```
