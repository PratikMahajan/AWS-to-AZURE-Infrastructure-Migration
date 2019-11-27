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
└── Readme.md
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

## Destroy Infrastructure
```shell script
terraform destroy -var-file=<varfile_name>.tfvars
```

# AWS to Azure Migration Services 

| AWS | AZURE |
| --- | --- |
| Virtual Private Cloud (VPC) | Virtual Network |
| Organizations | Subscription Management + RBAC + Policy + Management Groups |
| CloudFront | Content Delivery Network |
| Route 53 | DNS |
| Codedeploy | DevOps |
| EC2 | Virtual Machines |
| Application Load Balancer | Application Gateway |
| Auto Scaling | Virtual Machine Scale Sets |
| S3 | Blob storage |
| Server-side encryption with Amazon S3 Key Management Service | Azure Storage Service Encryption |
| RDS | Database for MySQL | 
| DynamoDB | Cosmos DB |
| Lambda | Functions |
| Certificate Manager | App Service Certificates  |
| Web Application Firewall | Application Gateway - Web Application Firewall + Azure Firewall |
| SNS | |
| SES | |