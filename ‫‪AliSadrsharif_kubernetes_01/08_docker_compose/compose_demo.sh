#!/bin/bash
set -e

cd "$(dirname "$0")"

# Stop and remove containers
docker compose down -v 2>/dev/null || docker-compose down -v 2>/dev/null || true

# Start containers
docker compose up -d 2>&1 | tee compose_up.txt || docker-compose up -d 2>&1 | tee compose_up.txt

sleep 4

docker compose ps > compose_ps.txt 2>&1 || docker-compose ps > compose_ps.txt

# Check web service
curl -s http://localhost:8088 | head -n 5 > compose_web.txt

# Check network connectivity
docker compose exec web ping -c 2 api > compose_ping.txt 2>&1 \
  || docker-compose exec web ping -c 2 api > compose_ping.txt

# Check networks
docker network ls > compose_networks.txt

docker compose down 2>&1 | tee compose_down.txt || docker-compose down 2>&1 | tee compose_down.txt
