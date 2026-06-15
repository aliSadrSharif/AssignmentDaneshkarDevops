#!/bin/bash

# This script removes empty lines and comments, then changes DEBUG=true to DEBUG=false.

# Use the script directory so the script works from any current path.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/config.ini"
OUTPUT_FILE="$SCRIPT_DIR/config.clean"

# Stop if the config file does not exist.
if [ ! -f "$INPUT_FILE" ]; then
    echo "config.ini not found"
    exit 1
fi

# Clean the config file with sed and save the result.
sed '/^$/d; /^#/d; s/^DEBUG=true/DEBUG=false/' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Clean config saved to $OUTPUT_FILE"

# Run example:
# bash 04_text_processing/clean_config.sh
