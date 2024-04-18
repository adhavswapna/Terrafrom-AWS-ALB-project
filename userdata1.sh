#!/bin/bash

# Update package repositories
sudo apt update

# Install Apache web server
sudo apt install apache2 -y

# Create HTML file with user data
echo "<html><body><h1>This page is created by swapna</h1><p>This is a simple HTML page generated via user data.</p></body></html>" | sudo tee /var/www/html/index.html > /dev/null

# Start Apache service
sudo systemctl enable apache2
sudo systemctl start apache2

