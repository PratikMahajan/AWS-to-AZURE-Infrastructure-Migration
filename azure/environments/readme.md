# Terraform Environments

There are two environments set for Terraform 
* dev
* prod

Deployments on both the environments are isolated from each other. \
Both environments use same modules located in `..\..\modules` folder

Environment take variables through a `terraform-<ENV>.tfvars` file.


## Setting up 
Create a `terraform-<ENV>.tfvars` file in the respective folders. \
Add required variable values in the `tfvars` file


## Deploy on Development Server
To deploy on development server, Initialize and create a plan in `dev` folder.


## Deploy on Production Server
To deploy on production server, Initialize and create a plan in `prod` folder.

