locals {
  common_tags = {
    ManagedBy = "terraform"
    Vertical  = var.enterprise_context.vertical
    Ambiente  = var.enterprise_context.environment
  }
}
