#!/bin/bash

# Copy files
sudo cp prometheus.yml /etc/prometheus

# Enable service
sudo systemctl restart prometheus
sudo systemctl status prometheus

{
    echo -e "### Status targets ###\n"
    curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .job, health: .health, lastScrape: .lastScrape}'
} > "prometheus_targets.txt"