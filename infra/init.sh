#!/bin/bash
set -e 
sudo apt update && \
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update && \
apt-cache policy docker-ce && \
sudo apt install docker-ce docker-compose net-tools ansible -y
curl -s -o /opt/ansible-batch.yml https://raw.githubusercontent.com/another-pavels/GroupB-Recepies/infra/ansible-batch.yml
#docker-compose -f /opt/webserver-compose up -d
