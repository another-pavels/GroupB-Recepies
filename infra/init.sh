#!/bin/bash
set -e 

#Get FQDN:recepies.mooo.com 
curl -k https://freedns.afraid.org/dynamic/update.php\?SWJHSHBtS3lxRHp4dU53QkduQ2c6MjE1OTcwMDA\= 

#Deploy ssh on non-standart port
echo "Port 2234" >> /etc/ssh/sshd_config
service sshd restart

##Shutdown after 3 hours of runtime
#sudo shutdown -P +180

##Shutdown at midnight
echo "0 0 * * * sudo shutdown now" |crontab -

#Install Docker,Ansible etc.
sudo apt update && \
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && \
apt-cache policy docker-ce && \
sudo apt install docker-ce docker-compose net-tools ansible -y


#Run Ansible playbook for other deployments. 
curl -s -o /opt/ansible-batch.yml "https://raw.githubusercontent.com/another-pavels/GroupB-Recepies/main/infra/ansible-batch.yml" && \
/usr/bin/ansible-playbook /opt/ansible-batch.yml 

git clone https://github.com/another-pavels/GroupB-Recepies.git /var/www/html         
#docker-compose -f /opt/webserver-compose up -d
