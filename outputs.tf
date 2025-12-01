output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "ecr_repo_url" {
  value = module.ecr.repository_url
}

output "grafana_port_forward" {
  value = module.monitoring.grafana_port_forward_command
}

output "grafana_namespace" {
  value = module.monitoring.grafana_namespace
}
