# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "(Optional, Forces new resource) Friendly name of the role. If omitted, Terraform will assign a random, unique name."
}
variable "principal_arn" {
  type        = string
  description = "(Required) Principal ARN for assume this role."

  # Examples:
  #
  # principal_arn = "arn:aws:iam::121212121212:root"
  # principal_arn = "arn:aws:iam::121212121212:role/ExampleRole"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/iam/service_roles"
  }
}
variable "description" {
  type        = string
  description = "(Optional) Description of the role."
  default     = ""
}
variable "managed_policy_arns" {
  type        = list(string)
  description = "(Optional) Set of exclusive IAM managed policy ARNs to attach to the IAM role."
  default     = null
}
variable "permissions_boundary" {
  type        = string
  description = "(Optional) ARN of the policy that is used to set the permissions boundary for the role."
  default     = null
}
variable "external_id" {
  type        = string
  description = "(Optional) External ID for Role"
  default     = null
}
variable "customer_inline" {
  type        = any
  description = "(Optional) Provides an IAM role inline policy."
  default     = null
}
variable "customer_inline_name" {
  description = "(Optional) Set inline policy name"
  type        = string
  default     = "inline-policy"
}