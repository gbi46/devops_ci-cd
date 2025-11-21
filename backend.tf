terraform {
  backend "s3" {
    bucket         = "ivcoder-tf-state-bucket"
    key            = "global/terraform.tfstate"
    region         = "eu-central-1"
    use_lockfile   = true
    encrypt        = true
  }
}
