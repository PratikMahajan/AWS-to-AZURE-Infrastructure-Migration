output "ssl_cert_id" {
  value = azurerm_key_vault_certificate.add-ssl.id
}

output "ssl_cert_name" {
  value = azurerm_key_vault_certificate.add-ssl.name
}

output "ssl_cert_secret" {
  value = azurerm_key_vault_certificate.add-ssl.secret_id
}

output "mng_identity" {
  value = azurerm_user_assigned_identity.idd.id
}