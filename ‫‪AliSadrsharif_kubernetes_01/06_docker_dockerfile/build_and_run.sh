#!/bin/bash
# build_and_run.sh
# Purpose: build our custom image from the Dockerfile, run it, verify it
# responds over HTTP, and inspect its resulting layers.

set -e  # stop on first unexpected error

# Move into the directory this script lives in, so relative paths
# (like the build context ".") work no matter where the script is called from.
cd "$(dirname "$0")"

# 1) Build the image from the Dockerfile in the current directory (build context = .).
#    Tee the build output to the terminal AND save it to build_log.txt.
docker build -t lab-python-server:1.0 . 2>&1 | tee build_log.txt

# 2) Confirm the image was created by listing it.
docker images | grep lab-python-server > built_images.txt

# 3) Run the built image in the background, mapping host port 8000 to container port 8000.
docker run -d --name lab-py -p 8000:8000 lab-python-server:1.0

# Give the server a moment to start before hitting it.
sleep 2

# 4) Curl the running app to verify it responds correctly.
curl -s http://localhost:8000 > curl_app.txt

# 5) Show the layer history of our custom image (helps confirm one layer per
#    Dockerfile instruction), keeping the first 12 lines.
docker history lab-python-server:1.0 --no-trunc | head -n 12 > layers_after_build.txt

# 6) Stop and remove the container to clean up.
docker stop lab-py && docker rm lab-py

# NOTE: if port 8000 is already in use on your machine, change the -p mapping
# above to a free host port and update accordingly.
