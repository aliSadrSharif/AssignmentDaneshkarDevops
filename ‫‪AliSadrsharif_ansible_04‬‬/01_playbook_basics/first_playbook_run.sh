#!/bin/bash


{
    # Run the playbook
    echo "***** Running the playbook *****"
    sudo ansible-playbook first_playbook.yml --become
    # Check the syntax of the playbook
    echo "***** Checking the syntax of the playbook *****"
    sudo ansible-playbook first_playbook.yml --syntax-check --become
    # Run the playbook with the variables
    echo "***** Running the playbook with the variables *****"
    sudo ansible-playbook first_playbook.yml -e "app_port=9090 app_version=2.0.0" --become
} > result_first_playbook.txt