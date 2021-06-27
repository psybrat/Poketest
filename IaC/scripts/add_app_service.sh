#!/usr/bin/env bash
cp /home/ubuntu/www/pokemon/IaC/pokemon_app.service /usr/lib/systemd/user/
systemctl --user daemon-reload
