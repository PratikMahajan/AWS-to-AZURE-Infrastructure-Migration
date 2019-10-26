data "aws_ami" "centos" {
  most_recent = true
  owners = ["${var.aws_account_id}"]
}


resource "aws_instance" "webec2" {
  ami                     = data.aws_ami.centos.id
  instance_type           = var.ec2_instance_type
  disable_api_termination = var.ec2_termination_disable

  vpc_security_group_ids  = var.aws_ec2_security_group
  subnet_id               = var.aws_ec2_subnet_id

  iam_instance_profile    = var.iam_instance_profile
  ebs_block_device {
    device_name           = var.ebs_block_name

    volume_type           = var.ebs_volume_type
    volume_size           = var.ebs_volume_size
    delete_on_termination = var.ebs_delete_on_termination
  }

  tags = {
    Name = "${var.env}-${var.ec2_instance_name}"
  }
}