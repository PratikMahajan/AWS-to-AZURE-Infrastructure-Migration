resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain_name_tld
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "A_record" {
  name                = var.dns_record_name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 60
  records             = var.records_array
}
