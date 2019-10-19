provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "prod"
}

module "prod-vps"{
  source          = "../../modules/vpc"
  env             = "prod"
  aws_region      = var.aws_region
  subnet1_az      = var.subnet1_az
  subnet1_cidr    = var.subnet1_cidr
  subnet1_name    = var.subnet1_name
  subnet2_az      = var.subnet2_az
  subnet2_cidr    = var.subnet2_cidr
  subnet2_name    = var.subnet2_name
  subnet3_az      = var.subnet3_az
  subnet3_cidr    = var.subnet3_cidr
  subnet3_name    = var.subnet3_name
  vpc_cidr        = var.vpc_cidr
  vpc_name        = var.vpc_name
}