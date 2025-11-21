variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = null
}

variable "vnet_subnet_id" {
  description = "Subnet ID for the AKS cluster"
  type        = string
}

variable "service_cidr" {
  description = "Service CIDR for the AKS cluster"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "DNS service IP for the AKS cluster"
  type        = string
  default     = "10.0.0.10"
}

variable "tags" {
  description = "Tags for the AKS cluster"
  type        = map(string)
  default     = {}
}

# Default Node Pool
variable "default_node_pool" {
  description = "Configuration for the default node pool"
  type = object({
    name                  = string
    vm_size               = string
    auto_scaling_enabled  = bool
    node_count            = number
    min_count             = number
    max_count             = number
  })
}


variable "default_node_pool_availability_zones" {
  description = "Availability Zones for the default/system node pool (e.g., [\"1\"], [\"1\", \"2\"], or empty to let Azure decide)"
  type        = list(string)
  default     = []
}

# Additional Node Pools
variable "additional_node_pools" {
  description = "Configuration for additional node pools"
  type = map(object({
    vm_size               = string
    auto_scaling_enabled  = bool
    node_count            = number
    min_count             = number
    max_count             = number
    zones                = optional(list(string))
  }))
  default = {}
}


variable "enable_accelerated_networking" {
  description = "Enable Accelerated Networking for AKS node pools"
  type        = bool
  default     = true
}

variable "os_disk_type" {
  description = "OS disk type for AKS nodes (Ephemeral or Managed)"
  type        = string
  default     = "Ephemeral"
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = 100
}
