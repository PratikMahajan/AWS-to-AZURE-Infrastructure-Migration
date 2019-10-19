
# Define our VPC
resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

 tags = {
    Name = var.vpc_name
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.subnet1_az

 tags = {
    Name = "${var.env}-var.subnet1_name"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.subnet2_az

 tags = {
    Name = "${var.env}-${var.subnet2_name}"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.subnet3_cidr
  availability_zone = var.subnet3_az

 tags = {
    Name = var.subnet3_name
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id

 tags = {
    Name = "VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

 tags = {
    Name = "Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "subnet1" {
  subnet_id       = aws_subnet.public-subnet.id
  route_table_id  = aws_route_table.web-public-rt.id
}
resource "aws_route_table_association" "subnet2" {
  subnet_id       = aws_subnet.private-subnet1.id
  route_table_id  = aws_route_table.web-public-rt.id
}
resource "aws_route_table_association" "subnet3" {
  subnet_id       = aws_subnet.private-subnet2.id
  route_table_id  = aws_route_table.web-public-rt.id
}

# Define the security group for public subnet
resource "aws_security_group" "sgpublic" {
  name        = "vpc_test_public"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port     = -1
    to_port       = -1
    protocol      = "icmp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    from_port     = 22
    to_port       = 22
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.default.id

 tags = {
    Name = "Public SG"
  }
}

# Define the security group for private subnet
resource "aws_security_group" "sgprivate"{
  name        = "sg_test_public"
  description = "Allow traffic from public subnet"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.subnet1_cidr]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.subnet1_cidr]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.subnet1_cidr]
  }

  vpc_id = aws_vpc.default.id

 tags = {
    Name = "Private SG"
  }
}
