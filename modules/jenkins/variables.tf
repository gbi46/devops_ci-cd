variable "namespace" {
  type    = string
  default = "jenkins"
}

variable "chart_version" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}
