# Define the security group for public subnet
resource "aws_security_group" "sg_loadbalancer" {
  name = "loadbalancer"
  description = "Allow incoming HTTPS connections & SSH access for application"

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.aws_vpc_id

 tags = {
    Name = "loadbalancer"
  }

}
resource "aws_security_group" "sgapplication" {
  name        = "application"
  description = "Allow incoming connections from loadbalancer"

  ingress {
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port     = 80
    protocol      = "tcp"
    to_port       = 80
    security_groups  = [aws_security_group.sg_loadbalancer.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  vpc_id = var.aws_vpc_id

 tags = {
    Name = "application"
  }
}

# Define the security group for private subnet
resource "aws_security_group" "sgprivatedb"{
  name        = "database"
  description = "Allow traffic from private subnet for db access"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups  = [aws_security_group.sgapplication.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.aws_vpc_id

 tags = {
    Name = "database"
  }
}
