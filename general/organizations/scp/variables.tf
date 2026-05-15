# ---------------------------------------------------------------------------------------------------------------------
# DEFAULTS VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# SCP'S VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "all_outside_region_prod" {
  description = "Security policies to deny all access outside of region to production environment"
  type        = any
  default     = []
}
variable "all_outside_region_sdlc" {
  description = "Security policies to deny all access outside of region to SDLC environment"
  type        = any
  default     = []
}
variable "accesskey_root" {
  description = "The root user should not have access keys per AWS security best practices."
  type        = any
  default     = []
}
variable "accesskey" {
  description = "Users should not have access keys per AWS security best practices."
  type        = any
  default     = []
}
variable "iam_user" {
  description = "IAM Users should not be created in environmnents with AWS Organizations"
  type        = any
  default     = []
}
variable "ebs_default_encrypt" {
  description = "Security policies require that all EBS volumes are encrypted by default"
  type        = any
  default     = []
}
variable "leave_delete_organizations" {
  description = "Restrict organization leave, delete, and remove actions to an infrastructure automation framework role and/or administrator role"
  type        = any
  default     = []
}
variable "create_modify_delete_cloudtrail" {
  description = "Restrict CloudTrail actions to specific CloudTrails that are required by the security or compliance teams"
  type        = any
  default     = []
}
variable "iam_identity_center_create_instance" {
  description = "Prevent creation of new account instances of IAM Identity Center"
  type        = any
  default     = []
}
