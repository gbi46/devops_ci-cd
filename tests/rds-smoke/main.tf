terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# default VPC (лише для тесту!)
data "aws_vpc" "default" {
  count   = var.vpc_id == null ? 1 : 0
  default = true
}

data "aws_subnets" "default" {
  count = var.subnet_ids == null ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default[0].id]
  }
}

locals {
  vpc_id_final     = coalesce(var.vpc_id, try(data.aws_vpc.default[0].id, null))
  subnet_ids_final = var.subnet_ids != null ? var.subnet_ids : slice(try(data.aws_subnets.default[0].ids, []), 0, 2)
}

# --- ВАРІАНТ 1: звичайна RDS Postgres ---
module "rds_postgres" {
  source = "./modules/rds"

  use_aurora   = false
  name         = "demo-dev-postgres"
  vpc_id       = local.vpc_id_final
  subnet_ids   = local.subnet_ids_final

  engine         = "postgres"
  engine_version = "14.11"
  instance_class = "db.t3.micro"
  multi_az       = false

  db_name          = "app"
  master_username  = "dbadmin"
  master_password  = var.db_password

  port                 = 5432
  publicly_accessible  = false
  ingress_cidr_blocks  = var.ingress_cidrs # напр. ["YOUR.PUBLIC.IP.0/32"]

  base_parameters = {
    max_connections = "50"
    log_statement   = "none"
    work_mem        = "4MB"
  }

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}

# --- ВАРІАНТ 2: Aurora PostgreSQL (опціонально) ---
module "rds_aurora_pg" {
  source = "./modules/rds"

  use_aurora   = true
  name         = "demo-dev-aurora-pg"
  vpc_id       = local.vpc_id_final
  subnet_ids   = local.subnet_ids_final

  engine         = "aurora-postgresql"
  engine_version = "15.4"
  instance_class = "db.r6g.large"

  db_name          = "app"
  master_username  = "dbadmin"
  master_password  = var.db_password

  port                 = 5432
  publicly_accessible  = false
  # раніше тут було: source_security_group_ids = [module.eks.node_sg_id]
  # приберемо залежність від EKS; для тесту достатньо ingress_cidr_blocks в модулі

  extra_parameters = {
    max_connections = "200"
  }

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}

output "rds_postgres_endpoint" {
  value       = module.rds_postgres.endpoint
  description = "Endpoint звичайної RDS (Postgres)"
}

output "aurora_endpoint" {
  value       = module.rds_aurora_pg.endpoint
  description = "Cluster endpoint Aurora (якщо модуль увімкнено)"
}

output "aurora_reader_endpoint" {
  value       = module.rds_aurora_pg.reader_endpoint
  description = "Reader endpoint Aurora (якщо модуль увімкнено)"
}
