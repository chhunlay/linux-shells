#!/bin/bash

# Function to check if a command is available, otherwise install it
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "$1 not found. Installing..."
        sudo apt-get install -y "$1"
    fi
}

# Check if arp-scan is installed
check_command "arp-scan"

# Perform arp-scan to get a list of devices
echo "Scanning for devices on the network..."
sudo arp-scan --localnet | grep -E '([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})' > devices.txt

# Display the name, MAC address, IP address, and status of each device
echo -e "\nDevice Information and Status:"
while IFS= read -r line; do
    ip=$(echo "$line" | awk '{print $1}')
    mac=$(echo "$line" | awk '{print $2}')

    # Use arp to extract the hostname
    name=$(arp -a "$ip" | awk '{print $1}' | tr -d '()')

    # If the hostname is not available, attempt to get it using NetBIOS
    if [ -z "$name" ]; then
        name=$(nmblookup -A "$ip" | awk '/<00>/{print $1}')
    fi

    # If the hostname is still not available, set it to "Unknown"
    [ -z "$name" ] && name="Unknown"

    # Check if the device responds to ping to determine its status
    if ping -c 1 -W 1 "$ip" &> /dev/null; then
        status="Online"
    else
        status="Offline"
    fi

    echo "Name: $name, MAC: $mac, IP: $ip, Status: $status"
done < devices.txt

# Clean up temporary file
rm devices.txt
