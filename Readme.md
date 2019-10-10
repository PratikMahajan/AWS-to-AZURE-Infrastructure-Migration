# Terraform Deployment

## Setup Terraform
```shell script
./install_terraform.sh
```

## Initialize Terraform 
```shell script
terraform init
```

## Create Terraform plan 
```shell script
terraform plan -out=terraState.tfstate
```

## Apply Terraform template 
```shell script
terraform apply "terraState.tfstate"
```

### Destroy VPC
```shell script
terraform destroy
```