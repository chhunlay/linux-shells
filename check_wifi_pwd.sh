#!/bin/bash
#owner: chhunlaytip
#date:30/Nov/23

# Change directory to /etc/NetworkManager/system-connections/
cd /etc/NetworkManager/system-connections/

# List all files, including hidden files, in the current directory
ls -a

# Prompt for the profile name
echo ":------------------: :--------------------:"
read -p "- Enter the profile name: " profile_name

# Use sudo to read the contents of the specified profile
sudo cat "$profile_name"
echo ":-------------: WiFI Info :---------------:"
sudo cat "$profile_name" | grep -E 'ssid|psk'
echo ":------------------: :--------------------:"
