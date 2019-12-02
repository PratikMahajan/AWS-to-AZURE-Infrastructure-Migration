data "azurerm_image" "custom" {
  name                = "${var.custom_image_name}"
  resource_group_name = "${var.custom_image_resource_group_name}"
}

resource "azurerm_resource_group" "resource_group" {
    name     = var.resource_group_name
    location = var.location
}

resource "azurerm_virtual_network" "virtual_network" {
    name                = "VNet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.resource_group.location
    resource_group_name = azurerm_resource_group.resource_group.name
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "VMsubnet"
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "public_ip" {
    name                         = "PublicIP"
    location                     = azurerm_resource_group.resource_group.location
    resource_group_name          = azurerm_resource_group.resource_group.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
    name                = "NetworkSecurityGroup"
    location            = azurerm_resource_group.resource_group.location
    resource_group_name = azurerm_resource_group.resource_group.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "nic" {
    name                        = "NIC"
    location                    = azurerm_resource_group.resource_group.location
    resource_group_name         = azurerm_resource_group.resource_group.name
    network_security_group_id   = azurerm_network_security_group.nsg.id

    ip_configuration {
        name                          = "NicConfiguration"
        subnet_id                     = "${azurerm_subnet.vm_subnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.public_ip.id}"
    }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "VM123"
  location              = "${azurerm_resource_group.resource_group.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  
  storage_image_reference {
    id = "${data.azurerm_image.custom.id}"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}

