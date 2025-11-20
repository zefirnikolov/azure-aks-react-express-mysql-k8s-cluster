variable "zone_name" {
  description = "Name of the Private DNS Zone"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_id" {
  description = "ID of the Virtual Network to link with the DNS Zone"
  type        = string
}

variable "records" {
  description = "List of A records to create in the DNS Zone"
  type = list(object({
    name = string
    ip   = string
  }))
}
