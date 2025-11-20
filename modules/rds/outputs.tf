output "security_group_id" {
  description = "ID створеної Security Group"
  value       = aws_security_group.this.id
}

output "subnet_group_name" {
  description = "Назва DB Subnet Group"
  value       = aws_db_subnet_group.this.name
}

output "parameter_group_name" {
  description = "Назва Parameter Group (Aurora або RDS)"
  value       = var.use_aurora ? one(aws_rds_cluster_parameter_group.aurora[*].name) : one(aws_db_parameter_group.rds[*].name)
}

# Ендпоінти для підключення
output "endpoint" {
  description = "Основний ендпоінт БД"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "reader_endpoint" {
  description = "Reader ендпоінт (тільки для Aurora; інакше null)"
  value       = var.use_aurora ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "port" {
  description = "Порт БД"
  value       = var.port
}
