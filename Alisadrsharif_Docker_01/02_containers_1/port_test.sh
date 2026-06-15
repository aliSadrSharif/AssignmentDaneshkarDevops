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

HOST_PORT=8888

# Remove container if it already exists
docker_cmd "docker rm -f web-server 2>/dev/null || true"

# Run container with port mapping
docker_cmd "docker run -d --name web-server -p ${HOST_PORT}:80 nginx:alpine"

sleep 2

{
    curl -I "http://localhost:${HOST_PORT}"
    echo ""
    docker_cmd "docker port web-server"
    echo ""
    ss -tuln | grep "${HOST_PORT}" || true
} > port_mapping_test.txt 2>&1

echo "port_test.sh completed (host port: ${HOST_PORT})."
