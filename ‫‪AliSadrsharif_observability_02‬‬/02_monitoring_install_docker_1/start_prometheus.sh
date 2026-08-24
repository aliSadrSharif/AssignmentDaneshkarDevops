#!/bin/bash
set -e

# Setup docker
echo "Starting Prometheus with Docker..."
docker compose up -d

# Wait long enough for the first scrape (scrape_interval is 15s) so that the
# targets API and the up metric report real values.
echo "Waiting for Prometheus to be ready..."
sleep 20

echo "Checking Prometheus status..."
docker ps | grep prometheus

echo "Testing Prometheus endpoint..."
curl -s http://localhost:9090/api/v1/status/config | head -10

echo "Checking scrape target health..."
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, instance: .labels.instance, health: .health}'

{
    echo -e "##### This file contains result of docker run for prometheus #####\n"
    echo -e "### Checking prometheus status ###\n"
    docker ps | grep prometheus
    echo -e "\n### Log prometheus form docker ###\n"
    docker logs prometheus 2>&1 | tail -20
    echo -e "\n### test prometheus endpoint ###\n"
    curl -s http://localhost:9090/api/v1/status/config | jq '.data.yaml' | head -20
    echo -e "\n### Check scrape target health ###\n"
    curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, instance: .labels.instance, health: .health}'
    echo -e "\n### Check up metric ###\n"
    curl -s 'http://localhost:9090/api/v1/query?query=up' | jq '.data.result[] | {job: .metric.job, instance: .metric.instance, up: .value[1]}'
    echo -e "\n### Check prometheus volume ###\n"
    docker volume ls | grep prometheus
} > "prometheus_docker_status.txt"