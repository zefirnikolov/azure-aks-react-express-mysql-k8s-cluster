resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  node_resource_group = "${var.resource_group_name}-nodes"

  default_node_pool {
    name                  = var.default_node_pool.name
    vm_size               = var.default_node_pool.vm_size
    auto_scaling_enabled  = var.default_node_pool.auto_scaling_enabled
    node_count            = var.default_node_pool.node_count
    min_count             = var.default_node_pool.min_count
    max_count             = var.default_node_pool.max_count
    vnet_subnet_id        = var.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = var.service_cidr
    dns_service_ip = var.dns_service_ip
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "additional_node_pools" {
  for_each = var.additional_node_pools

  name                    = each.key
  kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks.id
  vm_size                 = each.value.vm_size
  auto_scaling_enabled    = each.value.auto_scaling_enabled
  node_count              = each.value.node_count
  min_count               = each.value.min_count
  max_count               = each.value.max_count
  vnet_subnet_id          = var.vnet_subnet_id

  tags = var.tags
}
