# --- Resource Group handling ---
variable "create_rg" {
  description = "If true, this root will create the Resource Group; if false, it assumes the RG already exists."
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "Name of the existing Resource Group (or the RG to create when create_rg = true)"
  type        = string
}

variable "location" {
  description = "Azure region (e.g., westeurope, eastus)"
  type        = string
  default     = "westeurope"
}

# --- SQL logical server + database names ---
variable "server_name" {
  description = "Base name for the SQL logical server (must be globally unique if not using suffix)"
  type        = string
}

variable "use_random_suffix" {
  description = "Append a small random suffix to server_name to help ensure global uniqueness"
  type        = bool
  default     = true
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

# --- Admin credentials ---
variable "administrator_login" {
  description = "SQL admin login (not 'sa')"
  type        = string
  default     = "sqladminuser"
}

variable "administrator_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}

# --- Public networking + firewall options ---
variable "public_network_access_enabled" {
  description = "Enable public network access to the SQL server (set false for Private Endpoint only)"
  type        = bool
  default     = false
}

variable "allowed_ip_ranges" {
  description = "Public CIDRs allowed in the server firewall (e.g., [\"203.0.113.10/32\"]). Ignored if public access is disabled."
  type        = list(string)
  default     = []
}

variable "allow_azure_services" {
  description = "Allow 0.0.0.0 rule (Azure services) in the server firewall. Ignored if public access is disabled."
  type        = bool
  default     = false
}

# --- Serverless configuration ---
variable "sku_name" {
  description = "Serverless SKU (e.g., GP_S_Gen5_1). Last number = max vCores"
  type        = string
  default     = "GP_S_Gen5_1"
}

variable "min_capacity" {
  description = "Minimum vCores while resumed (serverless). Lowest allowed is 0.25"
  type        = number
  default     = 0.25
}

variable "auto_pause_delay_in_minutes" {
  description = "Idle minutes before auto-pause (serverless). Min 5, max 1440"
  type        = number
  default     = 5
}

variable "max_size_gb" {
  description = "Max DB size in GB (free offer includes up to 32 GB per DB)"
  type        = number
  default     = 32
}

# --- Free offer flags (AzAPI patch inside module) ---
variable "apply_free_offer" {
  description = "Apply the Azure SQL free-offer flags (useFreeLimit=true) via AzAPI in the module"
  type        = bool
  default     = true
}

variable "free_limit_exhaustion_behavior" {
  description = "When monthly free limits are exhausted: 'AutoPause' (recommended) or 'Continue'"
  type        = string
  default     = "AutoPause"
  validation {
    condition     = contains(["AutoPause", "Continue"], var.free_limit_exhaustion_behavior)
    error_message = "free_limit_exhaustion_behavior must be 'AutoPause' or 'Continue'."
  }
}

# --- Tags ---
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "init_script_path" {
  description = "Local path to a T-SQL init script to run via sqlcmd after DB creation (relative to this folder). Leave empty to skip."
  type        = string
  default     = ""
}

variable "init_app_login" {
  description = "Value for $(APPLOGIN) used by init script."
  type        = string
  default     = ""
}

variable "init_app_password" {
  description = "Value for $(APPPASSWORD) used by init script."
  type        = string
  sensitive   = true
  default     = ""
}
