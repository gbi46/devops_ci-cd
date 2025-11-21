variable "project_name" {}
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "db_username" {}
variable "db_password" { sensitive = true }
