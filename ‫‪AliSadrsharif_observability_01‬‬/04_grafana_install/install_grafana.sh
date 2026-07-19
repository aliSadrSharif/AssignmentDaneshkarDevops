#!/bin/bash
set -e

# Add GPG key
wget -qO- https://apt.grafana.com/gpg.key \
| gpg --dearmor \
| sudo tee /etc/apt/keyrings/grafana.gpg >/dev/null

echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
| sudo tee /etc/apt/sources.list.d/grafana.list

# Install grafana
sudo apt-get update
sudo apt-get install -y grafana

# Setup grafana service
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Check status service
sudo systemctl status grafana-server --no-pager | head -20

{
    echo "##### This file has info of following details #####"
    echo ""
    echo "### Grafana version ###"
    echo ""
    grafana -v
    echo "### Grafana service directories ###"
    echo ""
    which grafana-server
    echo "### Grafana service status ###"
    echo ""
    systemctl status grafana-server --no-pager
    echo "### Grafana response ###"
    echo ""
    curl -s http://localhost:3000/api/health
} > "grafana_status.txt"

{
    echo "### Grafana api org ###"
    echo ""
    curl -u admin:admin http://localhost:3000/api/org
    echo ""
    echo "### Grafana api datasources ###"
    echo ""
    curl -u admin:admin http://localhost:3000/api/datasources
} > "grafana_api_info.txt"