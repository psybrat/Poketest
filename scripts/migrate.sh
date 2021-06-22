#!/usr/bin/env bash
cd /home/ubuntu/www/pokemon/
source /home/ubuntu/www/pokemon-venv/bin/activate
python manage.py migrate
