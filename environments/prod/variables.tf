variable "env" {}

# Configuration for VPC
variable "aws_region" {}
variable "subnet1_az" {}
variable "subnet1_name" {}
variable "subnet1_cidr" {}
variable "subnet2_az" {}
variable "subnet2_cidr" {}
variable "subnet2_name" {}
variable "subnet3_cidr" {}
variable "subnet3_az" {}
variable "subnet3_name" {}
variable "vpc_cidr" {}
variable "vpc_name" {}


# COnfiguration for aws key pair
variable "ssh_public_key" {}


# Configuration for s3 bucket creation
variable "s3_bucket_name" {}

# Configuring database
variable "database_engine_version" {}
variable "db_identifier" {}
variable "allocated_storage" {}
variable "storage_type" {}
variable "database_engine" {}
variable "instance_class" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "publicly_accessible" {}


# Configuring ec2 instance
variable "aws_account_id" {}
variable "ebs_block_name" {}
variable "ebs_volume_type" {}
variable "ebs_volume_size" {}
variable "ebs_delete_on_termination" {}
variable "ec2_termination_disable" {}
variable "ec2_instance_type" {}
variable "ec2_instance_name" {}

# Configuring DynamoDB instance
variable "dynamo_billing_mode" {}
variable "dynamo_table_name" {}


# Configuring circleci_codedeploy iam policy
variable "application_name" {}

# Configuration for s3 bucket for codedeploy
variable "s3_bucket_name_codedeploy" {}

# Configuring codedeploy ec2instance
variable "ec2_instance_name_codedeploy" {}

# Configuring codedeploy app
variable "cd_compute_platform" {}
variable "cd_app_name" {}

# Configuring codedeploy group
variable "codedeploy_deployment_group_name" {}
variable "cd_deployment_type" {}
variable "deployment_config_service" {}