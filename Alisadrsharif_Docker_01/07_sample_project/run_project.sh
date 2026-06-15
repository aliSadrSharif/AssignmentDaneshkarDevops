#!/bin/bash
set -e

# Run from the script directory (07_sample_project)
cd "$(dirname "$0")"

# Run docker-compose commands (use sg docker if group is not active in session)
compose_cmd() {
    if groups | grep -q '\bdocker\b'; then
        bash -c "$1"
    else
        sg docker -c "$1"
    fi
}

# Build images and start services in the background
compose_cmd "docker-compose up -d --build"
sleep 5

# Test frontend and API endpoints
curl http://localhost:3000 > frontend_test.html
curl http://localhost:3000/api > api_test.json

# Save service status and recent logs
compose_cmd "docker-compose ps > project_status.txt"
compose_cmd "docker-compose logs --tail 20 > project_logs.txt"

echo "run_project.sh completed."
