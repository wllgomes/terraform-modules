#https://www.terraform.io/docs/language/values/variables.html

variable "aws_region" {
  type        = string
  description = "region"
}
variable "enterprise_context" {
  type = map(string)
  validation {
    condition = alltrue([
      contains(["ene", "sid", "log", "ena"], var.enterprise_context.vertical_initials),
      contains(["energia", "siderurgia", "logistica", "enacom", "data"], var.enterprise_context.vertical),
      contains(["dev", "hml", "prd", "qa"], var.enterprise_context.environment)
    ])
    error_message = "enterprise_context parameter are invalid, see README.md to more details"
  }
}
variable "client_name" {
  type        = string
  description = "Client Name"
}
variable "vpc_cidr_24_suffix" {
  type        = string
  description = "(Required) First three blocks of CIDR"
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
variable "acm_arn" {
  type        = string
  description = "ACM ARN"
}
variable "load_balancer_idle_timeout" {
  description = "load balancer idle timeout"
  default     = 60
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
variable "use_nat_instance" {
  description = "Use NAT Instance instead of NAT Gateway"
  type        = bool
  default     = false
}
variable "auto_on" {
  description = "Define if the instance should be turned on automatically"
  type        = string
  default     = "True"
}

variable "auto_off" {
  description = "Define if the instance should be turned off automatically"
  type        = string
  default     = "True"
}
variable "additional_nat_instance_egress_with_cidr_blocks" {
  description = "Use NAT Instance instead of NAT Gateway"
  type        = list(map(string))
  default     = []
}

variable "subnets_backend_cidr" {
  type        = list(string)
  default     = null
  description = "Lista opcional de subnets para o backend. Se não definida, usa o padrão."
}

variable "subnets_frontend_cidr" {
  type        = list(string)
  default     = null
  description = "Lista opcional de subnets para o frontend. Se não definida, usa o padrão."
}