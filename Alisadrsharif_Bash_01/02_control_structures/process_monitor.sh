#!/bin/bash

# This script prints the number of running processes three times.

count=0

# Run the monitor loop three times with a 5-second delay.
while [ $count -lt 3 ]
do
    ps aux | wc -l
    sleep 5
    count=$((count + 1))
done

# Run example:
# bash 02_control_structures/process_monitor.sh
