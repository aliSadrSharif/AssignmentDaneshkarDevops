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
docker_cmd "docker rm -f exec-test 2>/dev/null || true"

# Run container for exec tests
docker_cmd "docker run -d --name exec-test alpine:latest sleep 3600"

sleep 1

docker_cmd "docker exec exec-test sh -c 'echo \"Hello from exec\" > /tmp/test.txt'"
docker_cmd "docker exec exec-test cat /tmp/test.txt > exec_output.txt"
docker_cmd "docker exec exec-test sh -c 'ps aux' > exec_processes.txt"
docker_cmd "docker exec -it exec-test sh -c 'echo \"Interactive exec test\" >> /tmp/test.txt' 2>&1 | head -n 5 >> exec_output.txt"

echo "exec_operations.sh completed."
