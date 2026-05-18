# ---------------------------------------------------------------------------------------------------------------------
# CF DISTRIBUTION
# ---------------------------------------------------------------------------------------------------------------------

locals {
  default_custom_origin_config = {
    http_port                = var.http_port
    https_port               = var.https_port
    origin_protocol_policy   = var.origin_protocol_policy
    origin_ssl_protocols     = [var.origin_ssl_protocols]
    origin_keepalive_timeout = null
    origin_read_timeout      = null
  }

  legacy_origins = var.target_origin_id == null ? [] : [
    {
      domain_name              = var.target_origin_id
      origin_id                = var.target_origin_id
      origin_path              = var.origin_path
      connection_attempts      = var.connection_attempts
      connection_timeout       = var.connection_timeout
      origin_access_control_id = null
      custom_header            = []
      custom_origin_config     = local.default_custom_origin_config
    }
  ]

  origins = length(var.origin) > 0 ? var.origin : local.legacy_origins

  default_forwarded_values = {
    query_string            = true
    query_string_cache_keys = null
    headers                 = var.headers
    cookies = {
      forward           = "all"
      whitelisted_names = null
    }
  }

  configured_forwarded_values = try(var.default_cache_behavior.forwarded_values, null)
  forwarded_values = local.configured_forwarded_values == null ? local.default_forwarded_values : {
    query_string            = coalesce(try(local.configured_forwarded_values.query_string, null), local.default_forwarded_values.query_string)
    query_string_cache_keys = try(local.configured_forwarded_values.query_string_cache_keys, null)
    headers                 = coalesce(try(local.configured_forwarded_values.headers, null), local.default_forwarded_values.headers)
    cookies = {
      forward           = coalesce(try(local.configured_forwarded_values.cookies.forward, null), local.default_forwarded_values.cookies.forward)
      whitelisted_names = try(local.configured_forwarded_values.cookies.whitelisted_names, null)
    }
  }

  default_behavior = {
    allowed_methods            = try(var.default_cache_behavior.allowed_methods != null ? var.default_cache_behavior.allowed_methods : var.allowed_methods, var.allowed_methods)
    cached_methods             = try(var.default_cache_behavior.cached_methods != null ? var.default_cache_behavior.cached_methods : var.cached_methods, var.cached_methods)
    target_origin_id           = try(var.default_cache_behavior.target_origin_id != null ? var.default_cache_behavior.target_origin_id : var.target_origin_id, var.target_origin_id)
    viewer_protocol_policy     = try(var.default_cache_behavior.viewer_protocol_policy != null ? var.default_cache_behavior.viewer_protocol_policy : var.viewer_protocol_policy, var.viewer_protocol_policy)
    compress                   = try(var.default_cache_behavior.compress != null ? var.default_cache_behavior.compress : var.compress, var.compress)
    min_ttl                    = try(var.default_cache_behavior.min_ttl != null ? var.default_cache_behavior.min_ttl : var.min_cache_ttl, var.min_cache_ttl)
    default_ttl                = try(var.default_cache_behavior.default_ttl != null ? var.default_cache_behavior.default_ttl : var.default_cache_ttl, var.default_cache_ttl)
    max_ttl                    = try(var.default_cache_behavior.max_ttl != null ? var.default_cache_behavior.max_ttl : var.max_cache_ttl, var.max_cache_ttl)
    cache_policy_id            = try(var.default_cache_behavior.cache_policy_id, null)
    origin_request_policy_id   = try(var.default_cache_behavior.origin_request_policy_id, null)
    response_headers_policy_id = try(var.default_cache_behavior.response_headers_policy_id != null ? var.default_cache_behavior.response_headers_policy_id : var.response_headers_policy_id, var.response_headers_policy_id)
    smooth_streaming           = try(var.default_cache_behavior.smooth_streaming, null)
    trusted_key_groups         = try(var.default_cache_behavior.trusted_key_groups, null)
    trusted_signers            = try(var.default_cache_behavior.trusted_signers, null)
    field_level_encryption_id  = try(var.default_cache_behavior.field_level_encryption_id, null)
    realtime_log_config_arn    = try(var.default_cache_behavior.realtime_log_config_arn, null)
    forwarded_values           = local.forwarded_values
  }
}

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
    allowed_methods            = local.default_behavior.allowed_methods
    cached_methods             = local.default_behavior.cached_methods
    target_origin_id           = local.default_behavior.target_origin_id
    viewer_protocol_policy     = local.default_behavior.viewer_protocol_policy
    compress                   = local.default_behavior.compress
    min_ttl                    = local.default_behavior.cache_policy_id == null ? local.default_behavior.min_ttl : null
    default_ttl                = local.default_behavior.cache_policy_id == null ? local.default_behavior.default_ttl : null
    max_ttl                    = local.default_behavior.cache_policy_id == null ? local.default_behavior.max_ttl : null
    cache_policy_id            = local.default_behavior.cache_policy_id
    origin_request_policy_id   = local.default_behavior.origin_request_policy_id
    response_headers_policy_id = local.default_behavior.response_headers_policy_id
    smooth_streaming           = local.default_behavior.smooth_streaming
    trusted_key_groups         = local.default_behavior.trusted_key_groups
    trusted_signers            = local.default_behavior.trusted_signers
    field_level_encryption_id  = local.default_behavior.field_level_encryption_id
    realtime_log_config_arn    = local.default_behavior.realtime_log_config_arn

    dynamic "forwarded_values" {
      for_each = local.default_behavior.cache_policy_id == null ? [local.default_behavior.forwarded_values] : []

      content {
        query_string            = forwarded_values.value.query_string
        query_string_cache_keys = forwarded_values.value.query_string_cache_keys
        headers                 = forwarded_values.value.headers

        cookies {
          forward           = forwarded_values.value.cookies.forward
          whitelisted_names = forwarded_values.value.cookies.whitelisted_names
        }
      }
    }
  }

  dynamic "origin" {
    for_each = local.origins

    content {
      domain_name              = origin.value.domain_name
      origin_id                = origin.value.origin_id
      origin_path              = origin.value.origin_path
      connection_attempts      = origin.value.connection_attempts
      connection_timeout       = origin.value.connection_timeout
      origin_access_control_id = origin.value.origin_access_control_id

      dynamic "custom_header" {
        for_each = origin.value.custom_header

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "custom_origin_config" {
        for_each = [coalesce(origin.value.custom_origin_config, local.default_custom_origin_config)]

        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
          origin_read_timeout      = custom_origin_config.value.origin_read_timeout
        }
      }
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
    ssl_support_method             = var.ssl_support_method
  }
}
