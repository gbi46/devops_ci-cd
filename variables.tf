variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "tf_state_bucket_name" {
  type    = string
  default = "lesson-8-9-tf-state-bucket-2"
}

variable "tf_lock_table_name" {
  type    = string
  default = "terraform-locks"
}
