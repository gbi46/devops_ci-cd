# Універсальний Terraform-модуль RDS / Aurora (AWS)

Модуль дозволяє створювати **звичайну RDS instance** або **Aurora Cluster** залежно від параметра `use_aurora`.  
Підходить для багаторазового використання у різних проєктах без змін у коді модуля.

---

## 📌 Можливості модуля

### Якщо `use_aurora = true`:
- Створюється **Aurora Cluster** (`aws_rds_cluster`);
- Створюється **writer instance** (`aws_rds_cluster_instance`);
- Повна підтримка параметрів engine/engine_version/class.

### Якщо `use_aurora = false`:
- Створюється **звичайний RDS інстанс** (`aws_db_instance`);
- Підтримує Multi-AZ, autoscaling storage, backup window.

### В обох випадках автоматично створюється:
- **DB Subnet Group**
- **Security Group**
- **Parameter Group**
- Доступ з CIDR або з інших Security Groups
- Теги, резервні копії, maintenance window

---

## 📁 Структура модуля

```
modules/rds/
├── aurora.tf         # Aurora cluster + writer
├── rds.tf            # aws_db_instance
├── shared.tf         # SG, subnet-group, parameter-group
├── variables.tf      # Всі змінні модуля
└── outputs.tf        # endpoint, port, identifiers
```

---

# 🔧 Приклад використання

## 1️⃣ Звичайна RDS PostgreSQL

```hcl
module "rds_postgres" {
  source = "./modules/rds"

  use_aurora = false
  name       = "demo-postgres"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"
  multi_az       = false

  db_name         = "app_db"
  master_username = "app"
  master_password = var.db_password
  port            = 5432

  ingress_cidr_blocks = ["1.2.3.4/32"]

  base_parameters = {
    max_connections = "50"
    log_statement   = "none"
    work_mem        = "4096"
  }

  extra_parameters = {
    work_mem = "8192"
  }

  publicly_accessible     = false
  deletion_protection     = false
  backup_retention_period = 7

  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "sun:03:00-sun:04:00"

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}
```

---

## 2️⃣ Aurora PostgreSQL

```hcl
module "rds_aurora" {
  source = "./modules/rds"

  use_aurora = true
  name       = "demo-aurora"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  engine         = "aurora-postgresql"
  engine_version = "15.3"
  instance_class = "db.r6g.large"

  db_name         = "app_db"
  master_username = "app"
  master_password = var.db_password
  port            = 5432

  ingress_cidr_blocks = ["1.2.3.4/32"]

  base_parameters = {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "8192"
  }

  extra_parameters = {}

  publicly_accessible     = false
  deletion_protection     = true
  backup_retention_period = 7

  preferred_backup_window      = "01:00-02:00"
  preferred_maintenance_window = "sun:03:00-sun:04:00"

  tags = {
    Environment = "prod"
    Project     = "demo"
  }
}
```

---

# 🔣 Опис усіх змінних модуля

| Змінна | Тип | Обов'язкова | Опис |
|--------|-----|-------------|-------|
| `use_aurora` | bool | ні | Якщо true → створюється Aurora Cluster |
| `name` | string | так | Ім'я ресурсів (префікс) |
| `vpc_id` | string | так | ID VPC |
| `subnet_ids` | list(string) | так | Приватні підмережі |
| `engine` | string | так | postgres, mysql, aurora-postgresql, aurora-mysql |
| `engine_version` | string | так | Наприклад: `"15.5"` |
| `instance_class` | string | так | Наприклад: `"db.t3.micro"` |
| `multi_az` | bool | ні | Multi-AZ для RDS |
| `allocated_storage` | number | ні | Мінімальний розмір диска |
| `max_allocated_storage` | number | ні | Autoscaling storage |
| `storage_type` | string | ні | gp3/gp2 |
| `db_name` | string | так | Назва бази даних |
| `master_username` | string | ні | Логін |
| `master_password` | string | так | Пароль (sensitive) |
| `port` | number | ні | Порт БД |
| `ingress_cidr_blocks` | list(string) | ні | CIDR доступу |
| `ingress_security_group_ids` | list(string) | ні | Додаткові SG |
| `base_parameters` | map(string) | ні | Базові параметри PG |
| `extra_parameters` | map(string) | ні | Додаткові/override параметри |
| `parameter_group_family` | string | ні | Явне family |
| `publicly_accessible` | bool | ні | Доступ з інтернету |
| `deletion_protection` | bool | ні | Захист від видалення |
| `backup_retention_period` | number | ні | Дні зберігання бекапів |
| `preferred_backup_window` | string | ні | Вікно бекапів |
| `preferred_maintenance_window` | string | ні | Вікно обслуговування |
| `tags` | map(string) | ні | Теги |

---

# 🔧 Як змінити тип БД

### З RDS на Aurora:
```hcl
use_aurora = true
engine     = "aurora-postgresql"
```

### З Aurora на RDS:
```hcl
use_aurora = false
engine     = "postgres"
```

### Змінити engine:
```hcl
engine = "mysql"
```

### Змінити клас інстансу:
```hcl
instance_class = "db.t3.medium"
```

---

# 🚀 Як запустити проєкт

## 1. AWS креденшели

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=eu-central-1
```

## 2. Створити backend (S3 + DynamoDB)

```bash
cd modules/s3-backend
terraform init
terraform apply
```

Потім перенести bucket/table у `backend.tf`.

## 3. У корені проєкту

Створити `terraform.tfvars`:

```hcl
db_password = "SuperSecret123!"
```

## 4. Запустити інфраструктуру

```bash
terraform init
terraform plan
terraform apply
```

---

# 🧪 Перевірка роботи

```bash
terraform output rds_postgres_endpoint
```

Підключення до PostgreSQL:

```bash
psql "postgres://app:SuperSecret123!@<endpoint>:5432/app_db"
```

---

Готово!  
Файл повністю готовий до використання.
