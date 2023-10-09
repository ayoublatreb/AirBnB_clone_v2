#!/bin/bash

# Install Nginx if not already installed
if ! [ -x "$(command -v nginx)" ]; then
    sudo apt-get update
    sudo apt-get -y install nginx
fi

# Create necessary directories if they don't exist
sudo mkdir -p /data/web_static/{releases/test,shared}
sudo chown -R ubuntu:ubuntu /data/

# Create a fake HTML file for testing
echo "<html><head></head><body>Hello, Nginx!</body></html>" | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create or recreate the symbolic link
if [ -L /data/web_static/current ]; then
    sudo rm /data/web_static/current
fi
sudo ln -s /data/web_static/releases/test/ /data/web_static/current

# Configure Nginx
sudo sed -i '/hbnb_static/ {
    s/alias \/data\/web_static\/current\//alias \/data\/web_static\/current\/hbnb_static\//g
    s/default_server;/default_server;\n        location \/hbnb_static\/ {\n            alias \/data\/web_static\/current\/;\n        }/g
}' /etc/nginx/sites-available/default

# Restart Nginx
sudo service nginx restart
