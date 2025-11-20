locals {
  merged_parameters = merge(var.base_parameters, var.extra_parameters)

  # Проба «вгадати» family, якщо не вказано явно
  version_major = regex("^([0-9]+)", var.engine_version)
  family_guess = (
    contains(["postgres", "aurora-postgresql"], var.engine) ?
      "${var.engine == "postgres" ? "postgres" : "aurora-postgresql"}${local.version_major[0]}" :
    contains(["mysql", "aurora-mysql"], var.engine) ?
      "mysql8.0" : null
  )
  parameter_group_family = coalesce(var.parameter_group_family, local.family_guess)

  common_tags = merge({
    "Name" = var.name
    "Module" = "rds"
  }, var.tags)
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnets"
  subnet_ids = var.subnet_ids
  tags       = local.common_tags
}

resource "aws_security_group" "this" {
  name        = "${var.name}-db-sg"
  description = "DB access for ${var.name}"
  vpc_id      = var.vpc_id
  tags        = local.common_tags
}

# Ingress: або з SG, або з CIDR (обидва варіанти можна змішувати)
resource "aws_vpc_security_group_ingress_rule" "from_sg" {
  count                        = length(var.source_security_group_ids)
  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.source_security_group_ids[count.index]
  ip_protocol                  = "tcp"
  from_port                    = var.port
  to_port                      = var.port
  description                  = "DB access from SG"
}

resource "aws_vpc_security_group_ingress_rule" "from_cidr" {
  count             = length(var.ingress_cidr_blocks)
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.ingress_cidr_blocks[count.index]
  ip_protocol       = "tcp"
  from_port         = var.port
  to_port           = var.port
  description       = "DB access from CIDR"
}

resource "aws_vpc_security_group_egress_rule" "egress_all" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "All egress"
}

# Parameter Groups (окремі для Aurora Cluster та звичайної RDS)
resource "aws_rds_cluster_parameter_group" "aurora" {
  count  = var.use_aurora ? 1 : 0
  name   = "${var.name}-aurora-pg"
  family = local.parameter_group_family
  dynamic "parameter" {
    for_each = local.merged_parameters
    content {
      name  = parameter.key
      value = parameter.value
      apply_method = "pending-reboot"
    }
  }
  tags = local.common_tags
}

resource "aws_db_parameter_group" "rds" {
  count  = var.use_aurora ? 0 : 1
  name   = "${var.name}-rds-pg"
  family = local.parameter_group_family
  dynamic "parameter" {
    for_each = local.merged_parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
  tags = local.common_tags
}
