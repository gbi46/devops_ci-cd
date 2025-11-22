resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argo_chart_version

  values = [
    <<-EOT
      server:
        service:
          type: ClusterIP
        extraArgs:
          - --insecure

      configs:
        params:
          server.insecure: "true"
    EOT
  ]

  timeout      = 900
  force_update = true
}
