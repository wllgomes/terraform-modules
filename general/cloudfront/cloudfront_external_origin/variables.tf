# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "domain" {
  type        = string
  description = "(Optional/Legacy) - The DNS Domain (only domain, not sub domain) for Cloudfront. This value is kept for backwards compatibility and is not used by the distribution resource."
  default     = null
}
variable "aliases" {
  type        = list(string)
  description = "(Required) - The DNS aliases for Cloudfront."
}
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/cloudfront/cloudfron_external_origin"
  }
}
variable "enabled" {
  type        = bool
  description = "(Required) - Whether the distribution is enabled to accept end user requests for content."
  default     = true
}
variable "allowed_methods" {
  type        = list(string)
  description = "(Optional/Legacy) - Controls which HTTP methods CloudFront processes and forwards to your custom origin. Prefer default_cache_behavior.allowed_methods for new usages."
  default     = null

  #
  # Examples:
  # allowed_http_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
  #

}
variable "cached_methods" {
  type        = list(string)
  description = "(Optional/Legacy) - Controls whether CloudFront caches the response to requests using the specified HTTP methods. Prefer default_cache_behavior.cached_methods for new usages."
  default     = null

  #
  # Examples:
  # allowed_http_methods = ["GET", "HEAD", "OPTIONS"]
  #

}
variable "acm_certificate_arn" {
  type        = string
  description = "The ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. Specify this, cloudfront_default_certificate, or iam_certificate_id. The ACM certificate must be in US-EAST-1."
}
variable "target_origin_id" {
  type        = string
  description = "(Optional/Legacy) - The origin ID used by the default cache behavior and, when origin is not set, also used as the origin domain name. Prefer origin[*].origin_id and default_cache_behavior.target_origin_id for new usages."
  default     = null
}
variable "origin" {
  type = list(object({
    domain_name              = string
    origin_id                = string
    origin_path              = optional(string, "")
    connection_attempts      = optional(number, 3)
    connection_timeout       = optional(number, 10)
    origin_access_control_id = optional(string)
    custom_header = optional(list(object({
      name  = string
      value = string
    })), [])
    custom_origin_config = optional(object({
      http_port                = optional(number, 80)
      https_port               = optional(number, 443)
      origin_protocol_policy   = optional(string, "match-viewer")
      origin_ssl_protocols     = optional(list(string), ["TLSv1.2"])
      origin_keepalive_timeout = optional(number)
      origin_read_timeout      = optional(number)
    }))
  }))
  description = "(Optional) - Origins for this CloudFront distribution. Use this argument for the modern module interface. If omitted, a legacy origin is built from target_origin_id and origin_* variables."
  default     = []

  validation {
    condition = alltrue([
      for item in var.origin : try(
        item.custom_origin_config.origin_protocol_policy == null ||
        contains(["http-only", "https-only", "match-viewer"], item.custom_origin_config.origin_protocol_policy),
        true
      )
    ])
    error_message = "origin[*].custom_origin_config.origin_protocol_policy can be [http-only | https-only | match-viewer]"
  }

  validation {
    condition = alltrue(flatten([
      for item in var.origin : (
        item.custom_origin_config == null ? [true] : [
          for protocol in item.custom_origin_config.origin_ssl_protocols :
          contains(["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"], protocol)
        ]
      )
    ]))
    error_message = "origin[*].custom_origin_config.origin_ssl_protocols can contain only [SSLv3 | TLSv1 | TLSv1.1 | TLSv1.2]"
  }
}
variable "default_cache_behavior" {
  type = object({
    allowed_methods            = optional(list(string))
    cached_methods             = optional(list(string))
    target_origin_id           = optional(string)
    viewer_protocol_policy     = optional(string)
    compress                   = optional(bool)
    cache_policy_id            = optional(string)
    origin_request_policy_id   = optional(string)
    response_headers_policy_id = optional(string)
    min_ttl                    = optional(number)
    default_ttl                = optional(number)
    max_ttl                    = optional(number)
    smooth_streaming           = optional(bool)
    trusted_key_groups         = optional(list(string))
    trusted_signers            = optional(list(string))
    field_level_encryption_id  = optional(string)
    realtime_log_config_arn    = optional(string)
    forwarded_values = optional(object({
      query_string            = optional(bool)
      query_string_cache_keys = optional(list(string))
      headers                 = optional(list(string))
      cookies = optional(object({
        forward           = string
        whitelisted_names = optional(list(string))
      }))
    }))
  })
  description = "(Optional) - Default cache behavior for the distribution. This is the recommended interface for new usages and maps to aws_cloudfront_distribution.default_cache_behavior."
  default     = null

  validation {
    condition = try(
      var.default_cache_behavior.viewer_protocol_policy == null ||
      contains(["allow-all", "https-only", "redirect-to-https"], var.default_cache_behavior.viewer_protocol_policy),
      true
    )
    error_message = "default_cache_behavior.viewer_protocol_policy can be [allow-all | https-only | redirect-to-https]"
  }
}
variable "response_headers_policy_id" {
  type        = string
  description = "(Optional) - Response headers policy ID to attach to the default cache behavior. default_cache_behavior.response_headers_policy_id has precedence when both are set."
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# CUSTOM VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "description" {
  type        = string
  description = "(Optional) - Any comments you want to include about the distribution."
  default     = ""
}
variable "http_version" {
  type        = string
  description = "(Optional) - The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3 and http3. The default is http2."
  default     = "http2"
  validation {
    condition     = contains(["http1.1", "http2", "http2and3", "http3"], var.http_version)
    error_message = "http_version can be [http1.1 | http2 | http2and3 | http3]"
  }
}
variable "viewer_protocol_policy" {
  type        = string
  description = "(Required) - Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https."
  default     = "redirect-to-https"
  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.viewer_protocol_policy)
    error_message = "viewer_protocol_policy can be [allow-all | https-only | redirect-to-https]"
  }
}
variable "origin_protocol_policy" {
  type        = string
  description = "(Required) - The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer."
  default     = "match-viewer"
  validation {
    condition     = contains(["http-only", "https-only", "match-viewer"], var.origin_protocol_policy)
    error_message = "origin_protocol_policy can be [http-only | https-only | match-viewer]"
  }
}
variable "compress" {
  type        = bool
  description = "(Optional) - Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header (default: false)."
  default     = false
}
variable "geo_restriction_locations" {
  type        = list(string)
  description = "(Optional) The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist)."
  default     = null
}
variable "geo_restriction_type" {
  type        = string
  description = "(Required) - The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist."
  default     = "none"
  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.geo_restriction_type)
    error_message = "geo_restriction_type can be [none | whitelist | blacklist]"
  }
}
variable "origin_ssl_protocols" {
  type        = string
  description = "(Required) - The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. A list of one or more of SSLv3, TLSv1, TLSv1.1, and TLSv1.2."
  default     = "TLSv1.2"
  validation {
    condition     = contains(["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"], var.origin_ssl_protocols)
    error_message = "origin_ssl_protocols can be [SSLv3 | TLSv1 | TLSv1.1 | TLSv1.2]"
  }
}
variable "minimum_protocol_version" {
  type        = string
  description = "(Optional) The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Default is TLSv1.2_2021"
  default     = "TLSv1.2_2021"
  validation {
    condition     = contains(["TLSv1", "TLSv1_2016", "TLSv1.1_2016", "TLSv1.2_2018", "TLSv1.2_2019", "TLSv1.2_2021"], var.minimum_protocol_version)
    error_message = "minimum_protocol_version can be [TLSv1 | TLSv1_2016 | TLSv1.1_2016 | TLSv1.2_2018 | TLSv1.2_2019 | TLSv1.2_2021]"
  }
}
variable "ssl_support_method" {
  type        = string
  description = "(Required) Specifies how you want CloudFront to serve HTTPS requests. One of vip or sni-only. "
  default     = "sni-only"
}
variable "default_cache_ttl" {
  type        = number
  description = "(Optional) The default amount of time, in seconds, that you want objects to stay in the CloudFront cache before CloudFront sends another request to the origin to see if the object has been updated."
  default     = 0
}
variable "max_cache_ttl" {
  type        = number
  description = "(Optional) The maximum amount of time, in seconds, that objects stay in the CloudFront cache before CloudFront sends another request to the origin to see if the object has been updated."
  default     = 0
}
variable "min_cache_ttl" {
  type        = number
  description = "(Required) The minimum amount of time, in seconds, that you want objects to stay in the CloudFront cache before CloudFront sends another request to the origin to see if the object has been updated."
  default     = 0
}
variable "connection_attempts" {
  type        = number
  description = "(Optional) - The number of times that CloudFront attempts to connect to the origin. Must be between 1-3. Defaults to 3."
  default     = 3
}
variable "connection_timeout" {
  type        = number
  description = "(Optional) - The number of seconds that CloudFront waits when trying to establish a connection to the origin. Must be between 1-10. Defaults to 10."
  default     = 10
}
variable "origin_path" {
  type        = string
  description = "(Optional) - An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin."
  default     = ""
}
variable "http_port" {
  type        = number
  description = "(Required) - The HTTP port the custom origin listens on."
  default     = 80
}
variable "https_port" {
  type        = number
  description = "(Required) - The HTTPS port the custom origin listens on."
  default     = 443
}
variable "default_root_object" {
  type        = string
  description = "(Optional) - The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  default     = ""
}
variable "headers" {
  type        = list(string)
  description = "(Optional) Object that contains a list of header names. See Items for more information."
  default     = ["*"]
}
