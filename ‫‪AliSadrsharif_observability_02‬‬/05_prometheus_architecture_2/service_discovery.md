# Service Discovery

## 1. What is Static Configuration and when is it used?

Static Configuration means manually listing scrape targets directly in `prometheus.yml` under `static_configs`, with a fixed list of host:port addresses.

```yaml
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

**When it's used:**
- Small, stable environments where targets rarely change (e.g., a handful of fixed servers).
- Local development, testing, or learning setups.
- Monitoring the Prometheus server itself, or a small number of long-lived, well-known services.

Its main drawback is that it doesn't scale well — every time a target is added, removed, or its address changes, the configuration file must be manually edited and reloaded.

## 2. What is Service Discovery and what advantages does it offer?

Service Discovery (SD) allows Prometheus to **automatically find and update its list of scrape targets** dynamically, instead of relying on a static, manually maintained list.

**Advantages:**
- **Scalability**: Works well in environments with many targets or targets that change frequently (containers, microservices, autoscaling groups).
- **Automation**: No manual editing of `prometheus.yml` needed when instances are added or removed.
- **Reduced human error**: Eliminates the risk of forgetting to add/remove a target manually.
- **Better fit for dynamic infrastructure**: Essential in environments like Kubernetes or cloud auto-scaling groups where instances are ephemeral.
- **Integration with existing systems**: Prometheus can discover targets from the same source of truth used elsewhere (Kubernetes API, cloud provider APIs, DNS, Consul, etc.).

## 3. Types of Service Discovery

### File-based Service Discovery
Targets are defined in external JSON or YAML files that Prometheus periodically re-reads (based on `refresh_interval`). Useful when target information is generated or updated by an external script, configuration management tool, or custom automation — without needing to touch `prometheus.yml` itself.

```yaml
- job_name: 'file_sd'
  file_sd_configs:
    - files:
        - '/etc/prometheus/targets/*.json'
      refresh_interval: 30s
```

### DNS-based Service Discovery
Prometheus resolves a DNS name (A, AAAA, or SRV record) to get a list of target addresses. Useful in environments where services register themselves in DNS (e.g., via Consul DNS interface or a custom DNS-based service registry), and the list of instances changes as DNS records are updated.

```yaml
- job_name: 'dns_sd'
  dns_sd_configs:
    - names:
        - 'my-service.example.com'
      type: 'A'
      port: 9100
```

Other common SD mechanisms (not required here but worth mentioning) include Kubernetes SD, Consul SD, EC2 SD, and Azure SD — each tailored to a specific platform's API.

## 4. What is Relabeling and what is it used for?

Relabeling is the process of **modifying, adding, or filtering labels** on discovered targets or scraped metrics *before* they are stored (or even before a target is scraped, in the case of target relabeling).

**Common uses:**
- Renaming or rewriting labels (e.g., converting `__address__` into a custom `instance` label).
- Filtering out unwanted targets entirely (`action: drop`) based on a label pattern.
- Adding static metadata labels to targets discovered dynamically (e.g., tagging targets by environment or team).
- Extracting values from Kubernetes/Consul metadata labels (which are prefixed with `__meta_`) into regular, queryable labels.

Example:
```yaml
relabel_configs:
  - source_labels: [__address__]
    target_label: instance
    replacement: 'node-1'
```
This takes the discovered `__address__` value and sets it as a custom `instance` label with a fixed replacement value.

## 5. How is Scrape Interval configured and what effect does it have?

`scrape_interval` defines **how often Prometheus scrapes a given target** for new metric data. It can be set:
- **Globally**, under the `global:` section, applying as the default for all jobs.
- **Per-job**, inside a specific `scrape_configs` entry, overriding the global default for that job only.

```yaml
global:
  scrape_interval: 15s     # default for all jobs

scrape_configs:
  - job_name: 'node_exporter'
    scrape_interval: 10s   # overrides the global default for this job
```

**Effects of the interval:**
- **Shorter interval** (e.g., 5s–10s): More granular, higher-resolution data; faster detection of issues; but higher CPU, memory, storage, and network usage — and higher load on scraped targets.
- **Longer interval** (e.g., 60s+): Less storage and resource usage, but coarser data resolution, slower alert reaction time, and the possibility of missing short-lived spikes between scrapes.

The right interval is a trade-off between monitoring granularity and system/storage overhead, and can be tuned per job depending on how critical or volatile that target's metrics are.