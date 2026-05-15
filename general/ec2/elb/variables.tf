# ---------------------------------------------------------------------------------------------------------------------
# CONTROL VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "create_lb" {
  description = "Controls if the Load Balancer should be created"
  type        = bool
  default     = true
}

# ---------------------------------------------------------------------------------------------------------------------
# LOAD BALANCERS VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "lb" {
  description = "(Required) Provides a Load Balancer resource."
  type        = any
  default     = []
}
variable "listener" {
  description = "(Required) Provides a Load Balancer Listener resource."
  type        = any
  default     = []
}
variable "listener_rules" {
  description = "Provides a Load Balancer Listener Rule resource."
  type        = any
  default     = []
}
variable "listener_rules_certificate" {
  description = "Provides a Load Balancer Listener Certificate resource."
  type        = any
  default     = []
}
variable "target_groups" {
  description = "(Required) A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port."
  type        = any
  default     = []
}
variable "targets" {
  description = "(Required) Provides the ability to register instances and containers with an Application Load Balancer (ALB) or Network Load Balancer (NLB) target group."
  type        = any
  default     = []
}
variable "access_logs" {
  description = "(Optional) Map containing access logging configuration for load balancer."
  type        = any
  default     = []
}
variable "subnet_mapping" {
  description = "(Optional) A list of subnet mapping blocks describing subnets to attach to network load balancer"
  type        = any
  default     = []
}