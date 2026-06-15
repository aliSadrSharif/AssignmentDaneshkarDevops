#!/bin/bash

# This helper script removes output files created by run_redirect.sh.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rm -rf "$SCRIPT_DIR/outputs"

# Run example:
# bash 01_principles/cleanup_redirect.sh