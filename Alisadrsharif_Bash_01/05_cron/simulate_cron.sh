#!/bin/bash

# This script simulates cron by listing commands that would run.
# It does not execute commands or edit the real system crontab.

# Use the script directory so the script works from any current path.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/sample.cron"
OUTPUT_FILE="$SCRIPT_DIR/would_run.txt"

# Stop if the sample cron file does not exist.
if [ ! -f "$INPUT_FILE" ]; then
    echo "sample.cron not found"
    exit 1
fi

# Extract the command part after the five cron time fields.
awk '
    NF == 0 || $1 ~ /^#/ { next }
    NF >= 6 {
        $1=""; $2=""; $3=""; $4=""; $5="";
        sub(/^ */, "");
        print
    }
' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Commands saved to $OUTPUT_FILE"

# Run example:
# bash 05_cron/simulate_cron.sh
