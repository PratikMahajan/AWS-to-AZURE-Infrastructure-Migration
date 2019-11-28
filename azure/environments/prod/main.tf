provider "azurerm" {
  version = "=1.36.0"
}

module "virtual_network" {
  source        = "../../modules/virtual_network"
  env           = var.env
  location      = var.location
  subnet1_addr  = var.subnet1_addr
  subnet2_addr  = var.subnet2_addr
  subnet3_addr  = var.subnet3_addr
  vnet_addr     = var.vnet_addr
}