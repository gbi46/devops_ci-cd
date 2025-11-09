terraform {
  backend "s3" {
    bucket         = "lesson-7-tfstate-hcwh1a"
    key            = "lesson-7/terraform.tfstate"
    region         = "eu-central-1"
    use_lockfile   = true
    encrypt        = true
  }
}
