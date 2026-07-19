#!/bin/bash

# Copy files
sudo cp prometheus.yml /etc/prometheus
sudo cp prometheus.service /etc/systemd/system/

# Enable service
sudo systemctl restart prometheus
sudo systemctl status prometheus

{
    echo -e "##### This file containes info about prometheus #####\n"
    echo -e "### Status service prometheus ###\n"
    systemctl status prometheus --no-pager
    echo ""
    echo -e "### Checking prometheus response ###\n"
    curl -s http://localhost:9090/api/v1/status/config | head -20
} > "prometheus_setup_output.txt"