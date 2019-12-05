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
  lb_ip_dns_name = var.lb_ip_dns_name
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
  domain = var.domain_name
  env = var.env
}

module "event_grid" {
  source                  = "../../modules/event_grid"
  env                     = var.env
  resource_group_location = module.virtual_network.resource_group_location
  resource_group_name     = module.virtual_network.resource_group_name
  topic                   = var.topic
  domain_name = var.domain_name
}


module "storage_blob_function" {
  source                  = "../../modules/blob_storage"
  storage_account_id      = module.storage_account.storage_account_id
  storage_account_name    = module.storage_account.storage_account_name
  storage_container_name  = var.function_bolb_name
}

module "cosmos_db" {
  source                  = "../../modules/cosmos_db"
  cosmos_acct_name        = var.cosmos_acct_name
  cosmos_tbl_name         = var.cosmos_tbl_name
  failover_loc            = var.failover_loc
  resource_group_location = module.virtual_network.resource_group_location
  resource_group_name     = module.virtual_network.resource_group_name
  domain = var.domain_name
  env = var.env
}

module "function" {
  source                    = "../../modules/function"
  function_name             = var.function_name
  resource_group_location   = module.virtual_network.resource_group_location
  resource_group_name       = module.virtual_network.resource_group_name
  storage_connection_string = module.storage_account.storage_account_connection_string 
}


//module "key_vault" {
//  source = "../../modules/key_vault"
//  cert_issuer_name = var.cert_issuer_name
//  cert_password = var.cert_password
//  cert_path = var.cert_path
//  env = var.env
//  resource_group_location = module.virtual_network.resource_group_location
//  resource_group_name = module.virtual_network.resource_group_name
//  sp_object_id = var.sp_object_id
//  domain = var.domain_name
//  tenet_id = var.tenet_id
//}

module "loadbalancer" {
  source              = "../../modules/loadbalancer"
  admin_username      = "centos"
  env                 = var.env
  hostname            = var.hostname
  location            = module.virtual_network.resource_group_location
  resource_group_name = module.virtual_network.resource_group_name
  ssh_key_data        = var.ssh_key
  subnet_id           = module.virtual_network.subnet_id_1
  azure_public_ip     = module.virtual_network.public_ip
  image_name          = var.image_name
  resource_group_location = module.virtual_network.resource_group_location
  vm_decrease_threshold = var.vm_decrease_threshold
  vm_increase_threshold = var.vm_increase_threshold
  az_virtual_network_name = module.virtual_network.virtual_network_name
  subnet_id_appgateway = module.virtual_network.subnet_id_3
  cert_password = var.cert_password
  cert_path = var.cert_path
}

module "dns" {
  source = "../../modules/dns"
  dns_record_name = "a_record"
  domain_name_tld     = var.domain_name_tld
  records_array   = ["${module.loadbalancer.app_gateway_ip}"]
  resource_group_name = module.virtual_network.resource_group_name
}