module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name      = "lesson-8-9-tf-state-bucket"
  dynamodb_name    = "terraform-locks"
  bucket_region    = "eu-central-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "lesson-8-9-tf-state-bucket-new-123"
}
