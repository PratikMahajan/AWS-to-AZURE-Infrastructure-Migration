resource "azurerm_sql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  version                      = var.sql_server_version
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_pass
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = "sql-vnet-rule"
  resource_group_name = var.resource_group_name
  server_name         = "${azurerm_sql_server.sqlserver.name}"
  subnet_id           = var.db_subnet
}

resource "azurerm_sql_database" "example" {
  name                = var.sql_db_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  server_name         = "${azurerm_sql_server.sqlserver.name}"

  tags = {
    environment = var.env
  }
}
