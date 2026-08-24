#!/bin/bash
set -e

# Create network
docker network create lab-net 2>/dev/null || true

# Remove containers
docker rm -f lab-a lab-b 2>/dev/null || true

# Run containers
# Container A
docker run -d --name lab-a --network lab-net alpine sleep 3600

# Container B
docker run -d --name lab-b --network lab-net alpine sleep 3600

docker exec lab-a ping -c 2 lab-b > ping_by_name.txt

docker network inspect lab-net > network_inspect.txt

docker rm -f lab-a lab-b
