resource "aws_codedeploy_app" "cd_app" {
  compute_platform = var.cd_compute_platform
  name             = var.cd_app_name
}