#!/usr/bin/env bash
cd /home/ubuntu/www/pokemon/
source /home/ubuntu/www/pokemon-venv/bin/activate
screen -d -m python manage.py runserver 0.0.0.0:8000