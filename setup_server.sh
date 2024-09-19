#!/bin/bash

# Automated Server Setup Script
# Author: Wrek
# Description: This script automates the setup of a web server environment on a fresh Linux installation.

# Exit immediately if a command exits with a non-zero status
set -e

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if script is run with root privileges
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_message "Error: This script must be run as root"
        exit 1
    fi
}

# Function to update system packages
update_system() {
    log_message "Updating system packages..."
    apt update && apt upgrade -y
}

# Function to install web server (Nginx)
install_nginx() {
    log_message "Installing Nginx web server..."
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
}

# Main execution
check_root
update_system
install_nginx

log_message "Server setup completed successfully!"