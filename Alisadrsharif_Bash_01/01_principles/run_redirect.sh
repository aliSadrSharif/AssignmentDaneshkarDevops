#!/bin/bash

# Use the script directory so outputs are created next to this script.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create the output directory for log files.
mkdir -p "$SCRIPT_DIR/outputs"

# Redirect stdout to app.log and stderr to app.err.
exec 1>"$SCRIPT_DIR/outputs/app.log" 2>"$SCRIPT_DIR/outputs/app.err"

# Print a sample message to stdout.
echo "info is this"

# Run a failing command to write an error message to stderr.
ls /path/that/does/not/exists

# Run example:
# bash 01_principles/run_redirect.sh