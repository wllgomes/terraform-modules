# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/route53/zones"
  }
}
variable "name" {
  type        = string
  description = "The name of the hosted zone."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "comment" {
  type        = string
  description = "Comment for hosted_zone"
  default     = "Manged  by Terraform"
}
variable "vpc_ids" {
  description = "A list of IDs of VPCs to associate with a private hosted zone"
  type        = list(string)
  default     = []

  # Example:
  #
  # vpc_ids = [
  #   "vpc-56a5ec2c",
  #   "vpc-23a7efga"
  # ]
}