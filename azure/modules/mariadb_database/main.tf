resource "azurerm_mariadb_server" "maria_db_server" {
  name                = "${var.env}-mariadb-svr-${var.domain}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  sku {
    name     = "B_Gen5_${var.maria_db_server_capacity}"
    capacity = var.maria_db_server_capacity
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = var.maria_db_storage_mb
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = var.mariadb_admin_login_username
  administrator_login_password = var.mariadb_admin_login_password
  version                      = "10.2"
  ssl_enforcement              = var.mariadb_ssl_enforcement
}

resource "azurerm_mariadb_database" "database" {
  name                = var.mariadb_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mariadb_server.maria_db_server.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}