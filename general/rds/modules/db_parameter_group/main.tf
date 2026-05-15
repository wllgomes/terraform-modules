# ---------------------------------------------------------------------------------------------------------------------
# PARAMETER GROUPS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_db_parameter_group" "this" {
  count       = var.create ? 1 : 0
  name        = var.name
  description = var.description
  family      = var.family
  tags = merge(
    var.tags,
    {
      "Name"        = var.name
      "Description" = var.description
    }
  )

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}