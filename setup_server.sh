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

# Function to install PHP
install_php() {
    log_message "Installing PHP and necessary modules..."
    apt install -y php-fpm php-mysql
    systemctl enable php7.4-fpm
    systemctl start php7.4-fpm
}

# Function to install MySQL
install_mysql() {
    log_message "Installing MySQL..."
    apt install -y mysql-server
    systemctl enable mysql
    systemctl start mysql
    
    # Secure MySQL installation
    log_message "Securing MySQL installation..."
    mysql_secure_installation
}

# Function to configure firewall
configure_firewall() {
    log_message "Configuring firewall..."
    apt install -y ufw
    ufw allow 'Nginx Full'
    ufw allow 'OpenSSH'
    ufw --force enable
}

# Function to create a sample index.php file
create_sample_page() {
    log_message "Creating a sample index.php file..."
    echo "<?php phpinfo(); ?>" > /var/www/html/index.php
}

# Main execution
check_root
update_system
install_nginx
install_php
install_mysql
configure_firewall
create_sample_page

log_message "Server setup completed successfully!"