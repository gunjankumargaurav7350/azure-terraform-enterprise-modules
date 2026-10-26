output "id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "The Name of the Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of Subnet Name to Subnet ID"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}
