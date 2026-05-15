# Terraform Cloud
resource "aws_iam_openid_connect_provider" "terraform_cloud" {
  url = "https://app.terraform.io"

  client_id_list = [
    "aws.workload.identity",
  ]

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]

  tags = local.common_tags
}

resource "aws_iam_role" "terraform_cloud_role" {
  name = lower("${var.enterprise_context.vertical}-${var.enterprise_context.environment}-terraform-cloud")

  assume_role_policy = data.aws_iam_policy_document.terraform_cloud_assume_role_policy.json

  tags = local.common_tags
}
resource "aws_iam_role_policy_attachment" "terraform_cloud_attach_custom" {
  role       = aws_iam_role.terraform_cloud_role.name
  policy_arn = aws_iam_policy.terraform_cloud_custom_policy.arn
}
resource "aws_iam_role_policy_attachment" "terraform_cloud_read_only" {
  role       = aws_iam_role.terraform_cloud_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
