#!/bin/bash
set -e

# Setup docker
echo "Starting monitoring stack..."
docker compose up -d

# Wait long enough for the first scrape (scrape_interval is 15s) so that the
# targets API and the up metric report real values for every target.
echo "Waiting for services to be ready..."
sleep 20

echo "Checking services status..."
docker compose ps

echo "Testing Prometheus..."
curl -s http://localhost:9090/api/v1/status/config | jq '.status' || echo "Prometheus not ready"

echo "Testing Grafana..."
curl -s http://localhost:3000/api/health | jq || echo "Grafana not ready"

echo "Testing Node Exporter..."
curl -s http://localhost:9100/metrics | head -20

echo "Checking scrape targets..."
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, instance: .labels.instance, health: .health}'

{
    echo -e "##### This file contains result of docker compose for monitoring stacks #####\n"
    echo -e "### Checking docker compose status ###\n"
    docker compose ps
    echo -e "\n### Check network for monitoring ###\n"
    docker network ls | grep monitoring
    echo -e "\n### Check volume for monitoring ###\n"
    docker volume ls | grep -E "prometheus|grafana"
    echo -e "\n### test prometheus endpoint ###\n"
    curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, instance: .labels.instance, health: .health}'
    echo -e "\n### Check up metric for every target ###\n"
    curl -s 'http://localhost:9090/api/v1/query?query=up' | jq '.data.result[] | {job: .metric.job, instance: .metric.instance, up: .value[1]}'
} > "stack_status.txt"