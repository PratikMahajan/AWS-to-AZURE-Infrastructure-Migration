output "ec2_tag_name" {
  value = "Name"
}

output "ec2_tag_value" {
  value = aws_instance.webec2.tags.Name
}