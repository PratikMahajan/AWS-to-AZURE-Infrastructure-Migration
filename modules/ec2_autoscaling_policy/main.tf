resource "aws_autoscaling_policy" "asg_policy" {
  name                   = var.asg_policy_name
  scaling_adjustment     = var.scaling_adjustment
  adjustment_type        = var.adjustment_type
  cooldown               = var.cooldown_period
  autoscaling_group_name = var.autoscaling_group_name
}