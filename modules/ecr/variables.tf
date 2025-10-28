variable "ecr_name" {
  type        = string
  description = "ECR Repository Name"
}

variable "scan_on_push" {
  type        = bool
  description = "Enable image scanning on push"
  default     = true
}
