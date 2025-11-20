# ====================== #
# RESOURCE GROUP MODULE  #
# ====================== #
module "resource_group" {
  source = "../azure-modules/resource-group"

  resource_group_name = var.rg_name
  location            = var.location
  tags                = var.default_tags
}

# ====================== #
# VNET MODULE            #
# ====================== #
module "vnet" {
  source = "../azure-modules/vnet"

  vnet_name           = var.vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.vnet_address_space
  tags                = var.default_tags

  depends_on = [module.resource_group]
}

# ====================== #
# SUBNET MODULE          #
# ====================== #
module "aks_subnet" {
  source = "../azure-modules/subnet"

  subnet_name           = var.aks_subnet_name
  resource_group_name   = var.rg_name
  vnet_name             = var.vnet_name
  subnet_address_prefix = [var.aks_subnet_address_prefix]

  depends_on = [module.vnet]
}

module "app_subnet" {
  source = "../azure-modules/subnet"

  subnet_name           = var.app_subnet_name
  resource_group_name   = var.rg_name
  vnet_name             = var.vnet_name
  subnet_address_prefix = [var.app_subnet_address_prefix]

  depends_on = [module.vnet]
}
