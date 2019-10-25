output "aws_circleci-ec2-ami_policy" {
  value = aws_iam_policy.circleci-ec2-ami.arn
}

output "aws_CodeDeploy-EC2-S3_policy" {
  value = aws_iam_policy.CodeDeploy-EC2-S3.arn
}

output "aws_CircleCI-Upload-To-S3_policy"{
  value = aws_iam_policy.CircleCI-Upload-To-S3.arn
}

output "aws_CircleCI-Code-Deploy_policy"{
  value = aws_iam_policy.CircleCI-Code-Deploy.arn
}