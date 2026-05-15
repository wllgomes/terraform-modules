# KMS/CMK key used to crypt/decrypt all buckets from Amazon S3
resource "aws_kms_key" "this" {
  description              = var.description
  deletion_window_in_days  = var.deletion_window_in_days
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = var.enabled
  multi_region             = var.multi_region
  enable_key_rotation      = var.enable_key_rotation
  policy                   = var.policy
  tags = merge(
    var.default_tags,
    {
      Name = var.name
    }
  )
}

# KMS Alias
resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this.id
}
