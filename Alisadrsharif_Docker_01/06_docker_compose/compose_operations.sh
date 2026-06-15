#!/bin/bash
set -e

cd "$(dirname "$0")"

# Run docker-compose commands (use sg docker if group is not active in session)
compose_cmd() {
    if groups | grep -q '\bdocker\b'; then
        bash -c "$1"
    else
        sg docker -c "$1"
    fi
}

compose_cmd "docker-compose down 2>/dev/null || true"
compose_cmd "docker-compose up -d"
sleep 5
compose_cmd "docker-compose ps > compose_status.txt"
compose_cmd "docker-compose logs web | head -n 10 > web_logs.txt"
curl -s http://localhost:8080 > web_response.html
compose_cmd "docker-compose down"

echo "compose_operations.sh completed."
