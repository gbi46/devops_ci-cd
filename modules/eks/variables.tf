variable "project_name" {}
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids"  { type = list(string) }
variable "eks_managed_node_groups" {
  type    = any
  default = {}
}
variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}
