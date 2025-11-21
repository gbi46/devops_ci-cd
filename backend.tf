#terraform {
#  backend "s3" {
#    bucket         = "demo-platform-tf-state"
#    key            = "terraform/state/infra.tfstate"
#    region         = "eu-central-1"
#    use_lockfile   = true
#    encrypt        = true
#  }
#}
