# Bucket S3 (Required)
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags = merge(
    var.default_tags,
    {
      Name        = var.bucket_name
      Description = var.bucket_description
    }
  )
}

# S3 block public access (Required)
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = var.bucket_name
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# S3 bucket encrypt (Required)
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = local.sse_algorithm
      kms_master_key_id = local.kms_key_id
    }
  }
}

# Bucket policy
resource "aws_s3_bucket_policy" "this" {
  count  = (var.policy != null) ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  policy = var.policy
}

# Lifecycle policy (Optional)
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.lifecycle_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  rule {
    id     = "default-lifecycle"
    status = var.status

    dynamic "transition" {
      for_each = var.standard-ia-days >= 0 ? ["element"] : []

      content {
        days          = var.standard-ia-days
        storage_class = "STANDARD_IA"
      }
    }

    dynamic "transition" {
      for_each = var.glacier-days >= 0 ? ["element"] : []

      content {
        days          = var.glacier-days
        storage_class = "GLACIER"
      }
    }

    dynamic "expiration" {
      for_each = var.expiration-days >= 0 ? ["element"] : []

      content {
        days = var.expiration-days
      }
    }
  }
}

# Versioning (Optional)
resource "aws_s3_bucket_versioning" "this" {
  count  = var.versioning_status == "Enabled" ? 1 : 0
  bucket = var.bucket_name
  versioning_configuration {
    status = var.versioning_status
  }
}

# Website (Optional)
resource "aws_s3_bucket_website_configuration" "this" {
  count  = (var.website_enabled == "true") ? 1 : 0
  bucket = var.bucket_name
  index_document {
    suffix = var.website_index_file
  }
  error_document {
    key = var.website_error_file
  }
}
