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
docker_cmd "docker rm -f health-test 2>/dev/null || true"

# Run container with health check
docker_cmd 'docker run -d --name health-test --health-cmd="curl -f http://localhost:80 || exit 1" --health-interval=5s --health-timeout=3s --health-retries=3 nginx:alpine'

sleep 10

{
    docker_cmd "docker inspect --format='{{.State.Health.Status}}' health-test"
    echo ""
    docker_cmd "docker ps --filter 'name=health-test' --format 'table {{.Names}}\t{{.Status}}'"
} > health_status.txt 2>&1

docker_cmd "docker inspect --format='{{json .State.Health}}' health-test | python3 -m json.tool > health_details.txt"

echo "health_check.sh completed."
