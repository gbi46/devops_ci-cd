variable "ingress_cidr_blocks" {
  description = "CIDR-блоки, яким дозволено доступ до RDS/Aurora."
  type        = list(string)
  default     = []
}
