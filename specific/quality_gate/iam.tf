data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [for account in var.allowed_accounts : "arn:aws:iam::${account}:root"]
    }
  }
}

data "aws_iam_policy_document" "quality_gate_policy" {
  statement {
    sid     = "S3BucketLevelAccess"
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      module.S3TerraformQualityGateCommunications.bucket_arn,
      module.S3TerraformQualityGateRecords.bucket_arn,
      module.S3TerraformQualityGateInputJsons.bucket_arn
    ]
  }

  statement {
    sid     = "S3ObjectLevelAccess"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:GetObjectVersion"]
    resources = [
      "${module.S3TerraformQualityGateCommunications.bucket_arn}/*",
      "${module.S3TerraformQualityGateRecords.bucket_arn}/*",
      "${module.S3TerraformQualityGateInputJsons.bucket_arn}/*"
    ]
  }

  statement {
    sid     = "SQSReadWrite"
    effect  = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:DeleteMessage",
      "sqs:PurgeQueue",
      "sqs:GetQueueAttributes"
    ]
    resources = concat(
      aws_sqs_queue.QualityGateInput[*].arn,
      [aws_sqs_queue.QualityGateOutput.arn]
    )
  }
}

resource "aws_iam_role" "quality_gate_role" {
  name               = "quality-gate-aws-iam-role-${local.environment}-otm-container-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy" "quality_gate_inline_policy" {
  name   = "quality-gate-policy"
  role   = aws_iam_role.quality_gate_role.id
  policy = data.aws_iam_policy_document.quality_gate_policy.json
}
