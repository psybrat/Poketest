#!/bin/bash
apt update
apt install -y apache2
ufw allow 'Apache'

region=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone/)
echo "<h2><center> This server at $region </center> </h2><br>Build by psybrat" > /var/www/html/index.html
