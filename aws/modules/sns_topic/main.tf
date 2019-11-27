resource "aws_sns_topic" "create_topic" {
  name = var.sns_topic_name
}

