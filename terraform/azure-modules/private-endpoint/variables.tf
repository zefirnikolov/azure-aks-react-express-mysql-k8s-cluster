variable "name" {
  description = "Name of the Private Endpoint"
  type        = string
}

variable "location" {
  description = "Azure region for the Private Endpoint"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where the Private Endpoint will be created"
  type        = string
}

variable "resource_id" {
  description = "ID of the resource to connect via Private Endpoint"
  type        = string
}

variable "group_ids" {
  description = "List of subresource names (e.g., ['sqlServer'])"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the Private Endpoint"
  type        = map(string)
  default     = {}
}
