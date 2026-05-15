locals {
  common_tags = {
    ManagedBy = "terraform"
    Vertical  = var.enterprise_context.vertical
    Ambiente  = var.enterprise_context.environment
    Cliente   = "enacom"
  }

  vertical_initials = var.enterprise_context.vertical_initials
  environment       = var.enterprise_context.environment
}
