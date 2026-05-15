# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "alarm_name" {
  type        = string
  description = "(Required) The descriptive name for the alarm. This name must be unique within the user's AWS account"
}
variable "threshold" {
  type        = number
  description = "(Required) The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models."
}
variable "statistic" {
  type        = string
  description = "(Required) The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
}
variable "sns_name" {
  type        = string
  description = "(Required) The name of the topic. Topic names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 256 characters long."
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
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/cloudwatch_alarms/billing"
  }
}
variable "alarm_description" {
  type        = string
  description = "(Optional) The description for the alarm."
  default     = "Cloudwatch alarm for Billing"
}
variable "evaluation_periods" {
  type        = number
  description = "(Required) The number of periods over which data is compared to the specified threshold."
  default     = 1
}
variable "datapoints_to_alarm" {
  type        = number
  description = "(Optional) The number of datapoints that must be breaching to trigger the alarm."
  default     = 1
}
variable "period" {
  type        = number
  description = "(Optional) The period in seconds over which the specified statistic is applied."
  default     = 21600 # 6 hours
}
variable "email" {
  type        = string
  description = "(Optional) E-mail address to notification with SNS topic."
  default     = ""
}