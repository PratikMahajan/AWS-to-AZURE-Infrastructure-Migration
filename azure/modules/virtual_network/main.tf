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


# Route Table for Azure Virtual Network and Server Subnet
resource "azurerm_route_table" "azurt" {
  name                     = "AzfwRouteTable"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  disable_bgp_route_propagation = false

  route {
    name           = "AzfwDefaultRoute"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.4"
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_subnet_route_table_association" "subnet-1" {
  subnet_id      = azurerm_subnet.subnet-1.id
  route_table_id = azurerm_route_table.azurt.id
}

resource "azurerm_subnet_route_table_association" "subnet-2" {
  subnet_id      = azurerm_subnet.subnet-2.id
  route_table_id = azurerm_route_table.azurt.id
}


resource "azurerm_application_security_group" "application" {
  name                = "appsecuritygroup"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = {
    type = "application"
    environment = var.env
  }
}

resource "azurerm_application_security_group" "database" {
  name                = "DBsecuritygroup"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = {
    type = "database"
    environment = var.env
  }
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
  name                        = "port443"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.network_sg.name
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "443"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "port3306" {
  name                        = "port3306"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.network_sg.name
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "3306"
  destination_port_range      = "3306"
  source_application_security_group_ids       = ["${azurerm_application_security_group.application.id}"]
  destination_application_security_group_ids  = ["${azurerm_application_security_group.database.id}"]
}

resource "azurerm_subnet_network_security_group_association" "subnet1" {
  subnet_id                 = azurerm_subnet.subnet-1.id
  network_security_group_id = azurerm_network_security_group.network_sg.id
}

resource "azurerm_subnet_network_security_group_association" "subnet2" {
  subnet_id                 = azurerm_subnet.subnet-2.id
  network_security_group_id = azurerm_network_security_group.network_sg.id
}

//resource "azurerm_subnet_network_security_group_association" "subnet3" {
//  subnet_id                 = azurerm_subnet.subnet-3.id
//  network_security_group_id = azurerm_network_security_group.network_sg.id
//}


resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"
  domain_name_label   = var.lb_ip_dns_name

  tags = {
    environment = var.env
  }
}

