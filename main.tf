terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {
  description = "AWS регіон"
  type        = string
  default     = "eu-central-1"
}

variable "db_password" {
  description = "db_password"
  type        = string
  sensitive   = true
}

provider "aws" {
  region = var.aws_region
}

# Використаємо default VPC і перші 2 сабнети
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "in_default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  subnet_ids_first_two = slice(data.aws_subnets.in_default.ids, 0, 2)
}

module "rds_postgres" {
  source = "./modules/rds"

  use_aurora   = false
  name         = "demo-dev-postgres"
  vpc_id       = data.aws_vpc.default.id
  subnet_ids   = local.subnet_ids_first_two

  engine         = "postgres"
  engine_version = "14.11"
  instance_class = "db.t3.micro"
  multi_az       = false

  db_name          = "app"
  master_username  = "dbadmin"
  master_password  = var.db_password

  port                 = 5432
  publicly_accessible  = false
  # дозволь підключення зі свого IP, ЗАМІНИ на свій /32
  ingress_cidr_blocks  = ["95.90.200.245/32"]

  base_parameters = {
    max_connections = "50"
    log_statement   = "none"
    work_mem        = "4MB"
  }
}

output "rds_postgres_endpoint" {
  value       = module.rds_postgres.endpoint
  description = "Endpoint звичайної RDS (Postgres)"
}
