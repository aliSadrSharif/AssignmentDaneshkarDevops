#!/bin/bash

# This script checks the syntax of all .sh files in the project.

# Use the script directory to find the project root from any current path.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Find each shell script and run bash syntax checking on it.
find "$PROJECT_ROOT" -type f -name "*.sh" | while read -r file; do
    if bash -n "$file" 2>/tmp/syntax_error_$$.txt; then
        echo "OK: $file"
    else
        echo "ERROR: $file"
        sed 's/^/  /' /tmp/syntax_error_$$.txt
    fi
done

# Remove the temporary syntax error file.
rm -f /tmp/syntax_error_$$.txt

# Run example:
# bash 01_principles/syntax_checker.sh > 01_principles/syntax_report.txt
