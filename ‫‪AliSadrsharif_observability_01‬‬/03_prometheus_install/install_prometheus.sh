#!/bin/bash
set -e

# Create prometheus user
sudo useradd --no-create-home --shell /bin/false prometheus

# Making required directory
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

# Download LTS prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.45.0/prometheus-2.45.0.linux-amd64.tar.gz
tar xvf prometheus-2.45.0.linux-amd64.tar.gz
cd prometheus-2.45.0.linux-amd64/

# Copy binary files
sudo cp prometheus promtool /usr/local/bin/
sudo cp -r consoles/ console_libraries/ /etc/prometheus/

# change ownership
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

# Checking version
prometheus --version > /tmp/prometheus_version.txt
cat /tmp/prometheus_version.txt

{
echo "***** This file contains information about prometheus status *****"
which prometheus
echo ""
prometheus --version
echo ""
ls -la /etc/prometheus/
echo ""
ls -la /var/lib/prometheus/
} > "prometheus_status.txt"