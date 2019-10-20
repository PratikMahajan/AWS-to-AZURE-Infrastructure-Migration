data "aws_ami" "centos" {
  most_recent = true
  owners = ["${var.aws_account_id}"]
}

resource "aws_instance" "webec2" {
  ami             = "${data.aws_ami.centos.id}"
  instance_type   = "t2.micro"

  vpc_security_group_ids = var.aws_ec2_security_group

  ebs_block_device {
    device_name = var.ebs_block_name

    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
    delete_on_termination = var.ebs_delete_on_termination
  }

  tags = {
    Name = "${var.env}-RecipeWebApp"
  }
}