# IAM Role without external ID
resource "aws_iam_role" "this" {
  count       = var.external_id == null ? 1 : 0
  name        = var.name
  description = var.description
  tags        = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole"
        ],
        Principal = {
          "AWS" : var.principal_arn
        },
        "Condition" : {
        }
      }
    ]
  })
  permissions_boundary = var.permissions_boundary
}
resource "aws_iam_role_policy" "this" {
  count  = var.customer_inline != null && var.external_id == null ? 1 : 0
  name   = try(var.customer_inline_name, "InlinePolicy")
  role   = aws_iam_role.this[count.index].id
  policy = var.customer_inline

  depends_on = [aws_iam_role.this]
}
resource "aws_iam_role_policy_attachments_exclusive" "this" {
  count       = var.external_id == null && var.managed_policy_arns != null ? 1 : 0
  role_name   = aws_iam_role.this[count.index].id
  policy_arns = var.managed_policy_arns
}

# IAM Role with external ID
resource "aws_iam_role" "this_externalID" {
  count       = var.external_id != null ? 1 : 0
  name        = var.name
  description = var.description
  tags        = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole"
        ],
        Principal = {
          "AWS" : var.principal_arn
        },
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : var.external_id
          }
        }
      }
    ]
  })
  permissions_boundary = var.permissions_boundary
}
resource "aws_iam_role_policy" "this_externalID" {
  count  = var.customer_inline != null && var.external_id != null ? 1 : 0
  name   = try(var.customer_inline_name, "InlinePolicy")
  role   = aws_iam_role.this_externalID[count.index].id
  policy = var.customer_inline

  depends_on = [aws_iam_role.this_externalID]
}
resource "aws_iam_role_policy_attachments_exclusive" "this_externalID" {
  count       = var.external_id != null && var.managed_policy_arns != null ? 1 : 0
  role_name   = aws_iam_role.this_externalID[count.index].id
  policy_arns = var.managed_policy_arns
}