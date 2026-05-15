#https://www.terraform.io/docs/language/values/variables.html

variable "aws_region" {
  type        = string
  description = "region"
}

variable "enterprise_context" {
  type = map(string)
  validation {
    condition = alltrue([
      contains(["ene", "sid", "log", "ena", "data"], var.enterprise_context.vertical_initials),
      contains(["energia", "siderurgia", "logistica", "enacom", "data"], var.enterprise_context.vertical),
      contains(["dev", "hml", "prd"], var.enterprise_context.environment)
    ])
    error_message = "enterprise_context parameter are invalid, see README.md to more details"
  }
}

variable "custom_pipeline_iam_policy" {
  type = string
}

variable "vpc_cidr_24_suffix" {
  type        = string
  description = "(Required) First three blocks of CIDR"
}

variable "state_bucket_suffix" {
  type        = string
  description = "The suffix of the state bucket"

  default = ""
}

variable "create_database_subnets" {
  description = "If database subnets will be created"
  type        = bool
  default     = false
}

variable "peering_connection_accepters" {
  description = "Peering Connection Accepters"
  type = list(object({
    name       = string
    id         = string
    cidr_block = string
  }))
  default = []
}

variable "vpc_flow_traffic_types" {
  type    = set(string)
  default = []

  validation {
    condition = alltrue([
      length(setsubtract(var.vpc_flow_traffic_types, ["ACCEPT", "REJECT"])) == 0
    ])

    error_message = "vpc_flow parameter must have only 'ACCEPT' or/and 'REJECT'"
  }
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key file"
  default     = ""
}

variable "use_nat_instance" {
  description = "Use NAT Instance instead of NAT Gateway"
  type        = bool
  default     = false
}

variable "additional_nat_instance_egress_with_cidr_blocks" {
  description = "Use NAT Instance instead of NAT Gateway"
  type        = list(map(string))
  default     = []
}

variable "ebs_size" {
  type        = string
  description = "(Option) Size of EBS root volume"
  default     = 10
}