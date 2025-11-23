
variable "namespace" {
  description = "Namespace where the TLS secret will be created"
  type        = string
}

variable "tls_secret_name" {
  description = "Name of the Kubernetes TLS secret"
  type        = string
}

variable "tls_fullchain_path" {
  description = "Absolute path to fullchain.pem on the machine running Terraform"
  type        = string
  sensitive   = true
}

variable "tls_privkey_path" {
  description = "Absolute path to privkey.pem on the machine running Terraform"
  type        = string
  sensitive   = true
}
