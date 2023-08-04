# Infrastructure for irm.mx
This is the implementation for the services provided by **irm.mx**.

## Setup
The services are *dockerized* projects. All the services are handle by [terraform](https://www.terraform.io/) and [docker](https://www.docker.com/). You have to install them previous to deploy.

You have to create a *infrastructure/terraform/terraform.tfvars* file with the parameters required:
```terraform
// at this moment, you can set any string
environment = "production"

// The dir where Syncthing use to sync dirs
syncthing_data = "/your/absolute/path/to/sync/data"
```
The **environment** parameter is used to name the elements created by *terraform*. The **syncthing_data** is where *syncthing* handle the dirs.

## Deploy
Once you have the instal
```sh
# Init terraform
terraform -chdir=./infrastructure/terraform init

#
terraform -chdir=./infrastructure/terraform plan

# Build all the docker images and run containers
terraform -chdir=./infrastructure/terraform apply

```

If you want to destroy all the *docker* items (containers, images) execute:
```sh
# Delete all items created by terraform
terraform -chdir=./infrastructure/terraform destroy
```
