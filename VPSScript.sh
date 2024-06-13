#!/bin/bash

# Script by Node Farmer
# Medium: https://medium.com/@cryptonodefarmer_80672
# X: https://x.com/_node_farmer_
# Telegram: https://t.me/+Hrs33jHFE0liMWNk
# Discord: https://discord.gg/GXRvQByQ

# Define the service file path
SERVICE_FILE="/etc/systemd/system/eth0-config.service"

# Check if the script is being run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Install ethtool if it is not already installed
if ! command -v ethtool &> /dev/null; then
  echo "ethtool not found, installing..."
  apt-get update
  apt-get install -y ethtool
fi

# Create the systemd service file
cat <<EOL > $SERVICE_FILE
[Unit]
Description=Configure eth0 network interface
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -s eth0 speed 1000 duplex full autoneg off
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd to recognize the new service
systemctl daemon-reload

# Enable the service to start on boot
systemctl enable eth0-config.service

# Start the service immediately
systemctl start eth0-config.service

echo "Service eth0-config has been installed and started."
