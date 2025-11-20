output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Virtual Network Name"
  value       = azurerm_virtual_network.vnet.name
}
