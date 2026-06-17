#!/bin/bash

# This script pulls the following images:
# - nginx:alpine
# - haproxy:alpine
# - traefik:v3.0
# - python:3.9-alpine

docker pull nginx:alpine
docker pull haproxy:alpine
docker pull traefik:v3.0
docker pull python:3.9-alpine

# and saves the list of pulled images to pulled_images.txt
docker images | grep -E 'nginx|haproxy|traefik|python' > pulled_images.txt