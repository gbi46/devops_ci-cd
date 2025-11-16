output "url" {
  description = "Cluster-internal URL for Argo CD server"
  value       = "http://argo-cd-argocd-server.${var.namespace}.svc.cluster.local"
}
