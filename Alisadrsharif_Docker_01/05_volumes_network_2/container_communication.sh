#!/bin/bash
set -e

cd "$(dirname "$0")"

# Run docker commands (use sg docker if group is not active in session)
docker_cmd() {
    if groups | grep -q '\bdocker\b'; then
        bash -c "$1"
    else
        sg docker -c "$1"
    fi
}

# Ensure my-network exists (from Q5.1)
docker_cmd "docker network inspect my-network >/dev/null 2>&1 || docker network create my-network"

# Remove previous db/client containers if they exist
docker_cmd "docker rm -f db client 2>/dev/null || true"

# Run database and client containers on the same network
docker_cmd "docker run -d --name db --network my-network -e MYSQL_ROOT_PASSWORD=test123 mysql:8.0"
docker_cmd "docker run -d --name client --network my-network alpine:latest sleep 3600"

sleep 10

docker_cmd "docker exec client ping -c 2 db > db_connectivity.txt"
docker_cmd "docker exec client nslookup db >> db_connectivity.txt"

{
    docker_cmd "docker network ls"
    echo ""
    docker_cmd "docker network inspect bridge | grep -A 10 'Containers'"
} > all_networks.txt 2>&1

echo "container_communication.sh completed."
