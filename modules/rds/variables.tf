#############################################
# Основні параметри модуля
#############################################

variable "use_aurora" {
  description = "Якщо true — створюється Aurora Cluster; якщо false — звичайна RDS instance."
  type        = bool
  default     = false
}

variable "name" {
  description = "Базове ім'я ресурсу (префікс), буде використано для всіх RDS/Aurora ресурсів."
  type        = string
}

variable "vpc_id" {
  description = "ID VPC, у якій створюється Security Group."
  type        = string
}

variable "subnet_ids" {
  description = "Список приватних subnet'ів, які будуть використані для DB Subnet Group."
  type        = list(string)
}

#############################################
# Налаштування бази даних
#############################################

variable "engine" {
  description = "Тип бази: postgres, mysql, aurora-postgresql, aurora-mysql."
  type        = string
}

variable "engine_version" {
  description = "Версія бази даних. Наприклад: 15.5."
  type        = string
}

variable "instance_class" {
  description = "Клас інстансу (наприклад db.t3.micro, db.r6g.large)."
  type        = string
}

variable "multi_az" {
  description = "Чи створювати Multi-AZ RDS (не працює для Aurora)."
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Обсяг диску (у GB) для звичайної RDS."
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Максимальний autoscaling диску для RDS."
  type        = number
  default     = 0
}

variable "storage_type" {
  description = "Тип диску: gp3, gp2 тощо."
  type        = string
  default     = "gp3"
}

variable "db_name" {
  description = "Назва бази даних."
  type        = string
}

variable "master_username" {
  description = "Им'я користувача бази даних."
  type        = string
  default     = "app"
}

variable "master_password" {
  description = "Пароль користувача БД."
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Порт бази даних."
  type        = number
  default     = 5432
}

#############################################
# Доступи (Security Group)
#############################################

variable "ingress_cidr_blocks" {
  description = "Список CIDR блоків, яким дозволено доступ до бази даних."
  type        = list(string)
  default     = []
}

variable "source_security_group_ids" {
  description = "Список Security Group IDs, яким дозволено доступ до БД."
  type        = list(string)
  default     = []
}

#############################################
# Parameter Group
#############################################

variable "base_parameters" {
  description = "Базові параметри для parameter group."
  type        = map(string)
  default = {
    max_connections = "100"
    log_statement   = "none"
    work_mem        = "4096"
  }
}

variable "extra_parameters" {
  description = "Додаткові параметри (override для base_parameters)."
  type        = map(string)
  default     = {}
}

variable "parameter_group_family" {
  description = "Явне family для parameter group (наприклад postgres15). Якщо null – визначається автоматично."
  type        = string
  default     = null
}

#############################################
# Налаштування доступності / безпеки
#############################################

variable "publicly_accessible" {
  description = "Чи буде RDS доступна з інтернету."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Захист від видалення."
  type        = bool
  default     = false
}

#############################################
# Резервне копіювання
#############################################

variable "backup_retention_period" {
  description = "Кількість днів зберігання бекапів."
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Вікно бекапів, наприклад 02:00-03:00."
  type        = string
  default     = "02:00-03:00"
}

#############################################
# Обслуговування
#############################################

variable "preferred_maintenance_window" {
  description = "Вікно maintenance, наприклад sun:03:00-sun:04:00."
  type        = string
  default     = "sun:03:00-sun:04:00"
}

#############################################
# Теги
#############################################

variable "tags" {
  description = "Додаткові теги для всіх ресурсів."
  type        = map(string)
  default     = {}
}

