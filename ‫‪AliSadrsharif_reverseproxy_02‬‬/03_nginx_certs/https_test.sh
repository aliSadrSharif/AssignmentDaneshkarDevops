#!/bin/bash

# remove container if it exists
docker rm -f nginx-https 2>/dev/null

# start Nginx with HTTPS and mounted certificates
docker run -d --name nginx-https \
    -p 8443:443 \
    -v "$(pwd)/nginx_https.conf:/etc/nginx/nginx.conf:ro" \
    -v "$(pwd)/certs:/etc/nginx/certs:ro" \
    nginx:alpine

# wait for container to be ready
sleep 2

{
echo -e "### HTTPS response ###\n"
curl -k https://localhost:8443/status
echo -e "\n### Certificate dates ###\n"
openssl s_client -connect localhost:8443 -servername demo.local < /dev/null 2>&1 | \
    openssl x509 -noout -dates
} > "https_response.txt"

{
echo -e "### Nginx HTTPS logs ###\n"
docker logs nginx-https | tail -n 10
} > "https_logs.txt"

# stop and remove container
docker stop nginx-https
docker rm nginx-https
