#!/bin/bash
set -e

mkdir -p ca client server

# CA certificate
openssl req -x509 -new -nodes -keyout ca/rootCA.key -sha256 -days 365 \
    -out ca/rootCA.crt -subj "/C=IR/O=DevOpsClass/CN=demo-ca"

# server certificate
openssl req -new -nodes -out server/server.csr -keyout server/server.key \
    -subj "/C=IR/O=DevOpsClass/CN=mtls.local"
openssl x509 -req -in server/server.csr -CA ca/rootCA.crt -CAkey ca/rootCA.key \
    -out server/server.crt -days 365 -sha256 -CAcreateserial

# client certificate
openssl req -new -nodes -out client/client.csr -keyout client/client.key \
    -subj "/C=IR/O=DevOpsClass/CN=client1"
openssl x509 -req -in client/client.csr -CA ca/rootCA.crt -CAkey ca/rootCA.key \
    -out client/client.crt -days 365 -sha256 -CAcreateserial

echo "Certificates generated successfully"
ls -R . > certs_structure.txt
