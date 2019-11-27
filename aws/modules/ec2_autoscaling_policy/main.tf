resource "aws_autoscaling_policy" "asg_policy" {
  name                   = var.asg_policy_name
  scaling_adjustment     = var.scaling_adjustment
  adjustment_type        = var.adjustment_type
  cooldown               = var.cooldown_period
  autoscaling_group_name = var.autoscaling_group_name
}


resource "aws_cloudwatch_metric_alarm" "asg_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = "AWS/EC2"
  period              = var.alarm_period
  statistic           = var.alarm_statistic
  threshold           = var.alarm_threshold

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.asg_policy.arn}"]
}