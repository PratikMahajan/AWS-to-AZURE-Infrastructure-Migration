resource "azurerm_resource_group" "resource_group" {
  name     = "${var.env}-resources"
  location = var.location
}


resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.env}-network"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  address_space       = var.vnet_addr
}


resource "azurerm_subnet" "subnet-1" {
  name                 = "subnet-1"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefix       = var.subnet1_addr
}

resource "azurerm_subnet" "subnet-2" {
  name                 = "subnet-2"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefix       = var.subnet2_addr
}

resource "azurerm_subnet" "subnet-3" {
  name                 = "subnet-3"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefix       = var.subnet3_addr
}



resource "azurerm_network_security_group" "network_sg" {
  name                = "${var.env}-nsg"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.network_sg.name
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = 22
  destination_port_range      = 22
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "port80" {
  name                        = "port80"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.network_sg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "port443" {
  name                        = "port80"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.network_sg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "443"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}