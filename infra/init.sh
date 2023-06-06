#!/bin/bash
set -e 
curl -k https://freedns.afraid.org/dynamic/update.php\?SWJHSHBtS3lxRHp4dU53QkduQ2c6MjE1OTcwMDA\= 
sudo apt update && \
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update && \
apt-cache policy docker-ce && \
sudo apt install docker-ce docker-compose net-tools ansible -y
curl -s -o /opt/ansible-batch.yml "https://raw.githubusercontent.com/another-pavels/GroupB-Recepies/main/infra/ansible-batch.yml" 
echo "@reboot sudo shutdown -P +180" | crontab

#docker-compose -f /opt/webserver-compose up -d
