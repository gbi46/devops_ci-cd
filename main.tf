# --- S3 backend + DynamoDB
module "s3_backend" {
  source             = "./modules/s3-backend"
  bucket_name_prefix = "lesson-5-tfstate"
  table_name         = "terraform-locks"
  force_destroy      = true                 # for DEV - true
}

# --- VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-5-vpc"
}

# --- ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-5-ecr"
  scan_on_push = true
}

provider "aws" {
  region = "eu-central-1"
}

# --- EKS
module "eks" {
  source             = "./modules/eks"
  cluster_name       = "lesson-5-eks"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  tags = {
    Project = "lesson-5"
    Env     = "dev"
  }
}
