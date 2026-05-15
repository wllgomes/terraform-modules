# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "(Required) Name of the trail."
}
variable "s3_bucket_name" {
  type        = string
  description = "(Required) Name of the S3 bucket designated for publishing log files."
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
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/cloudtrail"
  }
}
variable "s3_key_prefix" {
  type        = string
  description = "(Optional) S3 key prefix that follows the name of the bucket you have designated for log file delivery."
  default     = ""
}
variable "kms_key_id" {
  type        = string
  description = "(Optional) KMS key ARN to use to encrypt the logs delivered by CloudTrail."
  default     = ""
}
variable "include_global_service_events" {
  type        = bool
  description = "(Optional) Whether the trail is publishing events from global services such as IAM to the log files. Defaults to true."
  default     = true
}
variable "is_multi_region_trail" {
  type        = bool
  description = "(Optional) Whether the trail is created in the current region or in all regions. Defaults to false."
  default     = false
}
variable "is_organization_trail" {
  type        = string
  description = "(Optional) Whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account. Defaults to false."
  default     = false
}
variable "enable_log_file_validation" {
  type        = string
  description = "(Optional) Whether log file integrity validation is enabled. Defaults to false."
  default     = false
}