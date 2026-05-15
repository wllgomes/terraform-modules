# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "The name of the records."
}
variable "records" {
  type        = list(string)
  description = "Records values"
  default     = []

  # Examples:
  #
  #  records = [
  #       "example1.com",
  #        example1.io
  #  ]
  #
  #  records = [
  #       "200.1.2.3",
  #       "200.1.2.4"
  #  ]

}
variable "zone_id" {
  description = "A zone ID to create the records in"
  type        = string

  # Example:
  #
  # zone_id = "zoneid"
}
variable "type" {
  description = "Type of the record. Valid values are A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT."
  type        = string
  validation {
    condition     = var.type == "A" || var.type == "AAAA" || var.type == "CAA" || var.type == "CNAME" || var.type == "DS" || var.type == "MX" || var.type == "NAPTR" || var.type == "NS" || var.type == "PTR" || var.type == "SOA" || var.type == "SPF" || var.type == "SRV" || var.type == "TXT"
    error_message = "Valid values are A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT."
  }

  # Examples:
  #
  # type = "A"
  # type = "CNAME"
  # type = "TX"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "allow_overwrite" {
  description = "Default allow_overwrite value valid for all record sets."
  type        = bool
  default     = false
}
variable "default_ttl" {
  description = "The default TTL ( Time to Live ) in seconds that will be used for all records that support the ttl parameter."
  type        = number
  default     = 3600 # (1 Hour)
}
variable "alias" {
  type        = string
  description = "Alias name"
  default     = null
}
variable "alias_zone_id" {
  type        = string
  description = "Alias zone id"
  default     = null
}
variable "evaluate_target_health" {
  type        = bool
  description = "Enable target health check"
  default     = false
}
