variable "location" {
  description = "Azure location/region"
  type        = string
}

variable "rg_name" {
  description = "Resource Group name"
  type        = string
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  description = "VNet name"
  type        = string
}

variable "vnet_address_space" {
  description = "VNet address space"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "AKS subnet name"
  type        = string
}

variable "aks_subnet_address_prefix" {
  description = "AKS subnet address prefix (single CIDR)"
  type        = string
}

variable "app_subnet_name" {
  description = "App subnet name"
  type        = string
}

variable "app_subnet_address_prefix" {
  description = "App subnet address prefix (single CIDR)"
  type        = string
}
