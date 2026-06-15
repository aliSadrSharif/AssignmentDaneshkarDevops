#!/bin/bash

HOST="localhost"
PORTS=(80 22 3306)
{
echo -e "----- Port Check on $HOST -----\n"

for PORT in "${PORTS[@]}"; do
    echo -n "port $PORT is "

    if command -v nc >/dev/null 2>&1; then
        #using netcat
        timeout 3 nc -zv "$HOST" "$PORT" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "OPEN"
        else
            echo "CLOSED or FILTERED"
        fi
    else
        #using telnet if netcat doesn't exist
        timeout 3 bash -c "echo quit | telnet $HOST $PORT" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "OPEN"
        else
            echo "CLOSED or FILTERED"
        fi
    fi
done
} > port_check.txt