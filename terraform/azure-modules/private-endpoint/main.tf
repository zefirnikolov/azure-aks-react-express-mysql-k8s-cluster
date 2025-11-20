resource "azurerm_private_endpoint" "pe" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.name}-connection"
    private_connection_resource_id = var.resource_id
    is_manual_connection           = false
    subresource_names              = var.group_ids
  }

  tags = var.tags
}
