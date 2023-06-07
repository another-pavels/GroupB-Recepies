### time before shutdown 
`date --date @$(head -1 /run/systemd/shutdown/scheduled |cut -c6-15)`

### terraform related
`terraform init` 
`terraform plan`  
`terraform destroy -auto-approve && terraform apply -auto-approve` 

