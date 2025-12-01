output "grafana_admin_user" {
  description = "Grafana administrator username"
  value       = var.grafana_admin_user
}

output "grafana_namespace" {
  description = "Namespace where Grafana is deployed"
  value       = var.namespace
}

output "grafana_port_forward_command" {
  description = "Helper command for accessing Grafana locally"
  value       = "kubectl port-forward svc/grafana 3000:80 -n ${var.namespace}"
}