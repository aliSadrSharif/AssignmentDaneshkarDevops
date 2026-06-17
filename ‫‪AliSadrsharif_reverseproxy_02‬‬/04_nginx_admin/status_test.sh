#!/bin/bash

docker rm -f nginx-status 2>/dev/null

docker run -d --name nginx-status \
    -p 8090:80 \
    -v "$(pwd)/nginx_status.conf:/etc/nginx/nginx.conf:ro" \
    nginx:alpine

sleep 2

# generate traffic
for i in {1..5}; do
    curl http://localhost:8090/ > /dev/null
done

{
echo -e "### Nginx stub_status output ###\n"
curl http://localhost:8090/basic_status
} > "status_output.txt"

{
echo -e "### Nginx status logs ###\n"
docker logs nginx-status | tail -n 15
} > "status_logs.txt"

docker stop nginx-status
docker rm nginx-status
