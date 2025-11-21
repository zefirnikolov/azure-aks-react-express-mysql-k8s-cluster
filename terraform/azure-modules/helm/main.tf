locals {
  releases = var.releases
}

# Create namespaces for all releases
resource "kubernetes_namespace" "ns" {
  for_each = toset(compact([for r in local.releases : coalesce(r.namespace, var.namespace)]))
  metadata {
    name = each.value
  }
}

resource "helm_release" "charts" {
  for_each          = local.releases
  name              = each.key
  chart             = each.value.chart
  namespace         = coalesce(each.value.namespace, var.namespace)
  create_namespace  = each.value.create_namespace
  timeout           = each.value.timeout
  atomic            = each.value.atomic
  repository        = try(each.value.repo, null)
  version           = try(each.value.version, null)
  values            = try([yamlencode(each.value.values)], [])
  depends_on        = [kubernetes_namespace.ns]
}
