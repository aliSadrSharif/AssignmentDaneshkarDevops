#!/bin/bash

docker compose down 2>/dev/null
docker compose up -d

sleep 3

{
echo "=== Load Balancing Test ==="
for i in {1..6}; do
    echo "Request $i:"
    curl http://localhost:9000/
    echo ""
done
} > "haproxy_test.log"

{
echo -e "### HAProxy logs ###\n"
docker logs haproxy-lb | tail -n 20
} > "haproxy_logs.txt"

{
echo -e "### Container stats ###\n"
docker stats --no-stream haproxy-lb backend1 backend2
} > "haproxy_stats.txt"

docker compose down
