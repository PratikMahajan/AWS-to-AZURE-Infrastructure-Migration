/*
This is the 'main' Terraform file. It calls all of our modules in order to
bring up the whole infrastructure
*/
module "dev" {
  source = "environments/dev"
}

module "prod" {
  source = "environments/prod"
}