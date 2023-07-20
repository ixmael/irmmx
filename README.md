# irm.mx infrastructure

## Deploy
```sh
docker run -i -t hashicorp/terraform:latest plan
```

```sh
# Init terraform
terraform -chdir=./infrastructure/terraform init

#
terraform -chdir=./infrastructure/terraform plan

#
terraform -chdir=./infrastructure/terraform apply

#
terraform -chdir=./infrastructure/terraform destroy
```
