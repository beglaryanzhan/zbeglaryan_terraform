resource "helm_release" "prometheus-community" {
  name       = "prometheus-community"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "default"
  create_namespace = true
  timeout = 500

  values = ["${file("./values/chart_values.yaml")}"]

  set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  depends_on = [helm_release.external_nginx]
}
