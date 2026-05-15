# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "domain_name" {
  type        = string
  description = "(Required) Domain name for which the certificate should be issued"
}
variable "zone_id" {
  description = "(Required) The ID of the hosted zone to contain this record. Required when validating via Route53"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default     = {
    CreatedBy = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/acm"
  }
}
variable "subject_alternative_names" {
  description = "(Optional) Set of domains that should be SANs in the issued certificate. "
  type        = list(string)
  default     = []
}
variable "description" {
  type        = string
  description = "(Optional) Description of S3 Bucket"
  default     = "Certificate ACM for domain"
}