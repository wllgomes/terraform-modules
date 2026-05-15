# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/kms"
  }
}
variable "name" {
  type        = string
  description = "KMS name"
}
variable "description" {
  type        = string
  description = "Description for KMS Key"
}
variable "deletion_window_in_days" {
  type        = number
  description = "Window days to delete KMS/CMK"
  validation {
    condition     = var.deletion_window_in_days <= 30 && var.deletion_window_in_days >= 7
    error_message = "Value should be in the interval 7 <= session <= 30."
  }
}
variable "enabled" {
  type        = bool
  description = "KMS Status"
  validation {
    condition     = var.enabled == true || var.enabled == false
    error_message = "Value should be true or false"
  }
}
variable "multi_region" {
  type        = bool
  description = "KMS multi-region"
  validation {
    condition     = var.multi_region == true || var.multi_region == false
    error_message = "Value should be true or false"
  }
}
variable "enable_key_rotation" {
  type        = bool
  description = "KMS key rotation"
  validation {
    condition     = var.enable_key_rotation == true || var.enable_key_rotation == false
    error_message = "Value should be true or false"
  }
}
variable "policy" {
  type        = string
  description = "KMS key policy"
  default     = ""
}