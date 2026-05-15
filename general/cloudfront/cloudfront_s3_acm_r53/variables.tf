# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "domain" {
  type        = string
  description = "(Required) Default domain for S3 Static Website"
}
variable "hostname" {
  type        = string
  description = "(Required) Default Hostname for  Static Website"
}
variable "region" {
  type        = string
  description = "(Required) Region from S3 Bucket"
}

# ---------------------------------------------------------------------------------------------------------------------
# AMAZON S3 VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "index_file" {
  type        = string
  description = "(Required) Index fie fot the website"
  default     = "index.html"
}
variable "error_file" {
  type        = string
  description = "(Required) Error file for the website"
  default     = "error.html"
}
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/cloudfront/cloudfront_s3_acm"
  }
}
variable "bucket_description" {
  type        = string
  description = "(Optional) Description of S3 Bucket"
  default     = "S3 bucket for Static Website"
}
variable "allowed_origins" {
  type        = list(string)
  description = "(Required) Set of origins you want customers to be able to access the bucket from."
  default     = ["*"]

  #
  # Examples:
  # allowed_origins = ["*"]
  #

}
variable "allowed_headers" {
  type        = list(string)
  description = "(Optional) Set of Headers that are specified in the Access-Control-Request-Headers header."
  default     = ["*"]

  #
  # Examples:
  # allowed_headers = ["*"]
  #

}
variable "expose_headers" {
  type        = list(string)
  description = "(Optional) Set of headers in the response that you want customers to be able to access from their applications (for example, from a JavaScript XMLHttpRequest object)."
  default     = []

  #
  # Examples:
  # expose_headers = ["XMLHttpRequest"]
  # expose_headers = ["*"]
  #

}
variable "max_age_seconds" {
  type        = number
  description = "(Optional) The time in seconds that your browser is to cache the preflight response for the specified resource."
  default     = 3000

  #
  # Examples:
  # max_age_seconds = 3000
  #

}

# ---------------------------------------------------------------------------------------------------------------------
# AMAZON ACM VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "acm_description" {
  type        = string
  description = "(Optional) Description of ACM"
  default     = "ACM Certificate for"
}
variable "subject_alternative_names" {
  type        = list(string)
  description = "(Optional) Alternative names for ACM"
  default     = []
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUDFRONT VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "cloudfront_description" {
  type        = string
  description = "(Optional) Description of Cloudfront"
  default     = "Cloudfront Distribution"
}
variable "cloudfront_alias" {
  type        = string
  description = "(Optional) Alternative names for CloudFront"
  default     = null
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
  default     = 3600
}
variable "max_cache_ttl" {
  type        = number
  description = "(Optional) The maximum amount of time, in seconds, that objects stay in the CloudFront cache before CloudFront sends another request to the origin to see if the object has been updated."
  default     = 3600

}
variable "min_cache_ttl" {
  type        = number
  description = "(Required) The minimum amount of time, in seconds, that you want objects to stay in the CloudFront cache before CloudFront sends another request to the origin to see if the object has been updated."
  default     = 1
}
variable "allowed_http_methods" {
  type        = list(string)
  description = "(Required) Allowed HTTP methods to website."
  default     = ["HEAD", "GET"]

  #
  # Examples:
  # allowed_http_methods = ["HEAD", "GET", "PUT", "POST", "DELETE"]
  #

}
variable "cache_methods" {
  type        = list(string)
  description = "(Required) Cache methods."
  default     = ["HEAD", "GET"]

  #
  # Examples:
  # allowed_http_methods = ["HEAD", "GET", "PUT", "POST", "DELETE"]
  #

}
variable "cache_policy_name" {
  type        = string
  description = "(Optional) Cache policy Name."
  default     = "custom-cachepolicy"
}