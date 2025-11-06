variable "bucket_name_prefix" {
  description = "Prefix for the S3-Bucket"
  type        = string
}

variable "table_name" {
  description = "DynamoDB Table Name for State Locking"
  type        = string
  default     = "terraform-locks"
}

variable "force_destroy" {
  description = "Enable to destroy Buckets with Objekts (only for DEV!)"
  type        = bool
  default     = false
}
