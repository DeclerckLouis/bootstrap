#!/bin/bash

# Check if the script is run as root and attempt to get privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Attempting to get privileges..."
    sudo "$0" "$@"
    exit $?
else
    echo "Running as root."
fi


echo "Starting bootstrap script"

# Check whether the this repo is located in the /opt directory
if [[ $(pwd) != "/opt/bootstrap" ]]; then
    current_file=$(readlink -f "$0")
    current_dir=$(pwd)
    echo "Detected that the script is not in the /opt/bootstrap directory. "
    echo "Will reinitialize in /opt/bootstrap"
    git clone https://github.com/declercklouis/bootstrap /opt/bootstrap
    chmod +x /opt/bootstrap/bootstrap.sh
    rm -rf "$current_dir/$current_file" && /opt/bootstrap/bootstrap.sh

fi

# CHeck if the script is run from the /opt/bootstrap directory
if [[ $(pwd) != "/opt/bootstrap" ]]; then
    
    exit 1
fi


rm -rf current_dir