# Optional: suffix to help guarantee global uniqueness of the SQL server name
resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# ----- (Optional) Resource Group creation -----
# If your RG is already created by another module, set `create_rg = false`
# and supply `resource_group_name` directly.
resource "azurerm_resource_group" "rg" {
  count    = var.create_rg ? 1 : 0
  name     = var.create_rg ? var.resource_group_name : null
  location = var.create_rg ? var.location : null
  tags     = var.tags
}

# Choose the RG name to pass into the module
locals {
  effective_rg_name = var.create_rg ? azurerm_resource_group.rg[0].name : var.resource_group_name
}

module "sql_database" {
  # This path assumes ./sql-database and ./azuremodules are siblings
  source = "../azure-modules/sql-database"

  # --- Required inputs to the module ---
  resource_group_name = local.effective_rg_name
  location            = var.location

  # Use the provided server_name or auto-append a suffix for global uniqueness
  server_name   = var.use_random_suffix ? "${var.server_name}-${random_string.suffix.result}" : var.server_name
  database_name = var.database_name

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  # --- Public networking toggle + firewall (module already supports these) ---
  public_network_access_enabled = var.public_network_access_enabled
  allowed_ip_ranges             = var.allowed_ip_ranges
  allow_azure_services          = var.allow_azure_services

  # --- Serverless knobs (module exposes these) ---
  sku_name                    = var.sku_name                    # e.g., GP_S_Gen5_1
  min_capacity                = var.min_capacity                # e.g., 0.25
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes # e.g., 5
  max_size_gb                 = var.max_size_gb                 # e.g., 32

  # --- Free-offer flags via AzAPI (module applies preview API on your behalf) ---
  apply_free_offer               = var.apply_free_offer
  free_limit_exhaustion_behavior = var.free_limit_exhaustion_behavior # AutoPause or Continue

  tags = var.tags

  # ---- Init script (optional) ----
  init_script_path  = var.init_script_path
  init_app_login    = var.init_app_login
  init_app_password = var.init_app_password

}

# Helpful outputs (bubble up the most useful module outputs)
output "server_id" {
  value       = module.sql_database.server_id
  description = "SQL Server resource ID"
}

output "server_fqdn" {
  value       = module.sql_database.server_fqdn
  description = "SQL Server fully qualified domain name"
}

output "database_id" {
  value       = module.sql_database.database_id
  description = "Database resource ID"
}

output "database_name" {
  value       = module.sql_database.database_name
  description = "Database name"
}

output "connection_string_sql_auth" {
  value       = module.sql_database.connection_string_sql_auth
  description = "SQL connection string for admin login"
  sensitive   = true
}
