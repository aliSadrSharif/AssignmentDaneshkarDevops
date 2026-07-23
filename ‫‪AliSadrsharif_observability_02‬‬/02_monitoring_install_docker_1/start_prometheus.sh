#!/bin/bash
set -e

# Setup docker
echo "Starting Prometheus with Docker..."
docker compose up -d

echo "Waiting for Prometheus to be ready..."
sleep 5

echo "Checking Prometheus status..."
docker ps | grep prometheus

echo "Testing Prometheus endpoint..."
curl -s http://localhost:9090/api/v1/status/config | head -10

{
    echo -e "##### This file contains result of docker run for prometheus #####\n"
    echo -e "### Checking prometheus status ###\n"
    docker ps | grep prometheus
    echo -e "\n### Log prometheus form docker ###\n"
    docker logs prometheus | tail -20
    echo -e "\n### test prometheus endpoint ###\n"
    curl -s http://localhost:9090/api/v1/status/config | jq '.data.yaml' | head -20
    echo -e "\n### Check prometheus volume ###\n"
    docker volume ls | grep prometheus
} > "prometheus_docker_status.txt"