resource "azurerm_storage_container" "storage_container" {
  name                  = var.storage_container_name
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "move_to_cold" {
  storage_account_id = var.storage_account_id

  rule {
    name    = "moveToCold"
    enabled = true
    filters {
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
      }
    }
  }
}