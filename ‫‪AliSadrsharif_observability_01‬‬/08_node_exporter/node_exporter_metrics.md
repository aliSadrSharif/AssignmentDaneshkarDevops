# Node Exporter Metrics

## 1. `node_cpu_seconds_total`

### What information does this metric provide?
- `node_cpu_seconds_total` is a **Counter** metric.
- It shows the total number of CPU seconds spent in different CPU modes (such as `user`, `system`, `idle`, `iowait`, `irq`, etc.) since the system started.
- The metric is reported separately for each CPU core and CPU mode.

### How can it be used for monitoring?
- Monitor CPU utilization.
- Detect high system or user CPU usage.
- Identify excessive I/O wait time.
- Calculate CPU usage percentages using the `rate()` function.

---

## 2. `node_memory_MemTotal_bytes`

### What information does this metric provide?
- `node_memory_MemTotal_bytes` is a **Gauge** metric.
- It reports the total physical memory (RAM) installed on the machine in bytes.
- This value usually remains constant unless the hardware configuration changes.

### How can it be used for monitoring?
- Determine the total available system memory.
- Compare with memory usage metrics such as `node_memory_MemAvailable_bytes`.
- Calculate memory utilization percentage.

---

## 3. `node_filesystem_size_bytes`

### What information does this metric provide?
- `node_filesystem_size_bytes` is a **Gauge** metric.
- It reports the total size of each mounted filesystem in bytes.
- A separate metric is available for every mounted device and mount point.

### How can it be used for monitoring?
- Monitor total disk capacity.
- Track storage usage together with `node_filesystem_avail_bytes`.
- Generate alerts when disk space becomes critically low.

---

## 4. `rate(node_cpu_seconds_total[5m])`

### What information does this metric provide?
- This query calculates the average per-second increase of `node_cpu_seconds_total` over the last 5 minutes.
- It represents the CPU activity rate instead of the cumulative CPU time.
- It is commonly used to calculate CPU utilization percentages.

### How can it be used for monitoring?
- Monitor real-time CPU usage.
- Detect sudden CPU spikes.
- Build dashboards showing CPU utilization over time.
- Configure alerts when CPU usage exceeds predefined thresholds.

---

# Other Common Metrics Available in Node Exporter

Some of the most useful Node Exporter metrics include:

| Metric | Description |
|--------|-------------|
| `node_memory_MemAvailable_bytes` | Available system memory. |
| `node_memory_MemFree_bytes` | Free physical memory. |
| `node_load1` | 1-minute system load average. |
| `node_load5` | 5-minute system load average. |
| `node_load15` | 15-minute system load average. |
| `node_filesystem_avail_bytes` | Available disk space. |
| `node_disk_read_bytes_total` | Total bytes read from disks. |
| `node_disk_written_bytes_total` | Total bytes written to disks. |
| `node_network_receive_bytes_total` | Total bytes received over the network. |
| `node_network_transmit_bytes_total` | Total bytes transmitted over the network. |
| `node_boot_time_seconds` | System boot time. |
| `node_uname_info` | Operating system and kernel information. |
| `node_time_seconds` | Current system time. |

These metrics allow administrators to monitor CPU, memory, disk, network, filesystem, and overall system health using Prometheus and Grafana.