# Explanation of 5 Prometheus Metrics

## 1. `go_gc_duration_seconds`

### Metric Name
`go_gc_duration_seconds`

### Metric Type
**Summary**

### What Information Does It Provide?
This metric measures the duration of Go's garbage collection (GC) pauses. It provides quantiles (minimum, median, maximum, etc.), the total GC pause time, and the number of GC cycles.

### How Can It Be Used?
- Monitor garbage collection performance.
- Detect long GC pauses that may affect application response time.
- Analyze memory management efficiency over time.

---

## 2. `go_goroutines`

### Metric Name
`go_goroutines`

### Metric Type
**Gauge**

### What Information Does It Provide?
This metric shows the current number of active goroutines running in the Go application.

### How Can It Be Used?
- Monitor application concurrency.
- Detect goroutine leaks.
- Identify abnormal increases that may indicate performance or resource issues.

---

## 3. `go_memstats_alloc_bytes`

### Metric Name
`go_memstats_alloc_bytes`

### Metric Type
**Gauge**

### What Information Does It Provide?
This metric shows the amount of memory (in bytes) currently allocated and still in use by the application.

### How Can It Be Used?
- Monitor current memory usage.
- Detect memory leaks.
- Observe memory consumption trends during application execution.

---

## 4. `go_memstats_alloc_bytes_total`

### Metric Name
`go_memstats_alloc_bytes_total`

### Metric Type
**Counter**

### What Information Does It Provide?
This metric shows the total number of bytes allocated since the application started, including memory that has already been freed.

### How Can It Be Used?
- Measure the total memory allocation rate.
- Analyze allocation patterns over time.
- Detect excessive memory allocation that may reduce performance.

---

## 5. `go_memstats_frees_total`

### Metric Name
`go_memstats_frees_total`

### Metric Type
**Counter**

### What Information Does It Provide?
This metric shows the total number of memory objects that have been freed by the Go runtime since the application started.

### How Can It Be Used?
- Monitor memory deallocation activity.
- Compare allocation and free rates.
- Analyze the effectiveness of garbage collection and memory management.