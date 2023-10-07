#!/usr/bin/env bash
# a bash script that sets up your web servers for the deployment of web_static

# checks if nginx is intalled
if ! dpkg -l | grep -qi "nginx"; then
	sudo apt-get -y update
	sudo apt-get -y install nginx
fi

# creates the dir /data if it does not exist
if [[ ! -d '/data' ]]; then
	sudo mkdir '/data'
fi

# creates the dir /data/web-static if it does not exist
if [[ ! -d '/data/web_static' ]]; then
	sudo mkdir '/data/web_static'
fi

# creates dir /data/web-static/releases if it does not exist
if [[ ! -d '/data/web_static/releases' ]]; then
	sudo mkdir '/data/web_static/releases'
fi

# creates dir /data/web_static/shared if it does not exist
if [[ ! -d '/data/web_static/shared' ]]; then
	sudo mkdir '/data/web_static/shared'
fi

# creates dir /data/web-static/releases/test if it does not exist
if [[ ! -d '/data/web_static/releases/test' ]]; then
	sudo mkdir '/data/web_static/releases/test'
fi

# creates file /data/web-static/releases/test/index.html if it does not exist
if [[ ! -f '/data/web_static/releases/test/index.html' ]]; then
	body="<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>"
	echo "$body" | sudo tee '/data/web_static/releases/test/index.html' > /dev/null
fi

# this a symbolic link linked to the test folder
sudo ln -sf '/data/web_static/releases/test/' '/data/web_static/current'


# changing the dir ownership
sudo chown -R ubuntu:ubuntu '/data'

# Use sed to locate the 'server {' block and replace the 'location' block
old="server_name _;"
new="server_name _;\n\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}"
sudo sed -i "s|$old|$new|" /etc/nginx/sites-enabled/default

sudo service nginx restart
