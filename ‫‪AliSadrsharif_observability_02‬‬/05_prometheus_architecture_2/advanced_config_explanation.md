# Advanced Configuration Explanation

## 1. What role does `external_labels` play?

`external_labels` are labels defined once under the `global:` section of `prometheus.yml`, and they get **attached to every time series and every alert** sent from this Prometheus instance — not just to a specific job or target.

```yaml
global:
  external_labels:
    cluster: 'production'
    environment: 'dev'
```

**Purpose:**
- Identifies which Prometheus server/cluster/environment a given metric or alert originated from — especially important when running multiple Prometheus instances (e.g., one per cluster or region).
- Used by Alertmanager and federation/remote-write setups to distinguish data coming from different Prometheus servers.
- Unlike `relabel_configs`, these are added at query/storage time to *all* series globally, not conditionally per target.

## 2. How does `relabel_configs` work?

`relabel_configs` runs **before scraping** and operates on the metadata of *discovered targets* (their labels, especially `__address__` and any `__meta_*` labels from service discovery). It allows Prometheus to rewrite, add, drop, or filter labels — and even decide whether to scrape a target at all — before any actual scrape happens.

```yaml
relabel_configs:
  - source_labels: [__address__]
    target_label: instance
    replacement: 'node-1'
```

**How it works step by step:**
1. `source_labels` specifies which existing label(s) to read from (here, `__address__`, the discovered host:port).
2. `target_label` specifies which label to write the result into (here, `instance`).
3. `replacement` defines the value to assign (can be a literal string or use regex capture groups like `$1`).
4. The `action` field (default `replace`) determines the operation — common actions include `replace`, `keep`, `drop`, `labelmap`, and `labeldrop`.

This is commonly used to clean up auto-discovered metadata (e.g., from Kubernetes or Consul) into more meaningful, human-readable labels, or to filter out targets that shouldn't be scraped.

## 3. How is `file_sd_configs` used for Service Discovery?

`file_sd_configs` tells Prometheus to read its list of scrape targets from one or more external JSON/YAML files, and to **periodically re-read** those files to pick up changes.

```yaml
- job_name: 'file_sd'
  file_sd_configs:
    - files:
        - '/etc/prometheus/targets/*.json'
      refresh_interval: 30s
```

**How it works:**
- `files` specifies a path (or glob pattern) pointing to one or more target definition files.
- Each file contains a JSON array of target groups, each with a `targets` list and optional `labels`:
  ```json
  [
    {
      "targets": ["app1:8080", "app2:8080"],
      "labels": {
        "service": "webapp",
        "environment": "production"
      }
    }
  ]
  ```
- `refresh_interval` controls how often Prometheus checks the file(s) for changes (here, every 30 seconds).
- This is a good middle ground between fully static configuration and full dynamic SD (like Kubernetes SD) — external scripts, configuration management tools, or automation pipelines can regenerate these files whenever the target list changes, without needing to touch or reload `prometheus.yml` itself.

## 4. What is the difference between `scrape_interval` in `global` vs in a `job`?

- **Global `scrape_interval`** (under `global:`) sets the **default** scrape interval applied to every job in the configuration that doesn't explicitly override it.
- **Per-job `scrape_interval`** (set inside a specific `scrape_configs` entry) **overrides** the global default for that job only.

```yaml
global:
  scrape_interval: 15s     # default for all jobs

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
    # no override -> uses global 15s

  - job_name: 'node_exporter'
    scrape_interval: 10s   # overrides global; this job scrapes every 10s
    static_configs:
      - targets: ['node_exporter:9100']
```

This allows fine-tuning: critical or fast-changing targets (like `node_exporter` in this example) can be scraped more frequently, while less critical or slower-changing targets can use the standard global interval — balancing monitoring granularity against resource and storage overhead on a per-job basis.