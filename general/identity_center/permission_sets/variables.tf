# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/sso"
  }
}
variable "name" {
  type        = string
  description = "Name for Permission Set"
}
variable "description" {
  type        = string
  description = "Description for Permission Set"
}
variable "session_duration_hours" {
  type        = number
  description = "Session duration for Permission Set (in hours)"
  validation {
    condition     = var.session_duration_hours <= 12 && var.session_duration_hours >= 1
    error_message = "Value should be in the interval 1 <= session <= 12."
  }
}
variable "managed_policies_arn" {
  type        = list(string)
  description = "List of ARNs of AWS Managed Policies what will be applied on Permission Set"
}
variable "group_assignments" {
  type        = map(any)
  description = "Group Principal ID for assign in AWS Account"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "relay_state" {
  type        = string
  default     = null
  description = "(Optional) URL what the user it will be redirect after assume role"
}
variable "inline_policy" {
  type        = string
  default     = null
  description = "(Optional) IAM Policy in JSON it will be associate in Permission Set"
}
