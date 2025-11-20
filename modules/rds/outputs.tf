#############################################
# Основні виводи RDS / Aurora
#############################################

# Основний endpoint БД:
# - для звичайної RDS: address інстансу
# - для Aurora: endpoint кластера (writer)
output "endpoint" {
  description = "Основний endpoint бази даних (RDS або Aurora writer)."
  value = var.use_aurora
    ? aws_rds_cluster.this[0].endpoint
    : aws_db_instance.this[0].address
}

# Reader endpoint тільки для Aurora (для RDS буде null)
output "reader_endpoint" {
  description = "Reader endpoint для Aurora (якщо use_aurora = true), в іншому випадку null."
  value = var.use_aurora
    ? aws_rds_cluster.this[0].reader_endpoint
    : null
}

# Порт БД (для Aurora і RDS)
output "port" {
  description = "Порт бази даних."
  value = var.use_aurora
    ? aws_rds_cluster.this[0].port
    : aws_db_instance.this[0].port
}

# Назва бази
output "database_name" {
  description = "Назва бази даних."
  value       = var.db_name
}

# Користувач БД (пароль не виводимо з міркувань безпеки)
output "master_username" {
  description = "Користувач (логін) бази даних."
  value       = var.master_username
}

#############################################
# Ідентифікатори / ARNs
#############################################

output "arn" {
  description = "ARN створеної БД (RDS instance або Aurora cluster)."
  value = var.use_aurora
    ? aws_rds_cluster.this[0].arn
    : aws_db_instance.this[0].arn
}

output "id" {
  description = "ID створеної БД (RDS instance або Aurora cluster)."
  value = var.use_aurora
    ? aws_rds_cluster.this[0].id
    : aws_db_instance.this[0].id
}

#############################################
# Мережеві ресурси (SG, Subnet Group, Parameter Group)
#############################################

output "security_group_id" {
  description = "ID security group, яка використовується для доступу до БД."
  value       = aws_security_group.this.id
}

output "db_subnet_group_name" {
  description = "Назва DB Subnet Group, що використовується для БД."
  value       = aws_db_subnet_group.this.name
}

output "parameter_group_name" {
  description = "Назва parameter group, прив'язаного до БД."
  value = var.use_aurora
    ? aws_rds_cluster_parameter_group.this.name
    : aws_db_parameter_group.this.name
}

