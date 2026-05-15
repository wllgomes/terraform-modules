# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "(Required) Unique name for your Lambda Function."
}
variable "schedule" {
  type        = string
  description = "(Required) Schedule for Start/Stop instances"

  #
  # Examples:
  # cron(0 6 ? * MON-FRI *)
  #
  # Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html

}
variable "schedule_action" {
  description = "(Required) Define schedule action to apply on resources, accepted value are 'stop or 'start."
  type        = string
  default     = "stop"

  validation {
    condition     = contains(["stop", "start"], var.schedule_action)
    error_message = "Value should be stop or start"
  }
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
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/lambda/start-stop-ec2-instances"
  }
}
variable "description" {
  type        = string
  description = "(Required) Description for the Lambda Function."
  default     = ""
}
variable "enabled_kms" {
  type        = bool
  description = "(Optional) EC2 instance use KMS to encrypt EBS volumes?"
  default     = false
}
variable "kms_arn" {
  type        = string
  description = "(Optional) KMS ID for KMS Key used to encrypted EBS volumes."
  default     = "*"
}
variable "policy_name" {
  type        = string
  description = "(Optional) Policy name used in IAM Role for Lambda Function."
  default     = "CustomPolicyEC2Instances"
}
variable "eventbridge_name" {
  type        = string
  description = "(Optional) EventBridge name used to schedule Lambda Function."
  default     = ""
}
variable "role_name" {
  type        = string
  description = "(Optional) Role name used in Lambda Function.."
  default     = "ServiceRoleForLambda"
}
variable "custom_iam_role_arn" {
  description = "(Optional) Custom IAM role arn for the scheduling lambda"
  type        = string
  default     = null
}