variable "namespace" {
  description = "Namespace where monitoring stack is deployed"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Helm chart version for kube-prometheus-stack"
  type        = string
  default     = "62.2.0"
}

variable "grafana_admin_user" {
  description = "Grafana administrator username"
  type        = string
  default     = "grafana-admin"
}

variable "grafana_admin_password" {
  description = "Grafana administrator password"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}