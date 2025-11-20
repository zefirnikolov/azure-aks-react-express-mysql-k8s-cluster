output "private_endpoint_id" {
  description = "ID of the Private Endpoint"
  value       = azurerm_private_endpoint.pe.id
}

output "private_ip" {
  description = "Private IP of the Private Endpoint"
  value       = azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address
}
