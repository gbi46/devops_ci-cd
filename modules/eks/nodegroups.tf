resource "aws_eks_node_group" "managed" {
  for_each = var.eks_managed_node_groups

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-${each.key}"

  node_role_arn = aws_iam_role.node_role.arn

  subnet_ids = var.public_subnet_ids

  scaling_config {
    min_size     = each.value.min_size
    max_size     = each.value.max_size
    desired_size = each.value.desired_size
  }

  instance_types = lookup(each.value, "instance_types", ["t3.medium"])
  capacity_type  = lookup(each.value, "capacity_type", "ON_DEMAND")

  # optional, kannst du beim Bedarf ergänzen:
  # disk_size = lookup(each.value, "disk_size", 50)

  tags = {
    "Name"         = "${var.project_name}-${each.key}"
    "Project"      = var.project_name
    "ManagedBy"    = "terraform"
  }

  depends_on = [
    aws_eks_cluster.this,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}
