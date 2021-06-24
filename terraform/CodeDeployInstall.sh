#!/bin/bash
apt update

echo "-------------Install Apache----------------------"
apt install -y apache2
ufw allow 'Apache'
echo "-------------Creating test page------------------"
region=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone/)
echo "<h2><center> This server at region $region </center> </h2><br>Build by psybrat" > /var/www/html/index.html

echo "------------Install Ruby-------------------------"
apt install -y ruby-full

echo "------------Install wget-------------------------"
apt install -y wget

echo "-----------Getting Region ID---------------------"
REGION_ID=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | \
            python3 -c "import sys, json; print(json.load(sys.stdin)['region'])")

echo "----------Downloading CodeDeploy kit-------------"
pushd /home/ubuntu || return
wget "https://aws-codedeploy-${REGION_ID}.s3.${REGION_ID}.amazonaws.com/latest/install" 

echo "----------Installing CodeDeploy agent------------"
chmod +x ./install
./install auto

