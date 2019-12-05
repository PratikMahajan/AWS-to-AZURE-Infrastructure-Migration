data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "idd" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  name = "ssl-mng-idt"
}

resource "azurerm_key_vault" "key_vault" {
  name                        = "${var.env}-key-vault-${var.domain}"
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenet_id
    object_id = azurerm_user_assigned_identity.idd.principal_id

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]

    storage_permissions = [
      "delete",
      "deletesas",
      "recover",
      "restore",
      "get",
      "getsas",
      "list",
      "listsas"
    ]
  }

  access_policy {
    tenant_id = var.tenet_id
    object_id = var.sp_object_id

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]

    storage_permissions = [
      "delete",
      "deletesas",
      "recover",
      "restore",
      "get",
      "getsas",
      "list",
      "listsas"
    ]
  }
  tags = {
    env = var.env
  }
}


resource "azurerm_key_vault_certificate" "add-ssl" {
  provisioner "local-exec" {
    command = "az resource update --id ${azurerm_key_vault.key_vault.id} --set properties.enableSoftDelete=true"
  }

  name         = "imported-cert"
  key_vault_id = azurerm_key_vault.key_vault.id

  certificate {
    contents = filebase64("${var.cert_path}")
    password = var.cert_password
  }

  certificate_policy {
    issuer_parameters {
      name = var.cert_issuer_name
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}