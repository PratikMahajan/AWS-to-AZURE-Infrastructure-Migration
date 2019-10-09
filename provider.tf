# Define AWS as our provider
provider "aws" {
  region = "${var.aws_region}"
  shared_credentials_file = "~/.aws/credentials"
  profile = "${var.aws_profile}"
}
