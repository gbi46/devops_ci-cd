resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]
}

# Чарт для applications / repositories
resource "helm_release" "argocd-apps" {
  name       = "argocd-apps"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  chart      = "${path.module}/charts"

  depends_on = [helm_release.argocd]
}
