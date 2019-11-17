resource "aws_codedeploy_deployment_group" "example" {
  app_name              = var.aws_codedeploy_app_name
  deployment_group_name = var.codedeploy_deployment_group_name
  service_role_arn      = var.aws_iam_service_role_arn

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_info {
      name = var.target_group_info
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 60
    }

    green_fleet_provisioning_option {
      action = "DISCOVER_EXISTING"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
    }
  }
}