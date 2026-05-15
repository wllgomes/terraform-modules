# Terraform cloud
data "aws_iam_policy_document" "terraform_cloud_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/app.terraform.io"]
    }

    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = ["organization:azure0511:project:*:workspace:*:run_phase:*"]
    }
  }
}


resource "aws_iam_policy" "terraform_cloud_custom_policy" {
  name        = "terraform_cloud_custom_policy"
  path        = "/"
  description = "Terraform Cloud Custom Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = var.policy
}
