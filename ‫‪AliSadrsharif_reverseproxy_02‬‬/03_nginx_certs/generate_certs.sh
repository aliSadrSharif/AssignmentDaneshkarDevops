#!/bin/bash

# create a directory for the certs
mkdir -p certs

# generate a self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout certs/demo.key \
    -out certs/demo.crt \
    -subj "/C=IR/ST=Tehran/L=Tehran/O=DevOpsClass/CN=demo.local"

# list the certs
ls -lh certs/ > certs_info.txt