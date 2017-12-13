#!/bin/bash

echo "Installing docker-compose:"
sudo mkdir -p /opt/bin/
sudo curl -L https://github.com/docker/compose/releases/download/1.17.0/docker-compose-`uname -s`-`uname -m` -o /opt/bin/docker-compose
sudo chmod +x /opt/bin/docker-compose
echo "docker-compose installed"
