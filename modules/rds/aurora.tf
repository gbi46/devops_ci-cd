resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "${var.project_name}-aurora"
  engine                  = "aurora-postgresql"
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = 1
  identifier         = "${var.project_name}-aurora-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora.id
  engine             = "aurora-postgresql"
  instance_class     = "db.t3.small"
}
