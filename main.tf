terraform {
  required_version = ">= 1.6.0"

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

provider "aws" {
  region = var.region
}

# Після створення EKS — ці провайдери оновлюємо/ініціалізуємо data source'ами
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

variable "region" {
  default = "eu-central-1"
}

# --- S3 + DynamoDB для бекенду (одноразово, або окремим проєктом) ---
module "s3_backend" {
  source = "./modules/s3-backend"

  project_name = "demo-platform"
}

# --- VPC ---
module "vpc" {
  source = "./modules/vpc"

  project_name = "demo-platform"
  cidr_block   = "10.0.0.0/16"
  azs          = ["eu-central-1a", "eu-central-1b"]
}

# --- ECR ---
module "ecr" {
  source = "./modules/ecr"

  project_name   = "demo-platform"
  repository_name = "django-app"
}

# --- EKS ---
module "eks" {
  source = "./modules/eks"

  project_name   = "demo-platform"
  vpc_id         = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
}

# --- RDS / Aurora ---
module "rds" {
  source = "./modules/rds"

  project_name      = "demo-platform"
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_username       = var.db_username
  db_password       = var.db_password
}

# --- Jenkins ---
module "jenkins" {
  source = "./modules/jenkins"

  namespace   = "jenkins"
  cluster_name = module.eks.cluster_name
}

# --- Argo CD ---
module "argo_cd" {
  source = "./modules/argo_cd"

  namespace   = "argocd"
  cluster_name = module.eks.cluster_name
}

output "jenkins_url" {
  value = module.jenkins.url
}

output "argocd_url" {
  value = module.argo_cd.url
}
