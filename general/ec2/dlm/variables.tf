# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "The name of the records."
}
variable "target_tags" {
  type        = map(string)
  description = "Default Tags"

  # Example:
  #   target_tags = {
  #     Snapshot = "yes"
  #}

}
variable "execution_role_arn" {
  type        = string
  description = "IAM Role ARN used by Data Lifecycle Manager (Only with create_role == false)."
  default     = ""

  # Example:
  #
  # execution_role_arn = "arn:aws:iam::123456789123:role/DLMRoleDefault"
  #
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "create_role" {
  type        = bool
  description = "Determine if DLM used new IAM Role or exist IAM Role"
  default     = true
}
variable "policy_arn" {
  type        = string
  description = "Policy ARN for IAM Role (Default AWS Managed Policy)."
  default     = "arn:aws:iam::aws:policy/service-role/AWSDataLifecycleManagerServiceRole"
}
variable "role_name" {
  type        = string
  description = "Name for IAM Role used by Data Lifecycle Manager."
  default     = "DLMRoleDefault"
}
variable "state" {
  type        = string
  description = " (Optional) Whether the lifecycle policy should be enabled or disabled. ENABLED or DISABLED are valid values. Defaults to ENABLED."
  default     = "ENABLED"
  validation {
    condition     = var.state == "ENABLED" || var.state == "DISABLED"
    error_message = "ENABLED or DISABLED are valid values"
  }
}
variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/ec2/dlm"
  }
}
variable "add_tags" {
  type        = map(string)
  description = "(Optional) A map of tag keys and their values. DLM lifecycle policies will already tag the snapshot with the tags on the volume. This configuration adds extra tags on top of these."
  default = {
    SnapshotCreator = "DLM to EBS Volumes"
  }
}
variable "description" {
  type        = string
  description = "Description for DLM"
  default     = "Data Lifecycle Manager for EC2 EBS Volumes"
}
variable "schedule_name" {
  type        = string
  description = "(Required) A name for the schedule."
  default     = "dlm-default"
}
variable "copy_tags" {
  type        = bool
  description = "(Optional) Whether to copy all user-defined tags from the source snapshot to the cross-region snapshot copy."
  default     = false
}
variable "interval" {
  type        = number
  description = "(Optional) How often this lifecycle policy should be evaluated. 1, 2,3,4,6,8,12 or 24 are valid values."
  default     = "24"
}
variable "times" {
  type        = list(string)
  description = "(Optional) A list of times in 24 hour clock format that sets when the lifecycle policy should be evaluated. Max of 1."
  default     = ["23:00"]
}
variable "retain" {
  type        = number
  description = "(Required) See the retain_rule block. Max of 1 per schedule."
  default     = "2" # RECOMENDED (Remember, snapshot not is Backup Strategy)
}
