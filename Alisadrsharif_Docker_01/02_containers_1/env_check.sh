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
docker_cmd "docker rm -f env-test 2>/dev/null || true"

# Run container with environment variables
docker_cmd 'docker run -d --name env-test -e MY_VAR="Hello Docker" -e PORT=8080 alpine:latest sleep 3600'

sleep 1

docker_cmd "docker exec env-test env | grep -E 'MY_VAR|PORT' > env_output.txt"
docker_cmd "docker exec env-test sh -c 'echo \"MY_VAR=\$MY_VAR, PORT=\$PORT\"' >> env_output.txt"

echo "env_check.sh completed."
