# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = " (Optional) Friendly name of the new secret. The secret name can consist of uppercase letters, lowercase letters, digits, and any of the following characters: /_+=.@- Conflicts with name_prefix."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "description" {
  type        = string
  description = "(Optional) Description of the secret."
  default     = "Secret Manager created by Terraform"
}
variable "kms_id" {
  type        = string
  description = " (Optional) ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager). If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time."
  default     = ""
}
variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/secret-manager"
  }
}
variable "policy" {
  type        = string
  description = "(Optional) Valid JSON document representing a resource policy. "
  default     = null
}
variable "recovery_window_in_days" {
  type        = number
  description = " (Optional) Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30."
  default     = 30
  validation {
    condition     = var.recovery_window_in_days <= 30 && var.recovery_window_in_days >= 7
    error_message = "Value should be in the interval 7 <= session <= 30."
  }
}