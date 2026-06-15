#!/bin/bash

# This script extracts only ERROR lines from app.log and saves them to errors.log.

# Use the script directory so the script works from any current path.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/app.log"
OUTPUT_FILE="$SCRIPT_DIR/errors.log"

# Stop if the log file does not exist.
if [ ! -f "$INPUT_FILE" ]; then
    echo "app.log not found"
    exit 1
fi

# Save only lines that contain ERROR.
sed -n '/ERROR/p' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Errors saved to $OUTPUT_FILE"

# Run example:
# bash 04_text_processing/extract_errors.sh
