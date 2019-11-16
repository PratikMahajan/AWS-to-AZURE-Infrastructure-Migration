data "aws_ami" "centos" {
  most_recent   = true
  owners        = ["${var.aws_account_id}"]
}


resource "aws_launch_configuration" "asg_launch_config" {
  name                        = var.asg_launch_config_name
  image_id                    = data.aws_ami.centos.id
  instance_type               = var.instance_type

  security_group              = var.aws_ec2_security_group

  key_name                    = var.aws_key_pair_name
  iam_instance_profile        = var.iam_instance_profile

  associate_public_ip_address = var.public_ip_address

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


resource "aws_autoscaling_group" "asg" {
  name               = var.aws_asg_name
  availability_zones = var.availability_zones
  desired_capacity   = var.asg_desired_capacity
  max_size           = var.asg_max_size
  min_size           = var.asg_min_size
  force_delete       = var.asg_force_delete
  default_cool_down  = var.cooldown_period

  launch_configuration   = aws_launch_configuration.asg_launch_config.name
}