module "this" {
  source = "../../general/s3"

  bucket_name        = var.bucket_name
  bucket_description = var.bucket_description
  kms_master_key_id  = var.kms_master_key_id
  default_tags       = var.default_tags

  policy             = var.policy
  lifecycle_enabled  = var.lifecycle_enabled
  status             = var.status
  versioning_status  = var.versioning_status
  standard-ia-days   = var.standard-ia-days
  glacier-days       = var.glacier-days
  expiration-days    = var.expiration-days
  website_enabled    = var.website_enabled
  website_index_file = var.website_index_file
  website_error_file = var.website_error_file
  force_destroy      = var.force_destroy
}
