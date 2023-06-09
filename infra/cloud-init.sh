#!/bin/bash
set -e 

#Deploy ssh on non-standard port
echo "Port 2234" >> /etc/ssh/sshd_config
service sshd restart

##Shutdown at midnight from cron
echo "0 0 * * * sudo shutdown now" |crontab -

#Background tasks from cron
echo "* * * * * /usr/bin/php /var/www/html/artisan queue:work --timeout=30" |crontab -
echo "1,6,11,16,21,26,31,36,41,46,51,56 * * * * sleep 24 ; wget --no-check-certificate -O - https://freedns.afraid.org/dynamic/update.php?YjRoc0NrTnU1b3UzWVhTWUtveTg6MjE2MjQ1MTM= >> /tmp/freedns_recipes_us_to.log 2>&1 &"
wget --no-check-certificate -O - https://freedns.afraid.org/dynamic/update.php?YjRoc0NrTnU1b3UzWVhTWUtveTg6MjE2MjQ1MTM=

echo "# apt update && sudo apt upgrade -y"
apt update && sudo apt upgrade -y
echo "# Finish state:"$?

#NodeJS LTS repository 
echo "# NodeJS LTS repository"
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
echo "# Finish state:"$?


#Docker repository
echo "# Docker repository"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "# Finish state:"$?


#PHP repository
echo "# PHP repository"
sudo add-apt-repository ppa:ondrej/php -y
echo "# Finish state:"$?


#Caddy repository
echo "Caddy repository"
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
echo "# Finish state:"$?

echo "sudo apt update"
sudo apt update
echo "# Finish state:"$?

echo "sudo apt install ..."
sudo apt install -y \
    docker-ce \
    docker-compose \
    net-tools \
    ansible \
    unzip \
    zip \
    composer \
    caddy \
    mariadb-server 

echo "# Finish state:"$?

sudo usermod -aG docker ubuntu
sudo systemctl restart docker 

#Run Ansible playbook for some procedural tasks.
echo "# Run Ansible playbook for some procedural tasks."
curl -s -o /opt/ansible-batch.yml "https://raw.githubusercontent.com/another-pavels/GroupB-Recepies/main/infra/ansible-batch.yml" && \
/usr/bin/ansible-playbook /opt/ansible-batch.yml 
echo "# Finish state:"$?

echo "# Clone project repository"
git clone https://github.com/another-pavels/GroupB-Recepies.git /var/www/html         
echo "# Finish state:"$?

touch /var/www/html/storage/logs/laravel.log
sudo chown -R ubuntu:www-data /var/www
sudo chmod g+s /var/www
sudo chmod -R ugo+rw /var/www/html/storage

echo "Install php 8.1"
sudo apt install -y \
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
    php8.1-gd 
echo "# Finish state:"$?

#Set php default version
update-alternatives --set php /usr/bin/php8.1

systemctl restart mysql && \
DBNAME=recepies_db ; DBUSER=recepies_user ; DBPASS=recepies_pass;
echo "CREATE DATABASE $DBNAME" | sudo mysql && 
echo "GRANT ALL PRIVILEGES ON $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASS'" | sudo mysql

FQDN="recepies.us.to"
cd /var/www/html/
cp .env.example .env
    sed -i "s|^APP_URL=http://FQDN-template|APP_URL=https://$FQDN|g" .env
    sed -i 's|^DB_DATABASE=laravel|DB_DATABASE=recepies_db|g' .env
    sed -i 's|^DB_USERNAME=.*|DB_USERNAME=recepies_user|g' .env
    sed -i 's|^DB_PASSWORD=.*|DB_PASSWORD=recepies_pass|g' .env
    chown ubuntu .env

echo "composer..."
su ubuntu -c "whoami && \
	cd /var/www/html/ && \
	composer install && \
	php artisan key:generate && \
	sudo npm install -g npm@9.7.1 && \
	npm install && \
	npm run build && \
	php artisan migrate --force"
cp /var/www/html/infra/Caddyfile /etc/caddy/Caddyfile
sed -i "s|^FQDN-template|$FQDN|g" /etc/caddy/Caddyfile
systemctl restart caddy

