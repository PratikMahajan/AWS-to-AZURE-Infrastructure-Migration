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

# Configuration for AWS
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

# Configuration for s3 bucket creation
variable "s3_bucket_name_webapp" {}

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

variable "aws_asg_name" {}
variable "asg_desired_capacity" {}
variable "asg_force_delete" {}
variable "asg_launch_config_name" {}
variable "asg_max_size" {}
variable "asg_min_size" {}
variable "cooldown_period" {}
variable "public_ip_address" {}

# Configuring DynamoDB instance
variable "dynamo_billing_mode" {}
variable "dynamo_table_name" {}


# Configuring circleci_codedeploy iam policy
variable "application_name" {}
variable "circleci_user_name" {}

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

#configuring loadbalancer
variable "loadbalancer_name" {}
variable "ssl_certificate_arn" {}

# configuring route53
variable "domain_name" {}
variable "webapp_domain_prefix" {}

# configuring lambda s3 bucket
variable "s3_bucket_name_lambda" {}

# COnfigure Scaling Policies
variable "alarm_period" {}
variable "alarm_statistic" {}
variable "alarm_threshold_up" {}
variable "alarm_threshold_down" {}
variable "comparison_operator_up" {}
variable "comparison_operator_down" {}
variable "evaluation_periods" {}
variable "metric_name" {}