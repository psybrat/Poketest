#!/bin/bash
apt update
apt install apache2
ufw allow 'Apache'