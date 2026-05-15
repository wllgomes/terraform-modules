# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------
# KMS for Buckets in Amazon S3
module "KMSBucketS3" {
  source                  = "../../general/kms"
  name                    = "${var.enterprise_context.vertical_initials}-kms-${lower(local.common_tags.Ambiente)}-s3"
  description             = "KMS for Buckets in Amazon S3"
  deletion_window_in_days = "30" # RECOMMENDED
  enable_key_rotation     = true
  multi_region            = false
  enabled                 = true
  default_tags            = local.common_tags # Required
}

# KMS for EBS Volumes
module "KMSEBSVolumes" {
  source                  = "../../general/kms"
  name                    = "${var.enterprise_context.vertical_initials}-kms-${lower(local.common_tags.Ambiente)}-ebs"
  description             = "KMS for EBS Volumes"
  deletion_window_in_days = "30" # RECOMMENDED (30 days)
  enable_key_rotation     = true
  multi_region            = false
  enabled                 = true
  default_tags            = local.common_tags # Required
}