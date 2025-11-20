resource "azurerm_private_dns_zone" "dns_zone" {
  name                = var.zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "${var.zone_name}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "records" {
  for_each             = { for r in var.records : r.name => r }
  name                 = each.value.name
  zone_name            = azurerm_private_dns_zone.dns_zone.name
  resource_group_name  = var.resource_group_name
  ttl                  = 300
  records              = [each.value.ip]
}
