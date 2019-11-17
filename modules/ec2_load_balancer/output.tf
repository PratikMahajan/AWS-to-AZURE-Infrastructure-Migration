output "lb_name" {
  value = aws_lb.loadbalancer.name
}

output "aws_lb_dns" {
  value = aws_lb.loadbalancer.dns_name
}

output "loadbalancer_target_group_name" {
  value = aws_lb_target_group.lb_target_group.name
}