output "resource_group_name" {
 value = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
 value = azurerm_resource_group.resource_group.id
}

output "resource_group_location" {
 value = azurerm_resource_group.resource_group.location
}

output "db_subnet" {
 value = azurerm_subnet.subnet-3.id
}
