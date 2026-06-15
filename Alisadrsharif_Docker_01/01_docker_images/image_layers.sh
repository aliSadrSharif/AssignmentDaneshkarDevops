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

docker_cmd "docker history nginx:alpine --no-trunc > image_history.txt"
docker_cmd "docker inspect nginx:alpine | grep -A 10 'RootFS' > image_rootfs.txt"
docker_cmd "docker image inspect nginx:alpine --format '{{.Size}}' > image_size_bytes.txt"

echo "Layer inspection files created."
