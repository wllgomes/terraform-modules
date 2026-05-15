# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "subnets_ids" {
  type        = list(string)
  description = "(Required) A list of VPC subnet IDs."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default     = null
}
variable "name" {
  type        = string
  description = "(Optional, Forces new resource) The name of the DB subnet group. If omitted, Terraform will assign a random, unique name."
  default     = "subnet-group"
}
variable "description" {
  description = "The description of the DB subnet group"
  type        = string
  default     = null
}