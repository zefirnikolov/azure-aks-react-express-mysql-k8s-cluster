variable "name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "location" {
  description = "Azure region where the Application Gateway will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the dedicated subnet for the Application Gateway"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the Public IP to attach to the Application Gateway"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Application Gateway (e.g., WAF_v2)"
  type        = string
  default     = "WAF_v2"
}

variable "sku_tier" {
  description = "SKU tier for the Application Gateway (e.g., WAF_v2)"
  type        = string
  default     = "WAF_v2"
}

variable "capacity" {
  description = "Instance capacity for the Application Gateway"
  type        = number
  default     = 2
}

variable "waf_enabled" {
  description = "Enable Web Application Firewall"
  type        = bool
  default     = true
}

variable "waf_mode" {
  description = "WAF mode: Detection or Prevention"
  type        = string
  default     = "Prevention"
}

variable "waf_rule_set_type" {
  description = "WAF rule set type (e.g., OWASP)"
  type        = string
  default     = "OWASP"
}

variable "waf_rule_set_version" {
  description = "WAF rule set version (e.g., 3.2)"
  type        = string
  default     = "3.2"
}

variable "frontend_ports" {
  description = "Map of frontend ports for the Application Gateway"
  type        = map(number)
  default     = {
    port-80  = 80
    port-443 = 443
  }
}

variable "ssl_cert_name" {
  description = "Name of the SSL certificate in the Application Gateway"
  type        = string
}

variable "pfx_path" {
  description = "Path to the .pfx certificate file"
  type        = string
}

variable "pfx_password" {
  description = "Password for the .pfx certificate"
  type        = string
  sensitive   = true
}

variable "http_listener_name" {
  description = "Name of the HTTP listener"
  type        = string
  default     = "listener-http"
}

variable "https_listener_name" {
  description = "Name of the HTTPS listener"
  type        = string
  default     = "listener-https"
}

variable "http_port_name" {
  description = "Name of the frontend port for HTTP"
  type        = string
  default     = "port-80"
}

variable "https_port_name" {
  description = "Name of the frontend port for HTTPS"
  type        = string
  default     = "port-443"
}

variable "redirect_name" {
  description = "Name of the redirect configuration"
  type        = string
  default     = "redirect-to-https"
}

variable "http_redirect_rule_name" {
  description = "Name of the HTTP redirect rule"
  type        = string
  default     = "http-to-https"
}

variable "backend_pool_name" {
  description = "Name of the backend pool"
  type        = string
  default     = "backend-pool"
}

variable "backend_ip" {
  description = "IP address of the backend (e.g., Traefik internal LB)"
  type        = string
}

variable "backend_http_settings_name" {
  description = "Name of the backend HTTP settings"
  type        = string
  default     = "backend-settings"
}

variable "backend_port" {
  description = "Port for backend communication"
  type        = number
  default     = 443
}

variable "backend_protocol" {
  description = "Protocol for backend communication (Http or Https)"
  type        = string
  default     = "Https"
}

variable "backend_timeout" {
  description = "Timeout for backend requests in seconds"
  type        = number
  default     = 30
}

variable "https_backend_rule_name" {
  description = "Name of the HTTPS backend routing rule"
  type        = string
  default     = "https-to-backend"
}

variable "tags" {
  description = "Tags for the Application Gateway"
  type        = map(string)
  default     = {}
}

variable "backend_host_name" {
  description = "Host header to send to backend (Traefik ingress domain)"
  type        = string
  default     = "www.sredemo.app"
}
