#!/bin/bash

docker compose -f docker-compose-advanced.yml down 2>/dev/null
docker compose -f docker-compose-advanced.yml up -d

sleep 5

{
echo "=== Testing web1 ==="
curl -H "Host: web1.localhost" http://localhost:8080/
echo -e "\n=== Testing web2 ==="
curl -H "Host: web2.localhost" http://localhost:8080/
echo -e "\n=== Traefik Dashboard ==="
curl http://localhost:8081/api/http/routers
} > "advanced_test.txt"

docker compose -f docker-compose-advanced.yml down
