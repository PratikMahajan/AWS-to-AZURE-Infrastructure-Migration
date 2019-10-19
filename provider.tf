# Define AWS as our provider
variable "aws_region" {}
variable "aws_profile" {}

provider "aws" {
  region = "${var.aws_region}"
  shared_credentials_file = "~/.aws/credentials"
  profile = "${var.aws_profile}"
}
