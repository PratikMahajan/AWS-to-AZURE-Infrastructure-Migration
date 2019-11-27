resource "aws_codedeploy_deployment_group" "example" {
  app_name              = var.aws_codedeploy_app_name
  deployment_group_name = var.codedeploy_deployment_group_name
  service_role_arn      = var.aws_iam_service_role_arn

  #Deployment Setting
  deployment_config_name = var.deployment_config_service

  autoscaling_groups     = var.autoscaling_groups

  load_balancer_info {
    target_group_info {
      name = var.target_group_info
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_type   = var.cd_deployment_type
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }
}