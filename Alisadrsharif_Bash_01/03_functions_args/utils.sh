#!/bin/bash

# Print a greeting message.
say_hello() {
    local name="$1"
    echo "Hello, $name"
}

# Count the number of lines in a file.
count_lines() {
    local file="$1"

    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        exit 1
    fi

    awk 'END { print NR }' "$file"
}

# Check disk usage against a given threshold.
disk_ok() {
    local threshold="$1"
    local usage

    usage=$(df -h / | awk 'NR==2 { gsub("%", "", $5); print $5 }')

    if [ "$usage" -gt "$threshold" ]; then
        echo "ALERT"
    else
        echo "OK"
    fi
}

# Choose which function to run based on the first argument.
case "$1" in
    hello)
        say_hello "$2"
        ;;
    count)
        count_lines "$2"
        ;;
    disk)
        disk_ok "$2"
        ;;
    *)
        echo "Usage:"
        echo "  bash utils.sh hello NAME"
        echo "  bash utils.sh count FILE"
        echo "  bash utils.sh disk THRESHOLD_PERCENT"
        exit 1
        ;;
esac

# run the script with the following commands:

# bash 03_functions_args/utils.sh hello Ali
# bash 03_functions_args/utils.sh count 02_control_structures/sample.txt
# bash 03_functions_args/utils.sh disk 80