resource "azurerm_eventgrid_topic" "example" {
  name                = var.topic
  location            = var.resource_group_location 
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.env 
  }
}
