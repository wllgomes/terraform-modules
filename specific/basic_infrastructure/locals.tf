locals {
  common_tags = {
    ManagedBy = "terraform"
    Vertical  = var.enterprise_context.vertical
    Ambiente  = var.enterprise_context.environment
    Cliente   = var.enterprise_context.client
    Projeto   = var.enterprise_context.project
    CC        = var.enterprise_context.cc
  }
}
