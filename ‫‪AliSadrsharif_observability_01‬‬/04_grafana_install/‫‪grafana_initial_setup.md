# Grafana UI Questions

## 1. What pages can you see in the Grafana UI?

- **Home** – The welcome page with Grafana tutorials and getting started guides.
- **Bookmarks** – Stores bookmarked dashboards and resources.
- **Starred** – Displays dashboards marked as favorites.
- **Dashboards** – Used to create, organize, import, and manage dashboards.
- **Explore** – Allows users to query and analyze data interactively without creating a dashboard.
- **Drilldown** – Used to navigate from high-level metrics to more detailed information.
- **Alerting** – Configure and manage alert rules, notification policies, and contact points.
- **Connections** – Add and manage data sources and integrations (such as Prometheus, Loki, MySQL, PostgreSQL, etc.).
- **Administration** – Manage users, organizations, authentication, plugins, and other Grafana settings.

The Home page also displays quick links for:
- Grafana documentation
- Tutorials
- Community
- Creating a dashboard
- Adding a data source

---

## 2. What is the difference between a Dashboard, Panel, and Data Source?

### Dashboard
A **Dashboard** is a collection of visualizations that displays monitoring data in one place. It helps users monitor applications, servers, databases, and infrastructure through multiple charts and graphs.

Example:
A "Server Monitoring" dashboard may include CPU usage, memory usage, disk usage, and network traffic.

### Panel
A **Panel** is a single visualization inside a dashboard. Each panel displays one specific metric or query result.

Examples of panels:
- Time series graph
- Gauge
- Stat
- Table
- Heatmap
- Pie chart

A dashboard usually contains multiple panels.

### Data Source
A **Data Source** is the system where Grafana retrieves monitoring data. Grafana does not store metrics itself; instead, it queries external systems.

Common data sources include:
- Prometheus
- Loki
- Elasticsearch
- InfluxDB
- MySQL
- PostgreSQL
- Graphite

### Relationship

```
Data Source
      │
      ▼
    Panel(s)
      │
      ▼
   Dashboard
```

The data source provides data, panels visualize the data, and dashboards organize multiple panels into a single monitoring view.

---

## 3. Why should the default password be changed?

The default Grafana administrator password should be changed immediately after installation for security reasons.

Reasons include:

- **Prevent unauthorized access:** The default credentials are publicly known (`admin/admin`) and can be easily guessed.
- **Protect monitoring data:** Dashboards may contain sensitive infrastructure, application, and business information.
- **Reduce security risks:** Attackers often scan servers for applications using default credentials.
- **Follow security best practices:** Changing default passwords is a standard requirement for production environments and security compliance.
- **Protect administrative functions:** The administrator account can create users, modify dashboards, configure data sources, and change system settings.

Changing the default password is one of the first steps in securing a Grafana installation.