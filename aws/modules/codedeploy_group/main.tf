resource "aws_codedeploy_deployment_group" "CD_deployment_group" {
  app_name               = var.aws_codedeploy_app_name
  deployment_group_name  = var.codedeploy_deployment_group_name
  service_role_arn       = var.aws_iam_service_role_arn

  #Deployment Setting
  deployment_config_name = var.deployment_config_service

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_type   = var.cd_deployment_type
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  ec2_tag_set {
    ec2_tag_filter {
      key   = var.cd_ec2_tag_key
      type  = "KEY_AND_VALUE"
      value = var.cd_ec2_tag_value
    }
  }

}