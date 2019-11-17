output "autoscaling_group_name" {
  value = aws_autoscaling_group.asg.name
}

output "ec2_tag_name" {
  value = "Name"
}

output "ec2_tag_value" {
  value = aws_launch_configuration.asg_launch_config.tags.Name
}