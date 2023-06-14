#!/bin/bash
set -e 

#Deploy ssh on non-standard port
echo "Port 2234" >> /etc/ssh/sshd_config
service sshd restart

##Shutdown at midnight from cron
echo "0 0 * * * sudo shutdown now" |crontab -

#Background tasks from cron
echo "* * * * * /usr/bin/php /var/www/html/artisan queue:work" |crontab -

#NodeJS LTS repository 
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - 

#Docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#PHP repository
sudo add-apt-repository ppa:ondrej/php

#Caddy repository
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list

sudo apt update

sudo apt install -y \
    docker-ce \
    docker-compose \
    net-tools \
    ansible \ 
    nodejs \
    caddy \
    git \
    php8.1 \
    php8.1-fpm \
    php8.1-mysql \
    php8.1-mbstring \
    php8.1-common \
    php8.1-intl \
    php8.1-zip \
    php8.1-bz2 \
    php8.1-xml \
    php8.1-curl \
    php8.1-memcached \
    php8.1-gd \
    unzip \
    zip \
    composer \
    mariadb-server

sudo usermod -aG docker ubuntu
sudo systemctl restart docker 

#Run Ansible playbook for some procedural tasks.
curl -s -o /opt/ansible-batch.yml "https://raw.githubusercontent.com/another-pavels/GroupB-Recepies/main/infra/ansible-batch.yml" && \
/usr/bin/ansible-playbook /opt/ansible-batch.yml 

git clone https://github.com/another-pavels/GroupB-Recepies.git /var/www/html         

touch /var/www/html/storage/logs/laravel.log
sudo chown -R ubuntu:www-data /var/www
sudo chmod g+s /var/www
sudo chmod -R ugo+rw /var/www/html/storage