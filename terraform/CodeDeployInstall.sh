#!/bin/bash
apt update
apt install ruby-full
apt install wget

echo -----------Getting Region ID---------------------
REGION_ID=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)

echo "----------Downloading CodeDeploy kit-------------"
cd /home/ubuntu
wget https://aws-codedeploy-${REGION_ID}.s3.${REGION_ID}.amazonaws.com/latest/install

echo "----------Installing CodeDeploy agent------------"
chmod +x ./install
./install auto

