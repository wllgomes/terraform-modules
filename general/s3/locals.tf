

locals {
  sse_algorithm = var.kms_master_key_id != null ? "aws:kms" : "AES256"
  kms_key_id    = var.kms_master_key_id != null ? var.kms_master_key_id : null
}
