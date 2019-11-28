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

module "storage_account" {
  source                  = "../../modules/storage_account"
  resource_group_location = module.virtual_network.resource_group_location
  resource_group_name     = module.virtual_network.resource_group_name
  storage_account_name    = "${var.env}${var.storage_account_name}"
}

module "storage_blob_webapp" {
  source                  = "../../modules/blob_storage"
  storage_account_id      = module.storage_account.storage_account_id
  storage_account_name    = module.storage_account.storage_account_name
  storage_container_name  = "webapp"
}