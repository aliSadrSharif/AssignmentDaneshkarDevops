#!/bin/bash

# remove any existing stack
docker compose down 2>/dev/null

# start backend and nginx reverse proxy via Docker Compose
docker compose up -d

# wait for containers to be ready
sleep 3

{
echo -e "### Frontend test ###\n"
curl http://localhost:8080/
} > "frontend_test.txt"

{
echo -e "### API proxy test ###\n"
curl http://localhost:8080/api
} > "api_test.txt"

{
echo -e "### Nginx proxy logs ###\n"
docker logs nginx-proxy | tail -n 10
} > "proxy_logs.txt"

# stop and remove containers
docker compose down
