#!/bin/bash

docker compose down 2>/dev/null
docker compose up -d backend1 backend2

sleep 2

{
echo -e "### Backend 1 response ###\n"
curl http://localhost:8080/
} > "backend1_response.txt"

{
echo -e "### Backend 2 response ###\n"
curl http://localhost:8081/
} > "backend2_response.txt"

{
echo -e "### Backends status ###\n"
docker ps | grep backend
} > "backends_status.txt"

docker compose down