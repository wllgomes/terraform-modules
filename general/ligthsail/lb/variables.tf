# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "lb_name" {
  type        = string
  description = "(Required) The name of the Lightsail load balancer."
}
variable "instance_port" {
  type        = number
  description = "(Required) The instance port the load balancer will connect."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/lightsail-lb"
  }
}
variable "ip_type" {
  type        = string
  description = "(Optional) The IP address type of the Lightsail Instance. Valid Values: dualstack | ipv4."
  default     = "ipv4"
}
variable "lb_instances_name" {
  type        = list(string)
  description = "(Required) The name of the instance to attach to the load balancer."
  default     = null
}
variable "health_path" {
  type        = string
  description = "(Optional) The health check path of the load balancer. Default value '/'."
  default     = "/"
}
variable "cookie_status" {
  type        = bool
  description = "(Required) - The Session Stickiness state of the load balancer. true to activate session stickiness or false to deactivate session stickiness."
  default     = true
}
variable "cookie_duration" {
  type        = number
  description = "(Required) The cookie duration in seconds. This determines the length of the session stickiness."
  default     = 900
}