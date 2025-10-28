terraform {
  backend "s3" {
    bucket         = "lesson-5-tfstate-1761676973"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1"
    use_lockfile   = true
    encrypt        = true
  }
}
