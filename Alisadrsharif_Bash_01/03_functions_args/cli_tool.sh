#!/bin/bash

# Print help text for available options.
show_help() {
    echo "Usage:"
    echo "  bash cli_tool.sh -f FILE"
    echo "  bash cli_tool.sh -u USER"
    echo "  bash cli_tool.sh -h"
}

# Read command-line options with getopts.
while getopts "f:u:h" opt; do
    case "$opt" in
        f)
            # Count lines only if the input file exists.
            if [ -f "$OPTARG" ]; then
                awk 'END { print NR }' "$OPTARG"
            else
                echo "File not found: $OPTARG"
                exit 1
            fi
            ;;
        u)
            echo "Welcome, $OPTARG"
            ;;
        h)
            show_help
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

# Show help when no option is provided.
if [ "$OPTIND" -eq 1 ]; then
    show_help
    exit 1
fi

# run the script with the following commands:

# bash 03_functions_args/cli_tool.sh -f 02_control_structures/sample.txt
# bash 03_functions_args/cli_tool.sh -u Ali
# bash 03_functions_args/cli_tool.sh -h