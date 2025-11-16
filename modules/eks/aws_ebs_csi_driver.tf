module "ebs_csi_driver" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-ebs-csi-driver"
  version = "~> 20.0"

  cluster_name = module.eks.cluster_name
}
