variable "use_aurora" {
  description = "Якщо true — піднімаємо Aurora (cluster + writer). Якщо false — звичайну RDS instance."
  type        = bool
  default     = false
}

variable "name" {
  description = "Базове ім'я ресурсів (префікс). Напр., project-env-db"
  type        = string
}

variable "vpc_id" {
  description = "ID VPC для Security Group"
  type        = string
}

variable "subnet_ids" {
  description = "Список приватних subnet'ів для DB Subnet Group"
  type        = list(string)
}

variable "engine" {
  description = "Тип БД: напр., postgres, mysql, aurora-postgresql, aurora-mysql"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Версія engine. Напр., 14.11, 15.5, 8.0.mysql_aurora.3.06.0"
  type        = string
  default     = "14.11"
}

variable "instance_class" {
  description = "Клас інстансу для RDS або Aurora Instances. Напр., db.t4g.medium"
  type        = string
  default     = "db.t4g.medium"
}

variable "multi_az" {
  description = "Multi-AZ для звичайної RDS (на Aurora не впливає)"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Обсяг у GiB для звичайної RDS. Для Aurora ігнорується."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Автоскейл storage для звичайної RDS (GiB). 0 — вимкнено."
  type        = number
  default     = 0
}

variable "storage_type" {
  description = "Тип диска для звичайної RDS: gp3, gp2 тощо"
  type        = string
  default     = "gp3"
}

variable "db_name" {
  description = "Ім'я початкової бази даних"
  type        = string
  default     = "app"
}

variable "master_username" {
  description = "Користувач БД"
  type        = string
  default     = "dbadmin"
}

variable "master_password" {
  description = "Пароль БД (краще передавати з CI або через TF_VAR_... / SSM / Secrets Manager)"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Порт БД (5432 для Postgres, 3306 для MySQL)"
  type        = number
  default     = 5432
}

variable "publicly_accessible" {
  description = "Дозволити публічний доступ до інстансу/вузлів (небажано у проді)"
  type        = bool
  default     = false
}

variable "ingress_cidr_blocks" {
  description = "Список CIDR, яким дозволено підключення до БД"
  type        = list(string)
  default     = []
}

variable "source_security_group_ids" {
  description = "Альтернатива CIDR: SG-ідентифікатори, яким можна конектитись до БД"
  type        = list(string)
  default     = []
}

variable "parameter_group_family" {
  description = "Сімейство параметрів для Parameter Group. Якщо null — обчислюється для Postgres/Aurora-Postgres/MySQL 8.0."
  type        = string
  default     = null
}

variable "base_parameters" {
  description = "Базові параметри для Parameter Group (name => value). Дефолт під Postgres."
  type        = map(string)
  default = {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "4MB"
  }
}

variable "extra_parameters" {
  description = "Додаткові параметри (name => value), щоб перевизначити/додати поверх base_parameters."
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "Увімкнути захист від видалення"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Кількість днів зберігання бекапів (0 — вимкнено)"
  type        = number
  default     = 1
}

variable "preferred_backup_window" {
  description = "Вікно бекапів, напр. 02:00-03:00"
  type        = string
  default     = "02:00-03:00"
}

variable "preferred_maintenance_window" {
  description = "Вікно обслуговування, напр. sun:03:00-sun:04:00"
  type        = string
  default     = "sun:03:00-sun:04:00"
}

variable "tags" {
  description = "Додаткові теги"
  type        = map(string)
  default     = {}
}
