# Define the security group for public subnet
resource "aws_security_group" "sgpublic" {
  name        = "application"
  description = "Allow incoming HTTP connections & SSH access for application"

  ingress {
    from_port     = 80
    to_port       = 8080
    protocol      = "tcp"
  }

  ingress {
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
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
    security_groups  = [aws_security_group.sgpublic.id]
  }

  vpc_id = var.aws_vpc_id

 tags = {
    Name = "database"
  }
}