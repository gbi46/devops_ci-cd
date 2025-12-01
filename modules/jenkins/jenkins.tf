resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = "jenkins"
  create_namespace = true
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "4.9.0"

  set {
    name  = "controller.persistence.enabled"
    value = "true"
  }

  wait          = true
  timeout       = 900 
  atomic        = true
  cleanup_on_fail = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
