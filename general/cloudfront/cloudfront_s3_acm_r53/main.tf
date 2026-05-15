# ---------------------------------------------------------------------------------------------------------------------
# AMAZON S3
# ---------------------------------------------------------------------------------------------------------------------
# Bucket S3
resource "aws_s3_bucket" "this" {
  bucket        = "${var.hostname}.${var.domain}"
  force_destroy = true
  tags = merge(
    var.tags,
    {
      Name        = "${var.hostname}.${var.domain}"
      Description = var.bucket_description
    }
  )
}

# S3 block public access
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.bucket
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# S3 bucket encrypt
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket policy
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.this.arn}/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${aws_cloudfront_distribution.this.arn}"
            }
        }
    }
}
  POLICY
}

# Static Website
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  index_document {
    suffix = var.index_file
  }
  error_document {
    key = var.error_file
  }
}
resource "aws_s3_bucket_cors_configuration" "main" {
  bucket = aws_s3_bucket.this.id
  cors_rule {
    allowed_headers = var.allowed_headers
    allowed_methods = var.allowed_http_methods
    allowed_origins = var.allowed_origins
    expose_headers  = var.expose_headers
    max_age_seconds = var.max_age_seconds
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AMAZON ACM
# ---------------------------------------------------------------------------------------------------------------------
# Certificate Issue
resource "aws_acm_certificate" "this" {
  domain_name               = "${var.hostname}.${var.domain}"
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"
  tags = merge(
    var.tags,
    {
      Name        = "${var.hostname}.${var.domain}"
      Description = var.acm_description
    }
  )
}

# Certification validation
data "aws_route53_zone" "this" {
  name = var.domain
}
resource "aws_route53_record" "domain" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
  depends_on      = [aws_acm_certificate.this]
}
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.domain : record.fqdn]
  timeouts {
    create = "10m"
  }
  depends_on = [aws_route53_record.domain]
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUDFRONT
# ---------------------------------------------------------------------------------------------------------------------
# Cloudfront Distribution
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront Distribution for ${var.hostname}.${var.domain}"
  default_root_object = var.index_file
  http_version        = var.http_version
  aliases = [
    "${var.hostname}.${var.domain}",
    var.cloudfront_alias
  ]
  tags = merge(
    var.tags,
    {
      Name = "${var.hostname}.${var.domain}"
    }
  )
  default_cache_behavior {
    allowed_methods        = var.allowed_http_methods
    cached_methods         = var.cache_methods
    target_origin_id       = "${var.hostname}.${var.domain}.s3.${var.region}.amazonaws.com"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cache_policy_id        = aws_cloudfront_cache_policy.this.id
  }
  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = "${var.hostname}.${var.domain}.s3.${var.region}.amazonaws.com"
    origin_path              = ""
    connection_attempts      = 3
    connection_timeout       = 10 # Set range (1-10)
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = false
    minimum_protocol_version       = var.minimum_protocol_version
    ssl_support_method             = var.ssl_support_method
    acm_certificate_arn            = aws_acm_certificate.this.arn
  }
}

# Cache policy
resource "aws_cloudfront_cache_policy" "this" {
  name        = var.cache_policy_name
  comment     = "Custom cache for CF ${var.hostname}.${var.domain}"
  default_ttl = var.default_cache_ttl
  max_ttl     = var.max_cache_ttl
  min_ttl     = var.min_cache_ttl
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip   = "true"
    enable_accept_encoding_brotli = "true"
    query_strings_config { query_string_behavior = "none" }
    cookies_config { cookie_behavior = "none" }
    headers_config { header_behavior = "none" }
  }
}

# Origin Access Control
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.hostname}.${var.domain}"
  description                       = "OIC for ${var.hostname}.${var.domain}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ---------------------------------------------------------------------------------------------------------------------
# ROUTE 53
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route53_record" "this" {
  name    = "${var.hostname}.${var.domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id
  allow_overwrite = true

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = "Z2FDTNDATAQYW2" #Always is the Hosted ID - https://docs.aws.amazon.com/pt_br/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html
  }
}
resource "aws_route53_record" "this_alias" {
  count = var.cloudfront_alias != null ? 1 : 0
  name    = var.cloudfront_alias
  type    = "A"
  zone_id = data.aws_route53_zone.this.zone_id
  allow_overwrite = true

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = "Z2FDTNDATAQYW2" #Always is the Hosted ID - https://docs.aws.amazon.com/pt_br/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html
  }
}