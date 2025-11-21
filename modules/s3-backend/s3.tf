resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.project_name}-tf-state"

  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = true
  }
}
