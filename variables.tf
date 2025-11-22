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
