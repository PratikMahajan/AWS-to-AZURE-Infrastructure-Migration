resource "aws_lb" "loadbalancer" {
  name               = var.loadbalancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_security_group
  subnets            = var.lb_subnets

  enable_deletion_protection = true

  tags = {
    env = var.env
  }
}