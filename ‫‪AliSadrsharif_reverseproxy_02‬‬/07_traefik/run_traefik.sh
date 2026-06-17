#!/bin/bash

docker compose down 2>/dev/null
docker compose up -d

sleep 5

{
echo -e "### Traefik compose status ###\n"
docker compose ps
} > "traefik_status.txt"

{
echo -e "### Whoami response ###\n"
curl http://localhost:8080/
} > "whoami_response.txt"

{
echo -e "### Traefik API rawdata ###\n"
curl http://localhost:8081/api/rawdata 2>&1 || echo "API check"
} > "traefik_api.txt"

{
echo -e "### Traefik logs ###\n"
docker compose logs traefik | tail -n 30
} > "traefik_logs.txt"

docker compose down
