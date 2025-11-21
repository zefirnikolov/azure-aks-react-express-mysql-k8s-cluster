# ============================================ #
# RESOURCE GROUP MODULE                        #
# ============================================ #
module "resource_group" {
  source              = "../azure-modules/resource-group"
  resource_group_name = local.rg_name
  location            = local.location
  tags                = local.default_tags
}

# ============================================ #
# VNET MODULE                                  #
# ============================================ #
module "vnet" {
  source              = "../azure-modules/vnet"
  vnet_name           = local.vnet_name
  location            = local.location
  resource_group_name = local.rg_name
  address_space       = local.vnet_address_space
  tags                = local.default_tags
  depends_on          = [module.resource_group]
}

# ============================================ #
# SUBNET MODULES                               #
# ============================================ #
module "aks_subnet" {
  source                = "../azure-modules/subnet"
  subnet_name           = local.aks_subnet_name
  resource_group_name   = local.rg_name
  vnet_name             = local.vnet_name
  subnet_address_prefix = [local.aks_subnet_address_prefix]
  depends_on            = [module.vnet]
}

module "app_subnet" {
  source                = "../azure-modules/subnet"
  subnet_name           = local.app_subnet_name
  resource_group_name   = local.rg_name
  vnet_name             = local.vnet_name
  subnet_address_prefix = [local.app_subnet_address_prefix]
  depends_on            = [module.vnet]
}

# ============================================ #
# Azure SQL DB MODULE                          #
# ============================================ #
module "sql_database" {
  source                           = "../azure-modules/sql-database"
  resource_group_name             = local.rg_name
  location                        = local.location
  server_name                     = local.server_name
  database_name                   = local.database_name
  administrator_login             = local.administrator_login
  administrator_password          = local.administrator_password
  public_network_access_enabled   = local.public_network_access_enabled
  allowed_ip_ranges               = local.allowed_ip_ranges
  allow_azure_services            = local.allow_azure_services
  sku_name                        = local.sku_name
  min_capacity                    = local.min_capacity
  auto_pause_delay_in_minutes     = local.auto_pause_delay_in_minutes
  max_size_gb                     = local.max_size_gb
  apply_free_offer                = local.apply_free_offer
  free_limit_exhaustion_behavior  = local.free_limit_exhaustion_behavior
  tags                            = local.tags
  init_script_path                = local.init_script_path
  init_app_login                  = local.init_app_login
  init_app_password               = local.init_app_password
  depends_on                      = [module.app_subnet]
}


# ============================================ #
# PRIVATE ENDPOINT MODULE                      #
# ============================================ #
module "sql_private_endpoint" {
  source              = "../azure-modules/private-endpoint"
  name                = local.private_endpoint_name
  location            = local.location
  resource_group_name = local.rg_name
  subnet_id           = module.app_subnet.subnet_id
  resource_id         = module.sql_database.server_id
  group_ids           = ["sqlServer"]
  tags                = local.tags
  depends_on          = [module.sql_database]
}

# ============================================ #
# PRIVATE DNS ZONE MODULE                      #
# ============================================ #
module "private_dns_zone" {
  source              = "../azure-modules/private-dns-zone"
  zone_name           = local.private_dns_zone_name
  resource_group_name = local.rg_name
  vnet_id             = module.vnet.vnet_id
  records = [
    {
      name = local.server_name
      ip   = module.sql_private_endpoint.private_ip # Actually, use private IP from PE NIC
    }
  ]
  depends_on = [module.sql_private_endpoint]
}

# ============================================ #
# AKS MODULE                                   #
# ============================================ #
module "aks" {
  source                        = "../azure-modules/aks"
  cluster_name                  = local.aks_cluster_name
  location                      = local.location
  resource_group_name           = local.rg_name
  dns_prefix                    = local.aks_dns_prefix
  kubernetes_version            = local.aks_kubernetes_version
  vnet_subnet_id                = module.aks_subnet.subnet_id
  service_cidr                  = local.aks_service_cidr
  dns_service_ip                = local.aks_dns_service_ip
  tags                          = local.default_tags

  default_node_pool             = local.aks_default_node_pool
  default_node_pool_availability_zones = local.aks_default_pool_zones
  # additional_node_pools         = local.additional_node_pools

  enable_accelerated_networking = local.aks_enable_accelerated_networking
  os_disk_type                  = local.aks_os_disk_type
  os_disk_size_gb               = local.aks_os_disk_size_gb

  depends_on                     = [module.private_dns_zone]
}

# ============================================ #
# HELM MODULE                                  #
# ============================================ #
module "helm" {
  source    = "../azure-modules/helm"
  namespace = "webshop" # or any namespace you want
  releases  = local.helm_releases

  depends_on = [module.aks]
}
