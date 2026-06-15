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

{
    echo "=== docker pull nginx:alpine ==="
    docker_cmd "docker pull nginx:alpine"
    echo ""
    echo "=== docker images | grep nginx ==="
    docker_cmd "docker images | grep nginx"
    echo ""
    echo "=== docker tag nginx:alpine my-nginx:v1.0 ==="
    docker_cmd "docker tag nginx:alpine my-nginx:v1.0"
    echo ""
    echo "=== docker images | grep -E 'nginx|my-nginx' ==="
    docker_cmd "docker images | grep -E 'nginx|my-nginx'"
    echo ""
    echo "=== docker inspect nginx:alpine | grep -A 5 Architecture ==="
    docker_cmd "docker inspect nginx:alpine | grep -A 5 'Architecture'"
    echo ""
    echo "=== docker rmi my-nginx:v1.0 ==="
    docker_cmd "docker rmi my-nginx:v1.0"
    echo ""
    echo "=== docker images | grep -E 'nginx|my-nginx' (after rmi) ==="
    docker_cmd "docker images | grep -E 'nginx|my-nginx' || true"
} > image_operations.txt 2>&1

echo "image_operations.txt created."
