resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  namespace        = var.namespace
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.chart_version
  create_namespace = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      grafana_admin_user     = var.grafana_admin_user
      grafana_admin_password = var.grafana_admin_password
    })
  ]

  timeout         = 900
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  depends_on = [kubernetes_namespace.monitoring]
}