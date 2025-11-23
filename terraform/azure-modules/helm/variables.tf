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
  values           - arbitrary Helm values (optional)
  create_namespace - bool (default true)
  timeout          - number of seconds to wait (default 600)
  atomic           - bool; rollback on failure (default true)
EOT

  # Allow heterogeneous element shapes; we will coerce to a map in locals.
  type    = any
  default = {}
}
