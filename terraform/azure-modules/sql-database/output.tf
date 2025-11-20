output "server_id" {
  description = "SQL Server resource ID"
  value       = azurerm_mssql_server.sql.id
}

output "server_fqdn" {
  description = "SQL Server fully qualified domain name"
  value       = azurerm_mssql_server.sql.fully_qualified_domain_name
}

output "database_id" {
  description = "Database resource ID"
  value       = local.database_id
}

output "database_name" {
  description = "Database name"
  value       = local.database_name
}

output "connection_string_sql_auth" {
  description = "SQL connection string for admin login"
  value       = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Database=${local.database_name};User ID=${var.administrator_login}@${var.server_name};Password=${var.administrator_password};Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
  sensitive   = true
}
