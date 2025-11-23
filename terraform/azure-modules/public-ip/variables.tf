
variable "name" {
  description = "Name of the Public IP"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "domain_name_label" {
  description = "Optional DNS label for the Public IP"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for the Public IP"
  type        = map(string)
  default     = {}
}
