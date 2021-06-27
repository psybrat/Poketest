#!/usr/bin/env bash
chown ubuntu:ubuntu /home/ubuntu/www
python3 -m venv /home/ubuntu/www/pokemon-venv
chown ubuntu:ubuntu /home/ubuntu/www/pokemon-venv
chown ubuntu:ubuntu /home/ubuntu/www/pokemon-venv/*
source /home/ubuntu/www/pokemon-venv/bin/activate

pip install -r /home/ubuntu/www/pokemon/requirements.txt
