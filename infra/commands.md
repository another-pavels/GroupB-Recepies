### time before shutdown 
`date --date @$(head -1 /run/systemd/shutdown/scheduled |cut -c6-15)`

### terraform related
`terraform init` 
`terraform plan`  
`terraform destroy -auto-approve && terraform apply -auto-approve` 

## laravel specific
connect to docker and execute `php artisan tinker`  
or  just `sail artisan tinker`

execute php scripts like:`sail php -v`
Composer commands:`sail composer require laravel/sanctum`

publish dockerfiles `sail artisan sail:publish` (publish "docker" folder inside project)


```
cd /var/www/html && 
docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html \
    laravelsail/php82-composer:latest \
    composer install --ignore-platform-reqs
```
