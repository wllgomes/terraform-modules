# Secret Manager
resource "aws_secretsmanager_secret" "this" {
  name                    = var.name
  description             = var.description
  kms_key_id              = var.kms_id
  policy                  = var.policy
  recovery_window_in_days = var.recovery_window_in_days
  tags = merge(
    var.default_tags,
    {
      Name        = var.name
      Description = var.description
    }
  )
}