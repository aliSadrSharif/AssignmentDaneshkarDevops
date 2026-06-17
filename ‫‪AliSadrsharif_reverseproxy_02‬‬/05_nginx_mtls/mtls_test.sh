#!/bin/bash

docker rm -f nginx-mtls 2>/dev/null

docker run -d --name nginx-mtls \
    -p 9443:9443 \
    -v "$(pwd)/nginx_mtls.conf:/etc/nginx/nginx.conf:ro" \
    -v "$(pwd):/etc/nginx/mtls:ro" \
    nginx:alpine

sleep 2

{
echo "=== Test without client certificate ==="
curl -k https://localhost:9443/ -v 2>&1 | grep -E 'HTTP|SSL|certificate'
echo -e "\n=== Test with client certificate ==="
curl -k https://localhost:9443/ \
    --cert client/client.crt \
    --key client/client.key \
    -v 2>&1 | grep -E 'HTTP|SSL|certificate'
} > "mtls_test.txt"

{
echo -e "### Nginx mTLS logs ###\n"
docker logs nginx-mtls | tail -n 10
} > "mtls_logs.txt"

docker stop nginx-mtls
docker rm nginx-mtls
