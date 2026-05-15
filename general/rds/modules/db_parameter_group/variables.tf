# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}
variable "name" {
  type        = string
  description = "Name for Parameter Group"
  default     = null
}
variable "description" {
  type        = string
  description = "Description for Parameter Group"
  default     = null
}
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default     = null
}
variable "engine_version" {
  type        = string
  description = "(Optional) The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10)."
  default     = null
}
variable "family" {
  description = "(Required, Forces new resource) The family of the DB parameter group."
  type        = string
  default     = null
}
variable "parameters" {
  description = "(Optional) A list of DB parameters to apply. Note that parameters may differ from a family to an other. Full list of all parameters can be discovered via aws rds describe-db-parameters after initial creation of the group."
  type        = list(map(string))
  default     = []
}