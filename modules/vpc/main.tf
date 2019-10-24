
# Define our VPC
resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

 tags = {
    Name = "${var.env}-${var.vpc_name}"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = var.subnet1_az
  map_public_ip_on_launch = true

 tags = {
    Name = "${var.env}-${var.subnet1_name}"
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
    Name = "${var.env}-${var.subnet3_name}"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id

 tags = {
    Name = "${var.env}-VPC-IGW"
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
    Name = "${var.env}-Public-Subnet-RT"
  }
}
# Assign the route table to the public Subnet
resource "aws_route_table_association" "subnet1" {
  subnet_id               = aws_subnet.public-subnet.id
  route_table_id          = aws_route_table.web-public-rt.id
}
resource "aws_route_table_association" "subnet2" {
  subnet_id       = aws_subnet.private-subnet1.id
  route_table_id  = aws_route_table.web-public-rt.id
}
resource "aws_route_table_association" "subnet3" {
  subnet_id       = aws_subnet.private-subnet2.id
  route_table_id  = aws_route_table.web-public-rt.id
}
