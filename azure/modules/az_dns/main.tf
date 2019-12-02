data "azurerm_dns_zone" "domain" {
  name                = var.domain_name
}

resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "A_record" {
  name                = "test"
  zone_name           = "${azurerm_dns_zone.dns_zone.name}"
  resource_group_name = var.resource_group_name	
  ttl                 = 300
  records             = ["127.0.0.1"]
}

