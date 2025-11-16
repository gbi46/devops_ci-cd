variable "bucket_name" {
  type = string
}

variable "table_name" {
  type = string
}

variable "dynamodb_name" {
  type = string
}

variable "bucket_region" {
  type    = string
  default = "eu-central-1"
}
