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

# Remove container if it already exists
docker_cmd "docker rm -f test-nginx 2>/dev/null || true"

# Run a simple container
docker_cmd "docker run -d --name test-nginx nginx:alpine"
sleep 2
docker_cmd "docker ps | grep test-nginx"
docker_cmd "docker logs test-nginx | head -n 10 > nginx_logs.txt"
docker_cmd "docker stop test-nginx"
docker_cmd "docker ps -a | grep test-nginx"

# Save container state after stop
docker_cmd "docker inspect test-nginx | grep -A 3 'State' > container_state.txt"

echo "container_basics.sh completed."
