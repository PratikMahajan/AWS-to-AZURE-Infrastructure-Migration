resource "aws_lb" "loadbalancer" {
  name               = var.loadbalancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_security_group
  subnets            = var.lb_subnets

  enable_deletion_protection = false

  tags = {
    env = var.env
  }
}


resource "aws_lb_target_group" "lb_target_group" {
  name     = "ec2-recipe-lb-target-group"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.aws_vpc_id
}

resource "aws_lb_listener" "lb_listner" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   =  var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}