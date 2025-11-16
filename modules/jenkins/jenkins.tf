resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = var.chart_version

  set {
    name  = "controller.admin.username"
    value = "admin"
  }

  set {
    name  = "controller.admin.password"
    value = "admin123"
  }

  set {
    name  = "controller.jenkinsUrl"
    value = "http://jenkins.jenkins.svc.cluster.local:8080"
  }

  set {
    name  = "controller.installPlugins"
    value = ""
  }

  timeout = 900
  wait    = true

  values = [
    file("${path.module}/values.yaml")
  ]
}
