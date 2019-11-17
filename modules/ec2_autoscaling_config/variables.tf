variable "aws_asg_name" {}
variable "availability_zones" {}
variable "asg_desired_capacity" {}
variable "asg_max_size" {}
variable "asg_min_size" {}
variable "asg_force_delete" {}
variable "iam_instance_profile" {}
variable "ebs_block_name" {}
variable "ebs_volume_type" {}
variable "ebs_volume_size" {}
variable "ebs_delete_on_termination" {}
variable "ec2_instance_name" {}
variable "env" {}
variable "asg_launch_config_name" {}
variable "instance_type" {}
variable "aws_ec2_security_group" {}
variable "aws_key_pair_name" {}
variable "aws_account_id" {}
variable "public_ip_address" {}
variable "cooldown_period" {}

variable "vpc_subnets" {}

variable "DB_USER" {}
variable "DB_PASSWORD" {}
variable "DATABASE_NAME" {}
variable "DB_HOST" {}
variable "RECIPE_S3" {}
variable "AWS_REGION" {}
variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}

variable "ssl_cert" {}
variable "ssl_key" {}