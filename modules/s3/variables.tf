variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://github.com/wllgomes/terraform-modules/tree/main/modules/s3"
  }
}

variable "bucket_name" {
  type        = string
  description = "Bucket name"
}

variable "bucket_description" {
  type        = string
  description = "Description for Bucket S3"
}

variable "kms_master_key_id" {
  type        = string
  description = "KMS Key ID"
  default     = null
}

variable "policy" {
  type        = string
  description = "Your policy or your file policy"
  default     = null
}

variable "lifecycle_enabled" {
  type        = string
  description = "Default value for conditional on resource"
  default     = false
}

variable "status" {
  type        = string
  description = "Set Enabled or Disabled for Lifecycle Status"
  default     = "Enabled"
  validation {
    condition     = var.status == "Disabled" || var.status == "Enabled"
    error_message = "Value should be Disabled or Enabled"
  }
}

variable "versioning_status" {
  type        = string
  description = "Set Enabled or Disabled for object versioning"
  default     = "Disabled"
  validation {
    condition     = var.versioning_status == "Disabled" || var.versioning_status == "Enabled" || var.versioning_status == "Suspended"
    error_message = "Value should be Disbled, Enabled or Suspended"
  }
}

variable "standard-ia-days" {
  type        = number
  description = "Set days for transiction to STANDARD_IA Storage Class"
  default     = 0
  validation {
    condition     = can(regex("^-?[[:digit:]]+$", var.standard-ia-days))
    error_message = "Only numbers allowed."
  }
}

variable "glacier-days" {
  type        = number
  description = "Set days for transiction to Glacier Storage Class"
  default     = 0
  validation {
    condition     = can(regex("^-?[[:digit:]]+$", var.glacier-days))
    error_message = "Only numbers allowed."
  }
}

variable "expiration-days" {
  type        = number
  description = "Set days for expiration objects"
  default     = 0
  validation {
    condition     = can(regex("^-?[[:digit:]]+$", var.expiration-days))
    error_message = "Only numbers allowed."
  }
}

variable "website_enabled" {
  type        = string
  description = "Set true of false"
  default     = false
  validation {
    condition     = var.website_enabled == "true" || var.website_enabled == "false"
    error_message = "Value should be true or false"
  }
}

variable "website_index_file" {
  type        = string
  description = "Set index file fot Website"
  default     = "index.html"
}

variable "website_error_file" {
  type        = string
  description = "Set error file fot Website"
  default     = "error.html"
}

variable "force_destroy" {
  type        = bool
  description = "force destroy on S3"
  default     = false
}
