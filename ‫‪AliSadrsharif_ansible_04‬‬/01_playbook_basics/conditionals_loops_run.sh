#!/bin/bash


{
    # Run the playbook
    echo "***** Running the playbook *****"
    sudo ansible-playbook conditionals_loops.yml
} > result_conditionals_loops.txt