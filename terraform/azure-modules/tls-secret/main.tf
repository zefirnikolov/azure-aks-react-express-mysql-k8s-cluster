
resource "kubernetes_secret" "tls_cert" {
  metadata {
    name      = var.tls_secret_name
    namespace = var.namespace
  }

  # Using `data` to load raw file contents. Kubernetes stores them base64 in the API.
  data = {
    "tls.crt" = file(var.tls_fullchain_path)
    "tls.key" = file(var.tls_privkey_path)
  }

  type = "kubernetes.io/tls"
}
