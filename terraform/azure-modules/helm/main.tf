locals {
  # Do NOT use tomap() here—will fail on mixed element types.
  # jsonencode/ jsondecode normalizes the structure into a dynamic map.
  releases = jsondecode(jsonencode(var.releases))
}

# Create namespaces for all releases except 'default'
resource "kubernetes_namespace" "ns" {
  for_each = {
    for n in compact([
      for r in values(local.releases) : coalesce(r.namespace, var.namespace)
    ]) :
    n => n if n != "default"
  }

  metadata {
    name = each.value
  }
}

# Install all Helm releases
resource "helm_release" "charts" {
  for_each         = local.releases

  name             = each.key
  chart            = each.value.chart
  namespace        = coalesce(each.value.namespace, var.namespace)

  # Safely read optional fields with defaults
  create_namespace = try(each.value.create_namespace, true)
  timeout          = try(each.value.timeout, 600)
  atomic           = try(each.value.atomic, true)
  repository       = try(each.value.repo, null)
  version          = try(each.value.version, null)

  # Encode whole values tree as YAML (handles lists, maps, scalars)
  values           = try([yamlencode(each.value.values)], [])

  depends_on       = [kubernetes_namespace.ns]
}
