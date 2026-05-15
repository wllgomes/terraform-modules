# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "display_name" {
  type        = string
  description = "User display name"
}
variable "description" {
  type        = string
  description = "Description for SSO group"
}
variable "members" {
  type        = list(string)
  description = "Members for group"
}
