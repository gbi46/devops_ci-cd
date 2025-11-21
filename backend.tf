#terraform {
#  backend "s3" {
#    bucket         = var.tf_state_bucket
#    key            = "terraform/state/infra.tfstate"
#    region         = var.region
#    dynamodb_table = var.tf_state_dynamodb_table
#    encrypt        = true
#  }
#}
#
#variable "tf_state_bucket" {}
#variable "tf_state_dynamodb_table" {}
#variable "region" {
#  default = "eu-central-1"
#}
#