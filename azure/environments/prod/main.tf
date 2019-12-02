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

module "mariadb" {
  source                        = "../../modules/mariadb_database"
  maria_db_server_capacity      = var.maria_db_server_scale_capacity
  maria_db_storage_mb           = var.maria_db_storage_mb
  mariadb_admin_login_password  = var.mariadb_admin_login_password
  mariadb_admin_login_username  = var.mariadb_admin_login_username
  mariadb_name                  = var.mariadb_name
  mariadb_ssl_enforcement       = var.mariadb_ssl_enforcement
  resource_group_location       = module.virtual_network.resource_group_location
  resource_group_name           = module.virtual_network.resource_group_name
}

module "dns_a_record" {
  source	      = "../../modules/az_dns"
  domain_name         = var.domain_name
  resource_group_name = module.virtual_network.resource_group_name
}

