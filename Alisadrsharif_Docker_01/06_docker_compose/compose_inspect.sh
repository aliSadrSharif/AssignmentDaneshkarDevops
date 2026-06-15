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

compose_cmd "docker-compose up -d"
sleep 5
compose_cmd "docker-compose exec -T web ping -c 2 app > service_communication.txt"
compose_cmd "docker network ls | grep docker_compose > compose_networks.txt"
compose_cmd "docker volume ls | grep docker_compose > compose_volumes.txt"
compose_cmd "docker-compose down -v"

echo "compose_inspect.sh completed."
