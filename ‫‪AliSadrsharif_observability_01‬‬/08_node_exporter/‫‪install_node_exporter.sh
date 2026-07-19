#!/bin/bash
set -e

# user node_exporter
sudo useradd --no-create-home --shell /bin/false node_exporter

# Download node exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar xvf node_exporter-1.6.1.linux-amd64.tar.gz
cd node_exporter-1.6.1.linux-amd64/

# Copy binary
sudo cp node_exporter /usr/local/bin/
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create system service
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Check status service
sudo systemctl status node_exporter --no-pager | head -20

{
    echo -e "### node exporter version ###\n"
    node_exporter --version
    echo -e "\n### node exporter service status ###\n"
    sudo systemctl status node_exporter --no-pager
    echo -e "\n### node exporter response ###\n"
    curl -s http://localhost:9100/metrics | head -50
} > "node_exporter_status.txt"