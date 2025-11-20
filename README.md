# Універсальний модуль RDS (AWS)

Модуль створює **або** звичайну RDS instance, **або** **Aurora Cluster** (кластер + writer) залежно від `use_aurora`.  
У всіх випадках автоматично піднімаються:
- **DB Subnet Group**
- **Security Group** (із вхідними правилами від CIDR та/або SG)
- **Parameter Group** з базовими параметрами

---

## Швидкий старт

```hcl
module "rds" {
  source = "./modules/rds"

  # Керуємо типом БД:
  use_aurora     = false                  # true -> Aurora, false -> звичайна RDS

  # Базове
  name           = "project-env-db"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids

  # Engine/версії/клас
  engine         = "postgres"             # або mysql / aurora-postgresql / aurora-mysql
  engine_version = "14.20"
  instance_class = "db.t4g.medium"
  multi_az       = true                   # тільки для звичайної RDS

  # Доступ
  port                    = 5432
  publicly_accessible     = false
  ingress_cidr_blocks     = ["10.0.0.0/16"]  # або використай source_security_group_ids

  # Креденшели
  db_name          = "app"
  master_username  = "dbadmin"
  master_password  = var.db_password

  # Parameter Group (дефолт під Postgres)
  base_parameters = {
    max_connections = "300"
    log_statement   = "none"
    work_mem        = "8192"
  }
  # Можна перевизначити/додати поверх базових:
  extra_parameters = {
    work_mem = "16384"
  }

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}
