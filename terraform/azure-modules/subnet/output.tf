output "subnet_id" {
  description = "Subnet ID"
  value       = azurerm_subnet.subnet.id
}

output "subnet_name" {
  description = "Subnet Name"
  value       = azurerm_subnet.subnet.name
}
