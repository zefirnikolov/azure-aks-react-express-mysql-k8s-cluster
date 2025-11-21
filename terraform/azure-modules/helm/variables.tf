variable "namespace" {
  description = "Default namespace for Helm releases"
  type        = string
  default     = "default"
}

variable "releases" {
  description = <<EOT
Map of Helm releases to install. Each key is the release name.
Fields:
  chart            - chart name or path
  repo             - Helm repo URL (optional)
  version          - chart version (optional)
  namespace        - namespace override (optional)
  values           - map(any) of values to apply (optional)
  create_namespace - bool (default true)
  timeout          - number of seconds to wait (default 600)
  atomic           - bool; rollback on failure (default true)
EOT
  type = map(object({
    chart            = string
    repo             = optional(string)
    version          = optional(string)
    namespace        = optional(string)
    values           = optional(map(any))
    create_namespace = optional(bool, true)
    timeout          = optional(number, 600)
    atomic           = optional(bool, true)
  }))
  default = {}
}
