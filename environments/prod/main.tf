provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "prod"
}

module "prod_vps"{
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

module "prod_security_group"{
  source          = "../../modules/security_group"
  aws_vpc_id      = module.prod_vps.vpc_id
}


module "aws_key_pair" {
  source = "../../modules/aws_key_pair"
  key_pair_name = "${var.env}-${var.application_name}"
  ssh_public_key = var.ssh_public_key
}


module "prod_s3_bucket" {
  source          = "../../modules/s3_bucket"
  s3_bucket_name  = var.s3_bucket_name_webapp
  env             = var.env
}


module "prod_rds_instance" {
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
  subnet_group_id         = ["${module.prod_vps.aws_subnet1_id}", "${module.prod_vps.aws_subnet2_id}"]
  publicly_accessible     = var.publicly_accessible
  db_security_group       = [module.prod_security_group.aws_db_security_group]
}


module "prod_dynamodb_instance" {
  source              = "../../modules/dynamodb_instance"
  dynamo_billing_mode = var.dynamo_billing_mode
  dynamo_table_name   = var.dynamo_table_name
  env                 = var.env
}


module "circle_codedeploy_policy" {
  source = "../../modules/iam_circleci"
  account_id = var.aws_account_id
  application_name = var.application_name
  aws_region = var.aws_region
}

module "iam_ec2_codedeploy_policy_attachment" {
  source = "../../modules/ec2_iam_attachment"
  aws_CircleCI-Code-Deploy_policy = module.circle_codedeploy_policy.aws_CircleCI-Code-Deploy_policy
  aws_CodeDeploy-EC2-S3_policy = module.circle_codedeploy_policy.aws_CodeDeploy-EC2-S3_policy
  aws_CodeDeploy-EC2-S3_KMS_policy    = module.circle_codedeploy_policy.EC2_KMS_ACCESS_POLICY
}

module "codedeploy_s3_bucket" {
  source          = "../../modules/s3_bucket"
  s3_bucket_name  = var.s3_bucket_name_codedeploy
  env             = var.env
}


module "codedeploy_ec2_instance" {
  source                    = "../../modules/ec2_instance"
  aws_account_id            = var.aws_account_id
  aws_ec2_security_group    = ["${module.prod_security_group.aws_app_security_group}"]
  aws_ec2_subnet_id         = module.prod_vps.aws_subnet1_id
  ebs_block_name            = var.ebs_block_name
  ebs_delete_on_termination = var.ebs_delete_on_termination
  iam_instance_profile      = module.iam_ec2_codedeploy_policy_attachment.CodeDeployEC2ServiceRoleInstance
  ebs_volume_size           = var.ebs_volume_size
  ebs_volume_type           = var.ebs_volume_type
  ec2_instance_name         = var.ec2_instance_name_codedeploy
  ec2_instance_type         = var.ec2_instance_type
  ec2_termination_disable   = var.ec2_termination_disable
  env                       = var.env
  aws_key_pair_name         = module.aws_key_pair.aws_key_pair_name

  AWS_ACCESS_KEY_ID         = var.aws_access_key_id
  AWS_SECRET_ACCESS_KEY     = var.aws_secret_access_key
  AWS_REGION                = var.aws_region
  DATABASE_NAME         = var.db_name
  DB_HOST               = module.prod_rds_instance.RDS_instance_host_address
  DB_PASSWORD           = var.db_password
  DB_USER               = var.db_username
  RECIPE_S3             = var.s3_bucket_name_webapp
}

module "codedeploy_app" {
  source = "../../modules/codedeploy_application"
  cd_app_name = var.cd_app_name
  cd_compute_platform = var.cd_compute_platform
}


module "codedeploy_group"{
  source                            = "../../modules/codedeploy_group"
  aws_codedeploy_app_name           = module.codedeploy_app.codedeploy_app_name
  aws_iam_service_role_arn          = module.iam_ec2_codedeploy_policy_attachment.CodeDeployServiceRole_arn
  cd_deployment_type                = var.cd_deployment_type
  cd_ec2_tag_key                    = module.codedeploy_ec2_instance.ec2_tag_name
  cd_ec2_tag_value                  = module.codedeploy_ec2_instance.ec2_tag_value
  codedeploy_deployment_group_name  = var.codedeploy_deployment_group_name
  deployment_config_service         = var.deployment_config_service
}
