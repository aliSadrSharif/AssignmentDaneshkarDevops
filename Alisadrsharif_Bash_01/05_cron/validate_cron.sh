#!/bin/bash

# This script validates a simple crontab-like file without editing the real system crontab.

# Use the script directory so the script works from any current path.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/sample.cron"

# Stop if the sample cron file does not exist.
if [ ! -f "$INPUT_FILE" ]; then
    echo "sample.cron not found"
    exit 1
fi

# Read each cron line and skip comments or empty lines.
while IFS= read -r line; do
    if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi

    # A simple cron line must have five time fields plus a command.
    field_count=$(awk '{ print NF }' <<< "$line")

    if [ "$field_count" -ge 6 ]; then
        echo "VALID: $line"
    else
        echo "INVALID: $line"
    fi
done < "$INPUT_FILE"

# Run example:
# bash 05_cron/validate_cron.sh
