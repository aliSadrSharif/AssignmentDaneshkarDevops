#!/bin/bash

# remove the container if it exists
docker rm -f nginx-static 2>/dev/null

# run nginx with read-only bind mount to local web directory
docker run -d --name nginx-static \
  -p 8080:80 \
  -v "$(pwd)/web:/usr/share/nginx/html:ro" \
  nginx:alpine

# wait for 2 seconds
sleep 2

{
echo -e "### Static check ###\n"
echo -e "### Initial response ###\n"
curl -i http://localhost:8080/

echo "File modified" >> web/index.html
echo -e "### Modified response ###\n"
curl -i http://localhost:8080/
} > "static_check.txt"

# stop the nginx container
docker stop nginx-static

# remove the nginx container
docker rm nginx-static
