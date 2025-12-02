resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
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
      
      redisSecretInit:
        enabled: false
    EOT
  ]

  timeout       = 900
  force_update  = true
  replace       = true
  wait_for_jobs = false
  depends_on = [kubernetes_namespace.argocd]
}
