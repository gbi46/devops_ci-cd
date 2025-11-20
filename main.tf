module "rds_postgres" {
  source = "./modules/rds"

  use_aurora       = false
  name             = "demo-dev-postgres"
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnet_ids

  engine           = "postgres"
  engine_version   = "14.11"
  instance_class   = "db.t4g.medium"
  multi_az         = true

  db_name          = "app"
  master_username  = "dbadmin"
  master_password  = var.db_password   # передай чутливу змінну через TF_VAR_db_password

  port                    = 5432
  publicly_accessible     = false
  ingress_cidr_blocks     = ["10.0.0.0/16"] # або використай source_security_group_ids

  # Не вказуєш family — модуль підбере postgres14
  base_parameters = {
    max_connections = "300"
    log_statement   = "ddl"
    work_mem        = "16MB"
  }

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}

# --- Альтернатива: Aurora PostgreSQL ---
module "rds_aurora_pg" {
  source = "./modules/rds"

  use_aurora     = true
  name           = "demo-dev-aurora-pg"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids

  engine         = "aurora-postgresql"
  engine_version = "15.4"                 # приклад
  instance_class = "db.r6g.large"

  db_name          = "app"
  master_username  = "dbadmin"
  master_password  = var.db_password

  port                = 5432
  publicly_accessible = false
  source_security_group_ids = [module.eks.node_sg_id] # приклад

  # Можеш також явно задати family:
  # parameter_group_family = "aurora-postgresql15"

  extra_parameters = {
    max_connections = "400"
  }

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}
