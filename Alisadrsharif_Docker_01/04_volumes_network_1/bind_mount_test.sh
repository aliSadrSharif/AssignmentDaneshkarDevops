#!/bin/bash
set -e

cd "$(dirname "$0")"
WEB_DIR="$(pwd)/web"

# Run docker commands (use sg docker if group is not active in session)
docker_cmd() {
    if groups | grep -q '\bdocker\b'; then
        bash -c "$1"
    else
        sg docker -c "$1"
    fi
}

# Remove container if it already exists
docker_cmd "docker rm -f bind-mount-test 2>/dev/null || true"

# Run container with read-only bind mount
docker_cmd "docker run -d --name bind-mount-test -p 9000:80 -v ${WEB_DIR}:/usr/share/nginx/html:ro nginx:alpine"

sleep 2

curl -s http://localhost:9000 > bind_mount_output.html
echo "File modified on host" >> web/index.html
curl -s http://localhost:9000 > bind_mount_output_modified.html

echo "bind_mount_test.sh completed."
