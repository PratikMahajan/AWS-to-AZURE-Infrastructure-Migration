resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.env}-${var.cosmos_acct_name}-${var.domain}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  enable_automatic_failover = true

  capabilities {
    name              = "EnableTable"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    prefix            = "${var.cosmos_acct_name}-customid"
    location          = var.resource_group_location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_table" "table" {
  name                = var.cosmos_tbl_name
  resource_group_name = var.resource_group_name 
  account_name        = "${azurerm_cosmosdb_account.db.name}"
}
