
output "public_ip_id" {
  description = "ID of the Public IP"
  value       = azurerm_public_ip.this.id
}

output "public_ip_address" {
  description = "The actual Public IP address"
  value       = azurerm_public_ip.this.ip_address
}

output "fqdn" {
  description = "The FQDN if domain_name_label is set, otherwise null"
  value       = try(azurerm_public_ip.this.fqdn, null)
}
