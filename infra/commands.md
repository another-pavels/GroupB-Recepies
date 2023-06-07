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
