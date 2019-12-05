output "app_gateway_ip" {
  value = azurerm_public_ip.app_gtway_public_ip.ip_address
}