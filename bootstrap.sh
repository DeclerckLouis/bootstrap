#!/bin/bash

echo "Starting bootstrap script."

# Check if the script is run as root and attempt to get privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." 
    echo "Attempting to get privileges..."
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
    cd /opt/bootstrap && git pull
    exec /opt/bootstrap/bootstrap.sh "$@"
    exit 0
fi

echo "Continuing.."

# Set cron job to update and run  repo every 5 minutes
(crontab -l 2>/dev/null; echo "*/5 * * * * cd /opt/bootstrap && git pull") | crontab -
(crontab -l 2>/dev/null; echo "*/5 * * * * cd /opt/bootstrap && ./bootstrap.sh") | crontab -

# Ensure curl is installed
if ! command -v curl &> /dev/null; then
    echo "curl could not be found. Installing..."
    apt-get update && apt-get install -y curl
fi

# Get keys from github profile and write them to ~/.ssh/authorized_keys
if [[ ! -f ~/.ssh/authorized_keys ]]; then
    mkdir -p ~/.ssh
    touch ~/.ssh/authorized_keys
fi
curl -s github.com/declercklouis.keys >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
# Remove duplicate keys
awk '!seen[$0]++' ~/.ssh/authorized_keys > ~/.ssh/authorized_keys.tmp
mv ~/.ssh/authorized_keys.tmp ~/.ssh/authorized_keys