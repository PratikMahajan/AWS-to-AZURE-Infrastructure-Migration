provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "dev"
}

module "dev_vps"{
  source          = "../../modules/vpc"
  env             = var.env
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

module "dev_security_group"{
  source          = "../../modules/security_group"
  aws_vpc_id      = module.dev_vps.vpc_id
}

module "dev_s3_bucket" {
  source          = "../../modules/s3_bucket"
  s3_bucket_name  = var.s3_bucket_name
  env             = var.env
}

module "dev_rds_instance" {
  source                  = "../../modules/rds_database"
  db_identifier           = var.db_identifier
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  database_engine         = var.database_engine
  database_engine_version = var.database_engine_version
  instance_class          = var.instance_class
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  subnet_group_id         = ["${module.dev_vps.aws_subnet1_id}", "${module.dev_vps.aws_subnet2_id}"]
  publicly_accessible     = var.publicly_accessible
  db_security_group       = [module.dev_security_group.aws_db_security_group]
}