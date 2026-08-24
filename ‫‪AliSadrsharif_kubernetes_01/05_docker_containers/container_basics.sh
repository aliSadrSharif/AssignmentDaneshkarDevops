#!/bin/bash
# container_basics.sh
# Purpose: practice running containers, inspecting their state/logs, and
# passing environment variables into a running container.

set -e  # stop on first unexpected error

# 0) Clean up any leftover containers from a previous run of this script,
#    so we always start from a known state. Ignore errors if they don't exist.
docker rm -f lab-nginx lab-env 2>/dev/null || true

# 1) Run an nginx container in detached mode (in the background), named lab-nginx.
docker run -d --name lab-nginx nginx:alpine

# 2) Show only the lab-nginx container, with a custom table format
#    (name, status, published ports), and save it.
docker ps --filter name=lab-nginx --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" > container_ps.txt

# 3) Grab the first 8 lines of the container's logs (stdout+stderr).
docker logs lab-nginx 2>&1 | head -n 8 > container_logs.txt

# 4) Run a second container (plain alpine) that just sleeps for an hour,
#    passing two environment variables (-e) into it.
docker run -d --name lab-env -e APP_NAME=lab -e PORT=8080 alpine sleep 3600

# 5) Use 'docker exec' to run a command INSIDE the already-running lab-env
#    container (list its environment variables), filtering for the two we set.
docker exec lab-env env | grep -E 'APP_NAME|PORT' > env_vars.txt

# 6) Stop both containers, then remove them, to leave the environment clean.
docker stop lab-nginx lab-env && docker rm lab-nginx lab-env
