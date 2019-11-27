# Azure and AWS Infrastructure for Webapp with CI/CD

Infrastructure as Code for both Amazon Web Services and Microsoft Azure written in Terraform. 


## Setting up Terraform
Install Terraform on your local machine using:
```shell script
./terraform_install/install_terraform.sh
```

## Terraform Structure

According to best practices, the terraform structure is as follows:
```
├── environments
│   ├── dev
│   │   ├── main.tf
│   │   ├── terraform-dev.tfvars
│   │   └── variables.tf
│   ├── prod
│   │   ├── main.tf
│   │   ├── terraform-prod.tfvars
│   │   └── variables.tf
│   └── readme.md
├── modules
│   └── {LIST_OF_ALL_MODULES}
├── Readme.md
└── terraform_install
    ├── install_terraform.sh
    └── readme.md
```

### Environments
There are two environments, i.e. `dev` and `prod`. \
To deploy to specific environment, initialize terraform in respective folder

### Modules
All the modules are stored in the modules folder, with a seperate folder for every module. \
All all new and existing modules in this folder.


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