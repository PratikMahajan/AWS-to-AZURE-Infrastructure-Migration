output "CodeDeployEC2ServiceRole" {
  value = aws_iam_role.CodeDeployEC2ServiceRole.name
}

output "CodeDeployEC2ServiceRoleInstance" {
  value = aws_iam_instance_profile.CodeDeployEC2ServiceRoleInstance.name
}