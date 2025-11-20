# Створюється лише якщо use_aurora = true
resource "aws_rds_cluster" "this" {
  count                               = var.use_aurora ? 1 : 0
  cluster_identifier                  = "${var.name}-cluster"
  engine                              = var.engine # aurora-postgresql або aurora-mysql
  engine_version                      = var.engine_version
  database_name                       = var.db_name
  master_username                     = var.master_username
  master_password                     = var.master_password
  db_subnet_group_name                = aws_db_subnet_group.this.name
  vpc_security_group_ids              = [aws_security_group.this.id]
  port                                = var.port
  deletion_protection                 = var.deletion_protection
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  apply_immediately                   = true
  storage_encrypted                   = true
  copy_tags_to_snapshot               = true
  iam_database_authentication_enabled = false

  # Параметри
  db_cluster_parameter_group_name = one(aws_rds_cluster_parameter_group.aurora[*].name)

  tags = local.common_tags
}

resource "aws_rds_cluster_instance" "writer" {
  count                        = var.use_aurora ? 1 : 0
  identifier                   = "${var.name}-writer-1"
  cluster_identifier           = aws_rds_cluster.this[0].id
  instance_class               = var.instance_class
  engine                       = var.engine
  engine_version               = var.engine_version
  publicly_accessible          = var.publicly_accessible
  db_subnet_group_name         = aws_db_subnet_group.this.name
  auto_minor_version_upgrade   = true
  apply_immediately            = true
  performance_insights_enabled = true
  monitoring_interval          = 0
  tags                         = local.common_tags
}
