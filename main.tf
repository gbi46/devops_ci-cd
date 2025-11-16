terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# -----------------------
# AWS provider
# -----------------------
provider "aws" {
  region = var.aws_region
}

# -----------------------
# S3 + DynamoDB backend
# -----------------------
module "s3_backend" {
  source      = "./modules/s3-backend"

  bucket_name = var.tf_state_bucket_name
  table_name  = var.tf_lock_table_name
}

# -----------------------
# VPC
# -----------------------
module "vpc" {
  source = "./modules/vpc"

  name   = "main-vpc"
  cidr   = "10.0.0.0/16"
  azs    = ["${var.aws_region}a", "${var.aws_region}b"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
}

# -----------------------
# EKS
# -----------------------
module "eks" {
  source = "./modules/eks"

  cluster_name    = "demo-eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

# -----------------------
# Дані про EKS-кластер (для провайдерів)
# -----------------------
data "aws_eks_cluster" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

# -----------------------
# Kubernetes provider
# -----------------------
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# -----------------------
# Helm provider
# -----------------------
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# -----------------------
# ECR
# -----------------------
module "ecr" {
  source          = "./modules/ecr"
  repository_name = "django-app"
}

# -----------------------
# Jenkins
# -----------------------
module "jenkins" {
  source             = "./modules/jenkins"
  namespace          = "jenkins"
  chart_version      = "5.3.2"
  ecr_repository_url = module.ecr.repository_url

  depends_on = [
    module.eks,
    data.aws_eks_cluster.this
  ]
}

# -----------------------
# Argo CD
# -----------------------
module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "7.7.11"

  depends_on = [
    module.eks,
    data.aws_eks_cluster.this
  ]
}
