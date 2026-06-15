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

# Clean up previous containers and volume
docker_cmd "docker rm -f volume-test volume-test-2 2>/dev/null || true"
docker_cmd "docker volume rm my-data 2>/dev/null || true"

# Create named volume and first container
docker_cmd "docker volume create my-data"
docker_cmd "docker run -d --name volume-test -v my-data:/app/data alpine:latest sleep 3600"

sleep 1

docker_cmd "docker exec volume-test sh -c 'echo \"Hello from container\" > /app/data/test.txt'"
echo "Content of the volume from volume-test1:" > volume_content.txt
docker_cmd "docker exec volume-test cat /app/data/test.txt >> volume_content.txt"
docker_cmd "docker volume inspect my-data > volume_info.txt"
docker_cmd "docker rm -f volume-test"
docker_cmd "docker run -d --name volume-test-2 -v my-data:/app/data alpine:latest sleep 3600"

sleep 1
echo "Content of the volume from volume-test2:" >> volume_content.txt
docker_cmd "docker exec volume-test-2 cat /app/data/test.txt >> volume_content.txt"

echo "volume_operations.sh completed."
