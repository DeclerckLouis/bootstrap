#!/bin/bash

echo "Starting bootstrap script"

# Check if the script is run as root and attempt to get privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Attempting to get privileges..."
    sudo "$0" "$@"
    exit $?
else
    echo "Running as root."
fi

if [[ $(pwd) != "/opt/bootstrap" ]]; then
    echo "Detected that the script is not in the /opt/bootstrap directory."
    echo "Will reinitialize in /opt/bootstrap"
    if [[ ! -d /opt/bootstrap ]]; then
        git clone https://github.com/declercklouis/bootstrap /opt/bootstrap
        chmod +x /opt/bootstrap/bootstrap.sh
    fi
    cd /opt/bootstrap
    exec /opt/bootstrap/bootstrap.sh "$@"
    exit 0
fi

echo "hello!