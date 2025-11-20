#############################################
# Основні виводи RDS / Aurora
#############################################

# Основний endpoint БД:
# - для звичайної RDS: endpoint інстансу (address)
# - для Aurora: cluster endpoint (writer)
output "endpoint" {
  description = "Основний endpoint бази даних (RDS або Aurora writer)."

  value = var.use_aurora
    ? aws_rds_cluster.this[0].endpoint
    : aws_db_instance.this[0].address
}

# Reader endpoint тільки для Aurora (для RDS буде null)
output "reader_endpoint" {
  description = "Reader endpoint для Aurora, якщо use_aurora = true, інакше null."

  value = var.use_aurora
    ? aws_rds_cluster.this[0].reader_endpoint
    : null
}

# Порт БД
output "port" {
  description = "Порт бази даних."
  value = var.use_aurora
    ? aws_rds_cluster.this[0].port
    : aws_db_instance.this[0].port
}

# Назва бази даних (беремо з змінної, щоб не паритись з різними полями)
output "database_name" {
  description = "Назва бази даних."
  value       = var.db_name
}

# Користувач (логін)
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

# Для Aurora ще можна вивести ID writer instance (зручно)
output "writer_instance_id" {
  description = "ID writer-інстансу Aurora (якщо use_aurora = true), інакше null."

  value = var.use_aurora
    ? aws_rds_cluster_instance.writer[0].id
    : null
}

#############################################
# Мережеві ресурси (SG, Subnet Group, Parameter Group)
#############################################

output "security_group_id" {
  description = "ID security group, через яку надається доступ до БД."
  value       = aws_security_group.this.id
}

output "db_subnet_group_name" {
  description = "Назва DB Subnet Group, у якій знаходиться БД."
  value       = aws_db_subnet_group.this.name
}

# Для Aurora використовується aws_rds_cluster_parameter_group.aurora
# Для звичайної RDS — aws_db_parameter_group.this (перевір, що саме так називається ресурс у shared.tf)
output "parameter_group_name" {
  description = "Назва parameter group, який використовується для БД."

  value = var.use_aurora
    ? aws_rds_cluster_parameter_group.aurora[0].name
    : aws_db_parameter_group.this.name
}
