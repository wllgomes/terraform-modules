data "aws_caller_identity" "current" {}

data "aws_kms_key" "ebs" {
  key_id = "alias/${var.enterprise_context.vertical_initials}-kms-${lower(local.common_tags.Ambiente)}-ebs"
}
