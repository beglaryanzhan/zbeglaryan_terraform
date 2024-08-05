resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.15.2"

  depends_on = [helm_release.external_nginx]
}
