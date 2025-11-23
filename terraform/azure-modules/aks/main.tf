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
    max_pods              = var.default_node_pool.max_pods
    vnet_subnet_id        = var.vnet_subnet_id
    os_disk_type          = var.os_disk_type
    os_disk_size_gb       = var.os_disk_size_gb
    zones                 = var.default_node_pool_availability_zones
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    # network_plugin_mode = "overlay"
    network_plugin   = "azure"
    service_cidr     = var.service_cidr
    dns_service_ip   = var.dns_service_ip
    load_balancer_sku = "standard"
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "additional_node_pools" {
  for_each              = var.additional_node_pools
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = each.value.vm_size
  auto_scaling_enabled  = each.value.auto_scaling_enabled
  node_count            = each.value.node_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  max_pods              = each.value.max_pods
  vnet_subnet_id        = var.vnet_subnet_id
  os_disk_type          = var.os_disk_type
  os_disk_size_gb       = var.os_disk_size_gb
  tags                  = var.tags
  zones                 = try(each.value.zones, null)
}

resource "azurerm_role_assignment" "aks_network_contributor_subnet" {
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"

  # This will be unknown during plan on first create, and becomes known at apply.
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}
