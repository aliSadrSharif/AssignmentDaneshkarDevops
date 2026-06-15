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

# Remove containers if they already exist
docker_cmd "docker rm -f always-restart unless-stopped no-restart 2>/dev/null || true"

# Run containers with different restart policies
docker_cmd "docker run -d --name always-restart --restart always alpine:latest sleep 5"
docker_cmd "docker run -d --name unless-stopped --restart unless-stopped alpine:latest sleep 5"
docker_cmd "docker run -d --name no-restart alpine:latest sleep 5"

sleep 7

# this command didn't work: docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.RestartCount}}" | grep -E 'always-restart|unless-stopped|no-restart' > restart_status.txt

{
    echo "NAMES            STATUS     RESTARTCOUNT"
    for name in always-restart unless-stopped no-restart; do
        docker_cmd "docker inspect -f '{{.Name}}  {{.State.Status}}  RestartCount={{.RestartCount}}' ${name}"
    done
    echo ""
    docker_cmd "docker inspect always-restart | grep -A 2 'RestartPolicy'"
} > restart_status.txt 2>&1

echo "restart_policy_test.sh completed."
