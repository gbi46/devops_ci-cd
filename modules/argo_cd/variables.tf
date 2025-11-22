variable "namespace" {}
variable "cluster_name" {}

variable "argo_chart_version" {
  type        = string
  description = "Version of the Argo CD Helm chart"
}
