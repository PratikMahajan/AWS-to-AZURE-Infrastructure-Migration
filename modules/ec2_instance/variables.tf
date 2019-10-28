variable "aws_account_id" {}
variable "aws_ec2_security_group" {}
variable "ebs_block_name" {}
variable "ebs_volume_type" {}
variable "ebs_volume_size" {}
variable "ebs_delete_on_termination" {}
variable "env" {}
variable "ec2_termination_disable" {}
variable "ec2_instance_type" {}
variable "ec2_instance_name" {}
variable "aws_ec2_subnet_id" {}
variable "aws_key_pair_name" {}

variable "DB_USER" {
  default = ""
}
variable "DB_PASSWORD" {
  default = ""
}
variable "DATABASE_NAME" {
  default = ""
}
variable "DB_HOST" {
  default = ""
}
variable "RECIPE_S3" {
  default = ""
}
variable "AWS_REGION" {}
variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}

variable "iam_instance_profile" {
  default = ""
}

