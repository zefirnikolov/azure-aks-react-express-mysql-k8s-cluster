variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "location" {
  description = "The location of the Resource Group"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
