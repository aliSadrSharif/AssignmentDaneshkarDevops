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

# Clean up previous containers and network
docker_cmd "docker rm -f container1 container2 2>/dev/null || true"
docker_cmd "docker network rm my-network 2>/dev/null || true"

# Create custom network and connect two containers
docker_cmd "docker network create my-network"
docker_cmd "docker run -d --name container1 --network my-network alpine:latest sleep 3600"
docker_cmd "docker run -d --name container2 --network my-network alpine:latest sleep 3600"

sleep 2

docker_cmd "docker network inspect my-network > network_info.txt"
docker_cmd "docker exec container1 ping -c 3 container2 > ping_test.txt"
docker_cmd "docker exec container1 nslookup container2 >> ping_test.txt"

echo "network_operations.sh completed."
