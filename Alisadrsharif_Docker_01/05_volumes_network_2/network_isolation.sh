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

# Clean up previous containers and networks
docker_cmd "docker rm -f container-a container-b 2>/dev/null || true"
docker_cmd "docker network rm network-a network-b 2>/dev/null || true"

# Create separate networks and containers
docker_cmd "docker network create network-a"
docker_cmd "docker network create network-b"
docker_cmd "docker run -d --name container-a --network network-a alpine:latest sleep 3600"
docker_cmd "docker run -d --name container-b --network network-b alpine:latest sleep 3600"

sleep 2

docker_cmd "docker exec container-a ping -c 2 container-b 2>&1 > isolation_test.txt || echo 'Ping failed as expected' >> isolation_test.txt"
docker_cmd "docker network connect network-a container-b"
docker_cmd "docker exec container-a ping -c 2 container-b >> isolation_test.txt"
docker_cmd "docker network inspect network-a | grep -A 5 'Containers' > network_a_containers.txt"
docker_cmd "docker network inspect bridge | grep -A 10 'IPAM' > bridge_network_info.txt"

echo "network_isolation.sh completed."
