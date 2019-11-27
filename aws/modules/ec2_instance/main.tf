data "aws_ami" "centos" {
  most_recent = true
  owners = ["${var.aws_account_id}"]
}

// AWS INSTANCE WITHOUT AUTOSCALING
resource "aws_instance" "webec2" {
  ami                     = data.aws_ami.centos.id
  instance_type           = var.ec2_instance_type
  disable_api_termination = var.ec2_termination_disable

  vpc_security_group_ids  = var.aws_ec2_security_group
  subnet_id               = var.aws_ec2_subnet_id

  key_name                = var.aws_key_pair_name
  iam_instance_profile    = var.iam_instance_profile

  user_data = <<EOF
#! /bin/bash
read -d '' data <<DTA
DB_USER=${var.DB_USER}
DB_PASSWORD=${var.DB_PASSWORD}
DATABASE_NAME=${var.DATABASE_NAME}
DB_HOST=${var.DB_HOST}
RECIPE_S3=${var.RECIPE_S3}
AWS_REGION=${var.AWS_REGION}
AWS_DEFAULT_REGION=${var.AWS_REGION}
AWS_ACCESS_KEY_ID=${var.AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${var.AWS_SECRET_ACCESS_KEY}
DTA

sudo echo "$data" >> /etc/environment
source /etc/environment
EOF

  ebs_block_device {
    device_name           = var.ebs_block_name

    volume_type           = var.ebs_volume_type
    volume_size           = var.ebs_volume_size
    delete_on_termination = var.ebs_delete_on_termination
  }

  tags = {
    Name = "${var.ec2_instance_name}"
    ENV  = var.env

  }
}