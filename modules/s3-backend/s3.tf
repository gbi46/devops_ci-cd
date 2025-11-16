resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name
}

# Версіонування бакета
resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}
  
# Шифрування бакета (AES-256)
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle: видаляти старі версії обʼєктів через 30 днів
resource "aws_s3_bucket_lifecycle_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    # Порожній filter означає "застосовувати до всіх обʼєктів"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.tf_state
  ]
}

# Заборона публічного доступу (рекомендовано для TF state)
resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
