output "resource_group_name" {
 value = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
 value = azurerm_resource_group.resource_group.id
}

output "resource_group_location" {
 value = azurerm_resource_group.resource_group.location
}

output "network_security_group_id" {
 value = azurerm_network_security_group.network_sg.id
}

output "subnet_id" {
 value = azurerm_subnet.subnet-1.id
}

output "public_ip_address_id" {
 value = azurerm_public_ip.public_ip.id
}
