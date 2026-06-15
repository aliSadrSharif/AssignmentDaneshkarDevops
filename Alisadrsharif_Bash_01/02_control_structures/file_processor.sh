#!/bin/bash

# This script reads sample.txt and writes lines containing "error" to errors.txt.

# Use the script directory so the script works from any current path.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_FILE="$SCRIPT_DIR/sample.txt"
OUTPUT_FILE="$SCRIPT_DIR/errors.txt"

# Stop if the sample input file does not exist.
if [ ! -f "$INPUT_FILE" ]; then
    echo "sample.txt not found"
    exit 1
fi

# Clear the output file before writing new errors.
> "$OUTPUT_FILE"

# Read all lines from the input file into an array.
mapfile -t lines < "$INPUT_FILE"

# Save lines that contain "error" in any letter case.
for line in "${lines[@]}"; do
    if echo "$line" | grep -qi "error"; then
        echo "$line" >> "$OUTPUT_FILE"
    fi
done

echo "Errors saved to $OUTPUT_FILE"

# Run example:
# bash 02_control_structures/file_processor.sh
