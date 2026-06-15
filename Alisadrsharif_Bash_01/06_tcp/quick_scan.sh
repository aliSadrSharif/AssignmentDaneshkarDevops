#!/bin/bash

# This script checks whether ports 22, 80, and 443 are open on localhost.
# It uses nc first, and falls back to Bash /dev/tcp if nc is not available.

HOST="localhost"
PORTS=(22 80 443)

for port in "${PORTS[@]}"; do
    if command -v nc >/dev/null 2>&1; then
        # Use netcat to test the TCP port.
        nc -z -w 2 "$HOST" "$port" >/dev/null 2>&1
        result=$?
    else
        # Use Bash /dev/tcp with timeout when netcat is missing.
        timeout 2 bash -c "</dev/tcp/$HOST/$port" >/dev/null 2>&1
        result=$?
    fi

    if [ "$result" -eq 0 ]; then
        echo "$port open"
    else
        echo "$port closed"
    fi
done

# Run example:
# bash 06_tcp/quick_scan.sh
