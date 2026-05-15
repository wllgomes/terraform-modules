# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "teams_webhook" {
  type        = string
  description = "Set teams webhook for Lambda Function"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/cloudcustodian-teams-notifications"
  }
}
variable "iam_role_name" {
  type        = string
  description = "Set name for IAM Role"
  default     = "IAMServiceRoleForCloudCustodianNTeamsotifications"
}
variable "iam_role_description" {
  type        = string
  description = "Set description for IAM Role"
  default     = "IAM Role for CloudCustodian notifications to Micro$oft Teams"
}
variable "iam_policy_name" {
  type        = string
  description = "Set name for IAM Policy"
  default     = "IAMPolicyForCloudCustodianNTeamsotifications"
}
variable "iam_policy_description" {
  type        = string
  description = "Set description for IAM Policy"
  default     = "IAM Policy for CloudCustodian notifications to Micro$oft Teams"
}
variable "sqs_name" {
  type        = string
  description = "Set name for SQS"
  default     = "sqs-cloudcustodian-teams-events-queue"
}
variable "sqs_batch_size" {
  type        = number
  description = "Set SQS batch size"
  default     = 1
}
variable "sqs_maximum_batching_window_in_seconds" {
  type        = number
  description = "Set SQS maximum batching window in seconds"
  default     = 10
}
variable "lambda_name" {
  type        = string
  description = "Set name for Lambda Function"
  default     = "lambda-cloudcustodian-teams-notification"
}
variable "lambda_description" {
  type        = string
  description = "Set description for Lambda Function"
  default     = "Lambda Function for customize CloudCustodian notification and send to Micro$oft Teams"
}
variable "lambda_filename" {
  type        = string
  description = "Set script (python) filename for Lambda Function"
  default     = "lambda-src/custodian_notification.zip"
}
variable "lambda_runtime" {
  type        = string
  description = "Set runtime for Lambda Function"
  default     = "python3.13"
}
variable "url_doc" {
  type        = string
  description = "Set URL for documentation of your company"
  default     = "###"
}
