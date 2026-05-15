# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "display_name" {
  type        = string
  description = "User display name"
}
variable "email" {
  type        = string
  description = "User email"
}
variable "first_name" {
  type        = string
  description = "User first name"
}
variable "last_name" {
  type        = string
  description = "User last name"
}
