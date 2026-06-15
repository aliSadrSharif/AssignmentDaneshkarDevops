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
docker_cmd "docker rm -f limited-container 2>/dev/null || true"

# Run container with memory and CPU limits
docker_cmd 'docker run -d --name limited-container --memory="128m" --cpus="0.5" alpine:latest sleep 3600'

sleep 2

{
    docker_cmd "docker stats --no-stream limited-container"
    echo ""
    docker_cmd "docker inspect limited-container | grep -A 5 'Memory\|CpuShares'"
} > resource_stats.txt 2>&1

echo "resource_check.sh completed."
