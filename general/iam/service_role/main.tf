# IAM Role
resource "aws_iam_role" "this" {
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
          Service = var.assume_role_service
        }
      }
    ]
  })
  permissions_boundary = var.permissions_boundary
}
resource "aws_iam_instance_profile" "this" {
  count = var.assume_role_service == "ec2.amazonaws.com" ? 1 : 0
  name  = var.name
  role  = aws_iam_role.this.name
}
resource "aws_iam_role_policy" "this" {
  count  = var.customer_inline != null ? 1 : 0
  name   = try(var.customer_inline_name, "InlinePolicy")
  role   = aws_iam_role.this.id
  policy = var.customer_inline

  depends_on = [aws_iam_role.this]
}
resource "aws_iam_role_policy_attachments_exclusive" "this" {
  count       = var.managed_policy_arns != null ? 1 : 0
  role_name   = aws_iam_role.this.name
  policy_arns = var.managed_policy_arns
}