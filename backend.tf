terraform {
  backend "s3" {
    bucket         = "lesson-8-9-tf-state-bucket-1"
    key            = "global/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
