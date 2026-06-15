#!/bin/bash

# This script checks the current user, the sample file, and error messages.

# Use the script directory so sample.txt is found from any current path.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="$SCRIPT_DIR/sample.txt"

# Check if the current user is root.
if [ "$(id -u)" -eq 0 ]; then
    echo "root user"
else
    echo "normal user"
fi

# Check if sample.txt exists and count its lines.
if [ -f "$FILE" ]; then
    line_count=$(awk 'END { print NR }' "$FILE")
    echo "File exists. Number of lines: $line_count"
else
    echo "File did not exist."
fi

# Search for "ERROR" or "error" in the sample file.
if [ -f "$FILE" ] && grep -qi "error" "$FILE"; then
    echo "Warning: ERROR found in $FILE"
fi

# Run example:
# bash 02_control_structures/system_checker.sh
