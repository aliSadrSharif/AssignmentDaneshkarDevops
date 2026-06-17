#!/bin/bash

docker rm -f nginx-logs 2>/dev/null

docker run -d --name nginx-logs \
    -p 8091:80 \
    nginx:alpine

sleep 2

# generate traffic
curl http://localhost:8091/ > /dev/null
curl http://localhost:8091/nonexistent 2>&1 > /dev/null

{
echo -e "### Latest logs (tail 20) ###\n"
docker logs nginx-logs --tail 20
} > "latest_logs.txt"

{
echo -e "### Error logs ###\n"
docker logs nginx-logs 2>&1 | grep -i error || echo "No errors found"
} > "error_logs.txt"

{
echo -e "### Recent logs (last 1 minute) ###\n"
docker logs nginx-logs --since 1m
} > "recent_logs.txt"

docker stop nginx-logs
docker rm nginx-logs
