output "CodeDeployEC2ServiceRole" {
  value = aws_iam_role.CodeDeployEC2ServiceRole.name
}

output "CodeDeployEC2ServiceRole_arn" {
  value = aws_iam_role.CodeDeployEC2ServiceRole.arn
}

output "CodeDeployEC2ServiceRoleInstance" {
  value = aws_iam_instance_profile.CodeDeployEC2ServiceRoleInstance.name
}

output "CodeDeployEC2ServiceRoleInstance_arn" {
  value = aws_iam_instance_profile.CodeDeployEC2ServiceRoleInstance.arn
}


output "CodeDeployServiceRole_arn" {
  value = aws_iam_role.CodeDeployServiceRole.arn
}