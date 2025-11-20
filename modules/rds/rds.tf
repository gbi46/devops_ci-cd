# Звичайна RDS instance (створюється, якщо use_aurora = false)
resource "aws_db_instance" "this" {
  count                 = var.use_aurora ? 0 : 1
  identifier            = var.name
  engine                = var.engine # postgres/mysql
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  multi_az              = var.multi_az
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage == 0 ? null : var.max_allocated_storage
  storage_type          = var.storage_type

  db_name  = var.db_name
  username = var.master_username
  password = var.master_password
  port     = var.port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name   = one(aws_db_parameter_group.rds[*].name)

  deletion_protection        = var.deletion_protection
  backup_retention_period    = var.backup_retention_period
  maintenance_window         = var.preferred_maintenance_window
  copy_tags_to_snapshot      = true
  auto_minor_version_upgrade = true
  publicly_accessible        = var.publicly_accessible
  apply_immediately          = true
  storage_encrypted          = true
  skip_final_snapshot        = true

  tags = local.common_tags
}
