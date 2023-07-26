# irm.mx infrastructure

## Setup

Crear los certificados (con estos mismos nombres) para el servicio web:
```sh
mkcert -cert-file web.pem -key-file web.key.pem "localhost"
```

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
