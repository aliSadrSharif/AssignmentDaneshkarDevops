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
docker_cmd "docker rm -f log-test 2>/dev/null || true"

# Run container that writes multiple log lines
docker_cmd "docker run -d --name log-test alpine:latest sh -c 'for i in \$(seq 1 10); do echo \"Log line \$i\"; sleep 1; done; sleep 3600'"

sleep 12

docker_cmd "docker logs log-test > all_logs.txt"
docker_cmd "docker logs --tail 5 log-test > last_5_logs.txt"
docker_cmd "docker logs --since 5s log-test > recent_logs.txt"

echo "log_operations.sh completed."
