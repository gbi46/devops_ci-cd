terraform {
  backend "s3" {
    bucket         = "lesson-7-tfstate-1761676973"
    key            = "lesson-7/terraform.tfstate"
    region         = "eu-central-1"
    use_lockfile   = true
    encrypt        = true
  }
}
