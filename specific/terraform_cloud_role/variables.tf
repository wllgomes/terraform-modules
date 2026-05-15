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

variable "policy" {
  type = string
}
