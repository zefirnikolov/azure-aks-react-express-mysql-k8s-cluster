output "helm_release_statuses" {
  value = { for k, r in helm_release.charts : k => r.status }
}

output "helm_release_namespaces" {
  value = { for k, r in helm_release.charts : k => r.namespace }
}
