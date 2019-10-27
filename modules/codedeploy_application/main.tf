resource "aws_codedeploy_app" "example" {
  compute_platform = var.cd_compute_platform
  name             = var.cd_name
}