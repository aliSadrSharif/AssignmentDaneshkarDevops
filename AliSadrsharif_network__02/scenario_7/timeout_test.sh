#!/bin/bash

TARGET_HOST="192.0.2.1"
TARGET_PORT=22
TIMEOUT=5

echo "Testing SSH connectivity to $TARGET_HOST:$TARGET_PORT ..."
timeout $TIMEOUT ssh -o ConnectTimeout=$TIMEOUT user@$TARGET_HOST

if [ $? -eq 124 ]; then
echo "Simulated timeout occurred."
else
echo "Connection attempt completed (unexpected for timeout test)."
fi