# Metrics, Logs, Traces, Alerting, and SLO/SLI/SLA

## 1. Metrics: What are Metrics and what types do they have?

**Metrics** are numerical values collected over time to measure the health, performance, and behavior of a system. They are commonly used for monitoring, alerting, and capacity planning.

### Common Metric Types

### Counter
- A Counter only increases (or resets after a restart).
- It is used to count events.
- Example:
  - Total HTTP requests
  - Number of failed login attempts

### Gauge
- A Gauge represents the current value of something.
- It can increase or decrease.
- Example:
  - CPU usage (%)
  - Memory usage
  - Number of active users

### Histogram
- A Histogram measures the distribution of values by grouping them into buckets.
- It helps analyze response times or request sizes.
- Example:
  - API response time distribution
  - File upload sizes

### Summary
- A Summary calculates statistics such as percentiles, average, and total count.
- It is useful for measuring latency and performance.
- Example:
  - 95th percentile API response time
  - Average database query duration

---

## 2. Logs: What is the difference between Structured and Unstructured Logs?

### Structured Logs
- Stored in a consistent format such as JSON.
- Easy for machines to parse and search.
- Suitable for centralized logging systems like ELK or Loki.

**Example**
```json
{
  "timestamp": "2026-07-19T10:00:00Z",
  "level": "ERROR",
  "service": "payment-service",
  "message": "Payment failed",
  "userId": 1234
}
```

### Unstructured Logs
- Plain text without a fixed format.
- Easy for humans to read but difficult for automated analysis.

**Example**
```text
ERROR: Payment failed for user 1234 at 10:00 AM
```

### Comparison

| Structured Logs | Unstructured Logs |
|-----------------|-------------------|
| Machine-readable | Human-readable |
| Easy to filter and search | Difficult to query |
| Fixed format (JSON, XML, etc.) | Plain text |
| Best for automated monitoring | Best for simple debugging |

---

## 3. Traces: What is Distributed Tracing and when is it used?

**Distributed Tracing** records the complete path of a request as it travels through multiple services in a distributed system.

It shows:
- Which services handled the request
- How long each service took
- Where failures or delays occurred

### When is it used?
Distributed tracing is useful in:
- Microservices architectures
- Cloud-native applications
- Service-oriented systems
- Applications with multiple APIs and databases

### Example
A customer places an online order:

```
Client
   ↓
API Gateway
   ↓
Order Service
   ↓
Payment Service
   ↓
Inventory Service
   ↓
Notification Service
```

A trace records the time spent in each service, making it easy to identify bottlenecks or failures.

---

## 4. Alerting: What is the difference between an Alert and a Notification?

### Alert
- Indicates that a predefined condition has been violated.
- Requires investigation or action.
- Usually triggered by monitoring rules.

**Example**
- CPU usage exceeds 90% for 10 minutes.

### Notification
- A message sent to inform users about an event.
- Does not necessarily require immediate action.

**Example**
- Daily backup completed successfully.
- Deployment finished successfully.

### Comparison

| Alert | Notification |
|--------|--------------|
| Indicates a problem | Shares information |
| Usually requires action | Usually informational |
| Triggered by alert rules | Triggered by any event |
| High priority | Normal priority |

---

# 5. SLO, SLI, and SLA

## SLI (Service Level Indicator)

An **SLI** is a measurable metric that reflects the performance or reliability of a service.

### Example
- API availability
- Request latency
- Error rate

**Real-world example:**
An online store measures that **99.8%** of customer requests are successful.

---

## SLO (Service Level Objective)

An **SLO** is the target value for an SLI.

It defines the expected level of service quality.

### Example
- Service availability must be at least **99.9%** each month.
- API response time should be below **300 ms** for 95% of requests.

**Real-world example:**
A company sets an objective that its website should remain available **99.9%** of the time every month.

---

## SLA (Service Level Agreement)

An **SLA** is a formal agreement between a service provider and its customers.

It defines:
- Expected service quality
- Responsibilities
- Compensation if objectives are not met

### Example
A cloud provider promises **99.95% uptime** each month. If availability drops below this value, customers receive service credits.

**Real-world example:**
A hosting company guarantees 99.95% uptime in its customer contract.

---

## Relationship between SLI, SLO, and SLA

```
SLI → Measures actual performance
        ↓
SLO → Defines the target performance
        ↓
SLA → Legal agreement based on the SLO
```

### Practical Example

Suppose an online banking system:

- **SLI:** Current uptime = 99.92%
- **SLO:** Target uptime = 99.90%
- **SLA:** The bank guarantees 99.90% uptime to customers. If uptime falls below this value, customers receive compensation.

In simple terms:

- **SLI** measures the service.
- **SLO** sets the goal.
- **SLA** is the customer-facing agreement based on that goal.