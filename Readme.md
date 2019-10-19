# Terraform

## Setting up Terraform
Install Terraform on your local machine using:
```shell script
./terraform_install/install_terraform.sh
```




# Basic Terraform Commands
## Initialize Terraform 
```shell script
terraform init
```

## Create Terraform plan 
```shell script
terraform plan -var-file=<varfile_name>.tfvars -out=<Output_Plan_File_Name.tfstate>
```

## Apply Terraform template 
```shell script
terraform apply "<Output_Plan_File_Name.tfstate>"
```

### Destroy VPC
```shell script
terraform destroy -var-file=<varfile_name>.tfvars
```