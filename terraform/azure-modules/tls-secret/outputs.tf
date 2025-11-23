
output "tls_secret_name" {
  value       = var.tls_secret_name
  description = "Name of the TLS secret created"
}

output "tls_secret_namespace" {
  value       = var.namespace
  description = "Namespace where the TLS secret was created"
}
