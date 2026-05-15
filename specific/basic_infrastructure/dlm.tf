# ---------------------------------------------------------------------------------------------------------------------
# DATA LIFECYCLE MANAGER
# ---------------------------------------------------------------------------------------------------------------------
# Default
module "DLMDefault" {
  source       = "../../general/ec2/dlm"
  name         = "${var.enterprise_context.vertical_initials}-dlm-${lower(local.common_tags.Ambiente)}-default"
  role_name    = "${upper(var.enterprise_context.vertical_initials)}ServiceRoleForDLM"
  default_tags = local.common_tags
  copy_tags    = true
  target_tags = {
    Snapshot = "yes"
  }
}