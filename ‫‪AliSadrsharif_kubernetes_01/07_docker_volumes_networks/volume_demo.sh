#!/bin/bash
set -e

cd "$(dirname "$0")"

docker volume create lab-data

docker run --rm -v lab-data:/data alpine sh -c 'echo persistent > /data/msg.txt'

docker run --rm -v lab-data:/data alpine cat /data/msg.txt > volume_persist.txt

docker volume inspect lab-data > volume_inspect.txt

mkdir -p web
echo '<h1>Bind mount test</h1>' > web/index.html

docker run -d --name lab-bind -p 9090:80 \
  -v "$(pwd)/web:/usr/share/nginx/html:ro" nginx:alpine

sleep 2

curl -s http://localhost:9090 | head -n 5 > bind_mount_curl.txt

docker stop lab-bind && docker rm lab-bind
