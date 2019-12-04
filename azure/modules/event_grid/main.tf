resource "azurerm_eventgrid_topic" "topic" {
  name                = "${var.env}-${var.topic}-${var.domain_name}"
  location            = var.resource_group_location 
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.env 
  }
}
