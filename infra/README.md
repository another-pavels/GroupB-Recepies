
## CLI tools 


|  | Install instructions  |
| ------ | ------ |
| **AWS** | https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html |
| **Terraform** | https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli |


---

## Amazon 

Initial config ([access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) registration)
```sh
aws configure
```

List all running instances
```sh
aws ec2 describe-instances \
--query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}"  \
--filters "Name=instance-state-name,Values=running" --output table
```

List all instances with their InstanceId
```sh
aws ec2 describe-instances \
--query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name,Instance:InstanceId}"  \
--output table
```
Start instance (with id=i-05f8d90f0c0205486)
```sh
aws ec2 start-instances --instance-ids i-05f8d90f0c0205486`
```
Stop instance (with id=i-05f8d90f0c0205486)
```
aws ec2 stop-instances --instance-ids i-05f8d90f0c0205486
```

## Terraform 
1) Inside main.tf containing folder run: `terraform init` (will install providers(eg. AWS) necessary files inside current folder).
2) Dry-run current changes with: `terraform plan` (check syntax and planed behavior)
3) Apply described configuration `terraform apply` to make even faster `terraform apply -auto-approve`

Destroy everything created before `terraform destroy` 

Recreate all (WARN: will delete everything earlier created): `terraform destroy -auto-approve && terraform apply -auto-approve`


---
## MySQL
Create databases, user and grant privileges. 
```sh
DBNAME=recepies_db ; DBUSER=recepies_user ; DBPASS=recepies_pass;
echo "CREATE DATABASE $DBNAME" | sudo mysql && 
echo "GRANT ALL PRIVILEGES ON $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASS'" | sudo mysql
```
---
## Laravel 

Prepare **.env** file (domain,database,openid key etc.)

```sh
cd /var/www/html/
cp .env.example .env
    sed -i 's|^APP_URL=http://localhost|APP_URL=https://recipes.us.to|g' .env
    sed -i 's|^DB_DATABASE=laravel|DB_DATABASE=recepies_db|g' .env
    sed -i 's|^DB_USERNAME=.*|DB_USERNAME=recepies_user|g' .env
    sed -i 's|^DB_PASSWORD=.*|DB_PASSWORD=recepies_pass|g' .env
# manually specify OpenAI key and anything else. 
    vim .env
```
Install laravel dependencies
```sh
cd /var/www/html/
composer install
php artisan key:generate
sudo npm install -g npm@9.7.1
npm install
npm run build
php artisan migrate --force
```

