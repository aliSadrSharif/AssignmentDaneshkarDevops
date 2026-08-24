#!/bin/bash
# port_and_exec.sh
# Purpose: practice publishing a container port to the host, verifying it
# with curl, and running commands inside a running container via 'exec'.

set -e  # stop on first unexpected error

# 0) Clean up any leftover container from a previous run.
docker rm -f lab-web 2>/dev/null || true

# 1) Run nginx in the background, mapping host port 9080 to container port 80
#    (-p HOST:CONTAINER). This makes the container reachable at localhost:9080.
docker run -d --name lab-web -p 9080:80 nginx:alpine

# Give nginx a couple of seconds to fully start before we curl it.
sleep 2

# 2) Curl the container and capture only the HTTP status code (e.g., 200).
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:9080 > curl_status.txt

# 3) Curl again, this time capturing the first 5 lines of the actual response body.
curl -s http://localhost:9080 | head -n 5 > curl_body.txt

# 4) Append Docker's own record of the port mapping for this container
#    (confirms which host port maps to which container port).
docker port lab-web >> curl_status.txt

# 5) Use 'docker exec' to write a test file INSIDE the running container's filesystem.
docker exec lab-web sh -c 'echo lab-test > /tmp/test.txt'

# 6) Use 'docker exec' again to read that file back out and save it locally.
docker exec lab-web cat /tmp/test.txt > exec_result.txt

# 7) Stop and remove the container to clean up.
docker stop lab-web && docker rm lab-web

# NOTE: if port 9080 is already in use on your machine, pick a different
# host port, update the -p mapping above, and note the change in curl_status.txt.
