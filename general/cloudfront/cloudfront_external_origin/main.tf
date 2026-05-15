# ---------------------------------------------------------------------------------------------------------------------
# CF DISTRIBUTION
# ---------------------------------------------------------------------------------------------------------------------

# Distribution
resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  is_ipv6_enabled     = true
  comment             = var.description
  default_root_object = var.default_root_object
  http_version        = var.http_version
  aliases             = var.aliases
  tags = merge(
    var.tags,
    {
      Description = var.description
    }
  )

  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = var.target_origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
    compress               = var.compress
    min_ttl                = var.min_cache_ttl
    default_ttl            = var.default_cache_ttl
    max_ttl                = var.max_cache_ttl
    forwarded_values {
      query_string = true
      headers      = var.headers
      cookies { forward = "all" }
    }
  }
  origin {
    domain_name         = var.target_origin_id
    origin_id           = var.target_origin_id
    origin_path         = var.origin_path
    connection_attempts = var.connection_attempts
    connection_timeout  = var.connection_timeout
    custom_origin_config {
      http_port              = var.http_port
      https_port             = var.https_port
      origin_protocol_policy = var.origin_protocol_policy
      origin_ssl_protocols   = [var.origin_ssl_protocols]
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }
  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = var.minimum_protocol_version
    ssl_support_method             = "sni-only"
  }
}