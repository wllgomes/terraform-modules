# Bucket for store Terraform State
module "S3TerraformState" {
  source             = "../../general/s3"
  bucket_name        = "${var.enterprise_context.vertical_initials}-s3-${lower(local.common_tags.Ambiente)}-tf${var.state_bucket_suffix}"
  bucket_description = "Bucket for store terraform.state from projects in account ${lower(var.enterprise_context.vertical_initials)}-${lower(local.common_tags.Ambiente)}"
  kms_master_key_id  = module.KMSBucketS3.kms_arn
  default_tags       = local.common_tags
  versioning_status  = "Enabled" # Optional
  depends_on         = [module.KMSBucketS3]
  policy             = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/IAMRoleForTerraformAzurePipelines"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "${module.S3TerraformState.bucket_arn}",
                "${module.S3TerraformState.bucket_arn}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-pvrgxsmmsn"
                }
            }
        }
    ]
}
POLICY
}
