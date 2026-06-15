#!/bin/bash

# This script counts TCP sockets in LISTEN and ESTABLISHED states.
# It uses ss first, and falls back to netstat if ss is not available.

if command -v ss >/dev/null 2>&1; then
    # Count TCP sockets with ss.
    listen_count=$(ss -tan | awk '$1 == "LISTEN" { count++ } END { print count + 0 }')
    established_count=$(ss -tan | awk '$1 == "ESTAB" { count++ } END { print count + 0 }')
elif command -v netstat >/dev/null 2>&1; then
    # Count TCP sockets with netstat when ss is missing.
    listen_count=$(netstat -tan | awk '$6 == "LISTEN" { count++ } END { print count + 0 }')
    established_count=$(netstat -tan | awk '$6 == "ESTABLISHED" { count++ } END { print count + 0 }')
else
    echo "Neither ss nor netstat is available"
    exit 1
fi

echo "LISTEN: $listen_count"
echo "ESTABLISHED: $established_count"

# Run example:
# bash 06_tcp/tcp_count.sh
