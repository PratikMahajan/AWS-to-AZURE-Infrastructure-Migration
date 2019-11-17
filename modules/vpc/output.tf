output "vpc_id" {
  value = aws_vpc.default.id
}

output "aws_subnet1_id"{
  value = aws_subnet.public-subnet.id
}

output "aws_subnet2_id"{
  value = aws_subnet.public-subnet2.id
}

output "aws_subnet3_id"{
  value = aws_subnet.private-subnet1.id
}

output "aws_subnet1_az"{
  value = aws_subnet.public-subnet.availability_zone
}