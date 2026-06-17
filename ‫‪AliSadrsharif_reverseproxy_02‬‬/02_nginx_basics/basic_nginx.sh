#!/bin/bash

# remove the container if it exists
docker rm -f nginx-basic 2>/dev/null

# This script runs a basic nginx container and exposes it on port 8080
docker run -d --name nginx-basic -p 8080:80 nginx:alpine

# wait for 2 seconds
sleep 2

# get the response from the nginx container
{
echo -e "### Nginx response ###\n"
curl -I http://localhost:8080
} > "nginx_response.txt"

# get the logs from the nginx container
{
echo -e "### Nginx logs ###\n"
docker logs nginx-basic | head -n 10
} > "nginx_logs.txt"

# get the network settings from the nginx container
{
echo -e "### Nginx network settings ###\n"
docker inspect nginx-basic | grep -A 5 "NetworkSettings"
} > "nginx_network.txt"

# stop the nginx container
docker stop nginx-basic

# remove the nginx container
docker rm nginx-basic
