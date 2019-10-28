resource "aws_iam_role" "CodeDeployEC2ServiceRole" {
  name = "CodeDeployEC2ServiceRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "aws_iam_ec2_kms_attach" {
  role       = "${aws_iam_role.CodeDeployEC2ServiceRole.name}"
  policy_arn = var.aws_CodeDeploy-EC2-S3_KMS_policy
}

resource "aws_iam_role_policy_attachment" "aws_iam_role_ec2_attach" {
  role       = "${aws_iam_role.CodeDeployEC2ServiceRole.name}"
  policy_arn = var.aws_CodeDeploy-EC2-S3_policy
}

resource "aws_iam_instance_profile" "CodeDeployEC2ServiceRoleInstance" {
  name  = "CodeDeployEC2ServiceRoleInstance"
  role  = "${aws_iam_role.CodeDeployEC2ServiceRole.name}"
}


resource "aws_iam_role" "CodeDeployServiceRole" {
  name = "CodeDeployServiceRole"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "CircleCI-Code-Deploy" {
  role        = "${aws_iam_role.CodeDeployServiceRole.name}"
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
