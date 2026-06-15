#!/bin/bash
set -e

# Run from the script directory (06_docker_compose)
cd "$(dirname "$0")"

# Run docker-compose commands (use sg docker if group is not active in session)
compose_cmd() {
    if groups | grep -q '\bdocker\b'; then
        bash -c "$1"
    else
        sg docker -c "$1"
    fi
}

# Show resolved compose config with .env variable substitution
compose_cmd "docker-compose config > compose_with_env.txt"

# Start services using variables from .env
compose_cmd "docker-compose up -d"
sleep 5

# Verify MySQL env vars were passed into the db container
compose_cmd "docker-compose exec -T db env | grep MYSQL > db_env_vars.txt"

# Stop and remove containers
compose_cmd "docker-compose down"

echo "env_test.sh completed."
