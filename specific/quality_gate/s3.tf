data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "allow_matheus_put_object_records" {
  statement {
    sid    = "AllowMatheusVieiraPutObject"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::337842449453:user/matheus.vieira",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/quality-gate-aws-iam-role-${local.environment}-ecs-task-role"
      ]
    }
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
      "s3:ListBucketVersions",
      "s3:DeleteObjectVersion"
    ]
    resources = [
      "arn:aws:s3:::${local.vertical_initials}-s3-${local.environment}-quality-gate-records",
      "arn:aws:s3:::${local.vertical_initials}-s3-${local.environment}-quality-gate-records/*"
    ]
  }
}

data "aws_iam_policy_document" "allow_matheus_put_object_input_jsons" {
  statement {
    sid    = "AllowMatheusVieiraPutObject"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::337842449453:user/matheus.vieira",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/quality-gate-aws-iam-role-${local.environment}-ecs-task-role"
      ]
    }
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
      "s3:ListBucketVersions",
      "s3:DeleteObjectVersion"
    ]
    resources = [
      "arn:aws:s3:::${local.vertical_initials}-s3-${local.environment}-quality-gate-input-jsons",
      "arn:aws:s3:::${local.vertical_initials}-s3-${local.environment}-quality-gate-input-jsons/*"
    ]
  }
}

module "S3TerraformQualityGateCommunications" {
  source             = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/s3"
  bucket_name        = "${local.vertical_initials}-s3-${local.environment}-quality-gate-communications"
  bucket_description = "Bucket for store file of QualityGate ${local.vertical_initials}-${local.environment}"
  default_tags       = local.common_tags
  versioning_status  = "Disabled"
}

module "S3TerraformQualityGateRecords" {
  source             = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/s3"
  bucket_name        = "${local.vertical_initials}-s3-${local.environment}-quality-gate-records"
  bucket_description = "Bucket for store file of QualityGate ${local.vertical_initials}-${local.environment}"
  default_tags       = local.common_tags
  versioning_status  = "Disabled"
  policy             = data.aws_iam_policy_document.allow_matheus_put_object_records.json
}

module "S3TerraformQualityGateInputJsons" {
  source             = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/s3"
  bucket_name        = "${local.vertical_initials}-s3-${local.environment}-quality-gate-input-jsons"
  bucket_description = "Bucket for store file of QualityGate ${local.vertical_initials}-${local.environment}"
  default_tags       = local.common_tags
  versioning_status  = "Enabled"
  policy             = data.aws_iam_policy_document.allow_matheus_put_object_input_jsons.json
}
