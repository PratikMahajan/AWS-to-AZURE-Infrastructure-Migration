resource "azurerm_resource_group" "resource_group" {
  name     = "${var.env}-resources"
  location = "${var.location}"
}


resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.env}-network"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${azurerm_resource_group.resource_group.location}"
  address_space       = var.vnet_addr
}


resource "azurerm_subnet" "subnet-1" {
  name                 = "subnet-1"
  virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  address_prefix       = var.subnet1_addr
}

resource "azurerm_subnet" "subnet-2" {
  name                 = "subnet-2"
  virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  address_prefix       = var.subnet2_addr
}

resource "azurerm_subnet" "subnet-3" {
  name                 = "subnet-3"
  virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  address_prefix       = var.subnet3_addr
}