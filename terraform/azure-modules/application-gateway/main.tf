resource "azurerm_application_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.capacity
  }

  waf_configuration {
    enabled          = var.waf_enabled
    firewall_mode    = var.waf_mode
    rule_set_type    = var.waf_rule_set_type
    rule_set_version = var.waf_rule_set_version
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = var.public_ip_id
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.key
      port = frontend_port.value
    }
  }

  ssl_certificate {
    name     = var.ssl_cert_name
    data     = filebase64(var.pfx_path)
    password = var.pfx_password
  }

  # Listeners
  http_listener {
    name                           = var.http_listener_name
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = var.http_port_name
    protocol                       = "Http"
  }

  http_listener {
    name                           = var.https_listener_name
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = var.https_port_name
    protocol                       = "Https"
    ssl_certificate_name           = var.ssl_cert_name
  }

  # Redirect HTTP -> HTTPS
  redirect_configuration {
    name                 = var.redirect_name
    redirect_type        = "Permanent"
    target_listener_name = var.https_listener_name
    include_path         = true
    include_query_string = true
  }

  request_routing_rule {
    name                        = var.http_redirect_rule_name
    rule_type                   = "Basic"
    http_listener_name          = var.http_listener_name
    redirect_configuration_name = var.redirect_name
    priority                    = 100
  }

  backend_address_pool {
    name         = var.backend_pool_name
    ip_addresses = [var.backend_ip]
  }

  backend_http_settings {
    name                                  = var.backend_http_settings_name
    port                                  = var.backend_port
    protocol                              = var.backend_protocol
    request_timeout                       = var.backend_timeout
    cookie_based_affinity                 = "Disabled"
    host_name                             = var.backend_host_name   # default to "www.sredemo.app"
    pick_host_name_from_backend_address   = false
    probe_name                            = "custom-probe"
  }

  probe {
    name                                      = "custom-probe"
    protocol                                  = "Https"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }

  # HTTPS → backend
  request_routing_rule {
    name                       = var.https_backend_rule_name
    rule_type                  = "Basic"
    http_listener_name         = var.https_listener_name
    backend_address_pool_name  = var.backend_pool_name
    backend_http_settings_name = var.backend_http_settings_name
    priority                   = 200
  }

  tags = var.tags
}
