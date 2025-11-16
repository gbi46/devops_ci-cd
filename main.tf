module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name      = "my-tf-state-bucket"
  dynamodb_name    = "terraform-locks"
  bucket_region    = "eu-central-1"
}
