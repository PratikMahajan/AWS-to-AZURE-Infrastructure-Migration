output "resource_group_name" {
 value = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
 value = azurerm_resource_group.resource_group.id
}

output "resource_group_location" {
 value = azurerm_resource_group.resource_group.location
}

output "subnet_id_1" {
 value = azurerm_subnet.subnet-1.id
}

output "public_ip" {
 value = azurerm_public_ip.public_ip.id
}

output "public_ip_address" {
 value = azurerm_public_ip.public_ip.ip_address
}
