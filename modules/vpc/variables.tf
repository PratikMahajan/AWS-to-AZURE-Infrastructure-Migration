variable "env" {}

variable "aws_region" {
  type        = string
  description = "Region for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "NAME for the VPC"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
}

variable "subnet1_name" {
  type        = string
  description = "NAME for the subnet1"
}
variable "subnet1_az" {
  type        = string
  description = "AZ for the subnet1"
}
variable "subnet1_cidr" {
  type        = string
  description = "CIDR for the subnet1"
}

variable "subnet2_name" {
  type        = string
  description = "NAME for the subnet2"
}
variable "subnet2_az" {
  type        = string
  description = "AZ for the subnet2"
}
variable "subnet2_cidr" {
  type        = string
  description = "CIDR for the subnet2"
}

variable "subnet3_name" {
  type        = string
  description = "NAME for the subnet3"
}
variable "subnet3_az" {
  type        = string
  description = "AZ for the subnet3"
}
variable "subnet3_cidr" {
  type        = string
  description = "CIDR for the subnet3"
}
