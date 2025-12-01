variable "argo_chart_version" {
  type        = string
  description = "Version of the Argo CD Helm chart"
}

variable "db_username" {
  description = "Master username for Aurora"
  type        = string
  default     = "dbadmin"  # тимчасово для dev
}

variable "db_password" {
  description = "Master password for Aurora"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"  # тимчасово для dev
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
