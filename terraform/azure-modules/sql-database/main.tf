resource "azurerm_mssql_server" "sql" {
  name                          = var.server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_password
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  express_vulnerability_assessment_enabled = false
}

resource "azurerm_mssql_firewall_rule" "allowed_ips" {
  for_each  = toset(var.allowed_ip_ranges)
  name      = "allow-${replace(each.value, "/", "-")}"
  server_id = azurerm_mssql_server.sql.id

  start_ip_address = try(cidrhost(each.value, 0), each.value)
  end_ip_address   = try(cidrhost(each.value, -1), each.value)
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  count            = var.allow_azure_services ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azapi_resource" "db_free" {
  count = var.apply_free_offer ? 1 : 0

  type      = "Microsoft.Sql/servers/databases@2023-08-01-preview"
  name      = var.database_name
  parent_id = azurerm_mssql_server.sql.id
  location  = var.location

  body = jsonencode({
    sku = {
      name = var.sku_name
    }
    properties = {
      minCapacity                 = var.min_capacity
      autoPauseDelay              = var.auto_pause_delay_in_minutes
      maxSizeBytes                = var.max_size_gb * 1024 * 1024 * 1024
      useFreeLimit                = true
      freeLimitExhaustionBehavior = var.free_limit_exhaustion_behavior
    }
  })

  tags = var.tags
}

resource "azurerm_mssql_database" "db_paid" {
  count       = var.apply_free_offer ? 0 : 1
  name        = var.database_name
  server_id   = azurerm_mssql_server.sql.id
  max_size_gb = var.max_size_gb
  sku_name    = var.sku_name
  tags        = var.tags


  min_capacity                = var.min_capacity                
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
}

locals {
  database_id   = var.apply_free_offer ? azapi_resource.db_free[0].id : azurerm_mssql_database.db_paid[0].id
  database_name = var.database_name
}


# ----------------------------
# Optional init script (requires `sqlcmd` on the runner)
# ----------------------------
resource "null_resource" "db_init" {
  # NOTE: use trimspace(), not trim()
  count = length(trimspace(var.init_script_path)) > 0 ? 1 : 0

  triggers = {
    script_sha1  = filesha1(var.init_script_path)
    database_id  = local.database_id
    free_offer   = var.apply_free_offer ? "on" : "off"
    server_fqdn  = azurerm_mssql_server.sql.fully_qualified_domain_name
  }


  provisioner "local-exec" {
    command = <<-EOT
      sqlcmd \
        -S ${azurerm_mssql_server.sql.fully_qualified_domain_name} \
        -U ${var.administrator_login} \
        -P ${var.administrator_password} \
        -d ${var.database_name} -b -l 60 \
        -i "${var.init_script_path}" \
        -v DBNAME="${var.database_name}" APPLOGIN="${var.init_app_login}" APPPASSWORD="${var.init_app_password}"
    EOT
    interpreter = ["/bin/bash", "-c"]
  }


  depends_on = [
    azapi_resource.db_free,
    azurerm_mssql_database.db_paid
  ]
}
