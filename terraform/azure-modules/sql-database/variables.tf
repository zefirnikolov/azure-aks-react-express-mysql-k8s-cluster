variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the SQL resources"
  type        = string
}

variable "server_name" {
  description = "Globally-unique SQL logical server name (no underscores, 1-63 chars)"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "administrator_login" {
  description = "SQL admin login name (not 'sa')"
  type        = string
  default     = "sqladminuser"
}

variable "administrator_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access to the SQL server (set false if using Private Endpoint)"
  type        = bool
  default     = true
}

variable "allowed_ip_ranges" {
  description = "Public CIDR(s) to allow through SQL firewall (e.g. [\"203.0.113.10/32\"]). Empty to skip."
  type        = list(string)
  default     = []
}

variable "allow_azure_services" {
  description = "Allow Azure services and resources to access this server (0.0.0.0 firewall rule)"
  type        = bool
  default     = false
}

# -------- Serverless configuration --------
variable "sku_name" {
  description = "Serverless SKU (e.g., GP_S_Gen5_1). The last number denotes max vCores."
  type        = string
  default     = "GP_S_Gen5_1"
}

variable "min_capacity" {
  description = "Minimum vCores while resumed (serverless only). Lowest allowed is 0.25."
  type        = number
  default     = 0.25
}

variable "auto_pause_delay_in_minutes" {
  description = "Idle minutes before auto-pause (serverless only). Min 5, max 1440."
  type        = number
  default     = 5
}

variable "max_size_gb" {
  description = "Max size of the database (GB). Free offer includes up to 32 GB per DB."
  type        = number
  default     = 32
}

# -------- Free offer flags (via AzAPI) --------
variable "apply_free_offer" {
  description = "Apply the free-offer flags (useFreeLimit=true) using AzAPI"
  type        = bool
  default     = true
}

variable "free_limit_exhaustion_behavior" {
  description = "When monthly free limits are exhausted: 'AutoPause' (recommended) or 'Continue'."
  type        = string
  default     = "AutoPause"
  validation {
    condition     = contains(["AutoPause", "Continue"], var.free_limit_exhaustion_behavior)
    error_message = "free_limit_exhaustion_behavior must be 'AutoPause' or 'Continue'."
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# --- Initializer (optional) ---
variable "init_script_path" {
  description = "Local path to a T-SQL init script to run via sqlcmd after DB creation. Leave empty to skip."
  type        = string
  default     = ""
}

variable "init_app_login" {
  description = "Value to pass as $(APPLOGIN) to the init script (if provided)."
  type        = string
  default     = ""
}

variable "init_app_password" {
  description = "Value to pass as $(APPPASSWORD) to the init script (if provided)."
  type        = string
  sensitive   = true
  default     = ""
}

# You already have database_name; we’ll reuse it as $(DBNAME).
