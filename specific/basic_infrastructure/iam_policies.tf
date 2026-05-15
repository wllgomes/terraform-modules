# ---------------------------------------------------------------------------------------------------------------------
# IAM ACCOUNT PASSWORD POLICY
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_iam_account_password_policy" "iam_password_strict_policy" {
  minimum_password_length        = 20
  password_reuse_prevention      = 5
  max_password_age               = 90
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
} # Default password policy

# ---------------------------------------------------------------------------------------------------------------------
# IAM POLICIES
# ---------------------------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "azure_agent_basic" {
  statement {
    sid = "BasicKMS"

    actions = [
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyPair",
      "kms:DescribeKey",
      "kms:Decrypt",
      "kms:Encrypt"
    ]

    resources = [module.KMSBucketS3.kms_arn]
  }

  statement {
    sid = "S3StateList"

    actions = [
      "s3:ListBucket"
    ]

    resources = [module.S3TerraformState.bucket_arn]
  }

  statement {
    sid = "S3StateObjects"

    actions = [
      "s3:*Object"
    ]

    resources = ["${module.S3TerraformState.bucket_arn}/*"]
  }

  statement {
    sid = "SSM"

    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = ["*"]
  }

  statement {
    sid = "EC2"

    actions = [
      "ec2messages:*",
      "ec2:*"
    ]

    resources = ["*"]
  }


}

data "aws_iam_policy_document" "role_management" {
  statement {
    sid = "RoleManagement"

    actions = [
      "iam:PassRole",
      "iam:CreateRole",
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:DeleteRole",
      "iam:AttachRolePolicy",
      "iam:GetRole",
      "iam:CreateServiceLinkedRole",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:TagPolicy",
      "iam:UntagPolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:DeletePolicy",
      "iam:DetachRolePolicy",
      "iam:DeleteServiceLinkedRole",
      "iam:GetServiceLinkedRoleDeletionStatus",
      "iam:UpdateAssumeRolePolicy",
      "iam:DeletePolicyVersion",
      "iam:GetRolePolicy",
      "iam:DeleteInstanceProfile",
      "iam:CreateInstanceProfile",
      "iam:AddRoleToInstanceProfile",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "logs_management" {
  statement {
    sid = "LogsManagement"

    actions = ["logs:*"]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_management" {
  override_policy_documents = [
    data.aws_iam_policy_document.role_management.json,
    data.aws_iam_policy_document.logs_management.json
  ]
  statement {
    sid = "ECSCreation"

    actions = [
      "ecr:*",
      "ecs:*",
      "elasticloadbalancing:*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "CloudWatchMetricAlarm"

    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListTagsForResource",
      "cloudwatch:DeleteAlarms"
    ]

    resources = ["*"]
  }

  statement {
    sid = "ECSAutoScaling"

    actions = [
      "application-autoscaling:RegisterScalableTarget",
      "application-autoscaling:DescribeScalableTargets",
      "application-autoscaling:DeregisterScalableTarget",
      "application-autoscaling:PutScalingPolicy",
      "application-autoscaling:DescribeScalingPolicies",
      "application-autoscaling:DeleteScalingPolicy",
      "application-autoscaling:ListTagsForResource",
      "application-autoscaling:PutScheduledAction",
      "application-autoscaling:DescribeScheduledActions",
      "application-autoscaling:DeleteScheduledAction",
      "application-autoscaling:TagResource"
    ]

    resources = ["*"]
  }

  statement {
    sid = "ECSSecretManager"

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:CreateSecret",
      "secretsmanager:TagResource",
      "secretsmanager:UntagResource",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecretVersionStage",
      "secretsmanager:UpdateSecret",
      "secretsmanager:RestoreSecret"
    ]

    resources = ["*"]
  }

  statement {
    sid = "ECSSecretManagerMigration" # parte temporária para a migração dos secret managers

    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:DeleteSecret"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "onpremise_management" {
  statement {
    sid = "OnPremiseIAMUser"

    actions = [
      "iam:CreateUser",
      "iam:TagUser",
      "iam:GetUser",
      "iam:ListAttachedUserPolicies",
      "iam:CreateAccessKey",
      "iam:ListAccessKeys",
      "iam:DeleteAccessKey",
      "iam:AttachUserPolicy"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "azure_agent_frontend" {
  statement {
    sid = "Frontend"

    actions = [
      "s3:*",
      "cloudfront:*",
      "acm:*",
      "kms:*"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "azure_agent_backend" {
  override_policy_documents = [
    data.aws_iam_policy_document.ecs_management.json,
    data.aws_iam_policy_document.onpremise_management.json
  ]
}

data "aws_iam_policy_document" "azure_agent_optimization" {
  override_policy_documents = [
    data.aws_iam_policy_document.ecs_management.json,
    data.aws_iam_policy_document.onpremise_management.json
  ]

  statement {
    sid = "OptimizationCommunication"

    actions = [
      "s3:*",
      "sqs:*",
    ]

    resources = ["*"]
  }

  statement {
    sid = "CloudWatchMetricAlarm"

    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListTagsForResource",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:TagResource"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "azure_agent_etl" {
  override_policy_documents = [
    data.aws_iam_policy_document.role_management.json,
    data.aws_iam_policy_document.logs_management.json
  ]

  statement {
    sid = "LambdaManagement"

    actions = [
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:GetFunction",
      "lambda:TagResource",
      "lambda:UntagResource",
      "lambda:ListVersionsByFunction",
      "lambda:GetLayerVersion",
      "lambda:GetAccountSettings",
      "lambda:GetFunctionConfiguration",
      "lambda:GetLayerVersionPolicy",
      "lambda:ListProvisionedConcurrencyConfigs",
      "lambda:GetProvisionedConcurrencyConfig",
      "lambda:ListTags",
      "lambda:GetRuntimeManagementConfig",
      "lambda:ListLayerVersions",
      "lambda:ListLayers",
      "lambda:ListCodeSigningConfigs",
      "lambda:GetAlias",
      "lambda:ListFunctions",
      "lambda:GetEventSo",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:AddPermission",
      "lambda:GetPolicy",
      "lambda:RemovePermission",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:PublishLayerVersion"
    ]

    resources = ["*"]
  }

  statement {
    sid = "EventsManagementForLambda"

    actions = [
      "events:PutTargets",
      "events:ListTargetsByRule",
      "events:ListTagsForResource",
      "events:DescribeRule",
      "events:RemoveTargets",
      "events:PutRule",
      "events:TagResource"
    ]

    resources = ["*"]
  }

  statement {
    sid = "S3Management"

    actions = [
      "s3:*"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "azure_agent" {
  override_policy_documents = [
    data.aws_iam_policy_document.azure_agent_basic.json,
    data.aws_iam_policy_document.azure_agent_frontend.json,
    data.aws_iam_policy_document.azure_agent_backend.json,
    data.aws_iam_policy_document.azure_agent_optimization.json,
    data.aws_iam_policy_document.azure_agent_etl.json
  ]
}

module "IAMPolicyEC2AzureAgents" {
  source = "../../general/iam/policy"
  name   = "${upper(var.enterprise_context.vertical_initials)}EC2AzureAgents"
  policy = data.aws_iam_policy_document.azure_agent.json
} # EC2 Azure Agents

data "aws_iam_policy_document" "session_manager_logs" {
  statement {
    sid = "PutObjectsBucket"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    effect = "Allow"

    resources = ["arn:aws:s3:::ena-s3-prd-ssm/*"]
  }

  statement {
    sid = "ListBucketAndEncryptionConfig"

    actions = [
      "s3:GetEncryptionConfiguration"
    ]

    effect = "Allow"

    resources = ["arn:aws:s3:::ena-s3-prd-ssm"]
  }
}

resource "aws_iam_policy" "session_manager_logs" {
  name = "${upper(var.enterprise_context.vertical_initials)}SessionManagerLogs"

  path   = "/"
  policy = data.aws_iam_policy_document.session_manager_logs.json
}

# Cloud Custodian
module "IAMCloudCustodianPolicy" {
  source = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/policy"
  name   = "${var.enterprise_context.vertical_initials}CloudCustodianPolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EC2",
            "Effect": "Allow",
            "Action": [
                "ec2:DetachVolume",
                "ec2:ReleaseAddress",
                "ec2:ModifyInstanceMetadataOptions",
                "ec2:DeleteSnapshot",
                "ec2:DescribeAddresses",
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
                "ec2:CreateTags",
                "ec2:DescribeInstanceAttribute",
                "ec2:DeleteNetworkInterface",
                "ec2:ModifySecurityGroupRules",
                "ec2:DescribeSnapshots",
                "ec2:StopInstances",
                "ec2:DescribeSecurityGroups",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:DeleteVolume",
                "ec2:DescribeSecurityGroupRules",
                "ec2:DescribeNetworkInterfaces",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:DescribeVolumes",
                "ec2:DeleteSecurityGroup",
                "ec2:ModifyInstanceAttribute",
                "ec2:DescribeKeyPairs",
                "ec2:DeleteKeyPair",
				"ec2:DescribeImages",
				"ec2:TerminateInstances"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-pvrgxsmmsn"
                }
            }
        },
        {
            "Sid": "IAM",
            "Effect": "Allow",
            "Action": [
                "iam:GetPolicyVersion",
                "iam:DeleteAccessKey",
                "iam:ListRoleTags",
                "iam:DeletePolicy",
                "iam:AttachRolePolicy",
                "iam:ListInstanceProfileTags",
                "iam:GetGroup",
                "iam:DetachRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListAttachedUserPolicies",
                "iam:DetachGroupPolicy",
                "iam:ListAttachedGroupPolicies",
                "iam:ListPolicyTags",
                "iam:ListRolePolicies",
                "iam:DetachUserPolicy",
                "iam:ListAccessKeys",
                "iam:ListPolicies",
                "iam:GetRole",
                "iam:GetPolicy",
                "iam:ListGroupPolicies",
                "iam:GetAccessKeyLastUsed",
                "iam:DeleteUserPolicy",
                "iam:AttachUserPolicy",
                "iam:ListRoles",
                "iam:UpdateAccessKey",
                "iam:ListUserPolicies",
                "iam:GetUserPolicy",
                "iam:ListGroupsForUser",
                "iam:AttachGroupPolicy",
                "iam:PutUserPolicy",
                "iam:ListAccountAliases",
                "iam:ListUsers",
                "iam:ListGroups",
                "iam:GetGroupPolicy",
                "iam:GetUser",
                "iam:DeleteGroupPolicy",
                "iam:GetRolePolicy",
                "iam:DeletePolicyVersion",
                "iam:ListUserTags"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-pvrgxsmmsn"
                }
            }
        },
        {
            "Sid": "KMS",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey",
                "kms:DescribeKey",
                "kms:CreateGrant"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-pvrgxsmmsn"
                }
            }
        },
        {
            "Sid": "RDS",
            "Effect": "Allow",
            "Action": [
                "rds:AddTagsToResource",
                "rds:DescribeDBClusterParameters",
                "rds:StopDBCluster",
                "rds:DeleteGlobalCluster",
                "rds:StopDBInstance",
                "rds:RebootDBCluster",
                "rds:DeleteDBClusterSnapshot",
                "rds:ListTagsForResource",
                "rds:DeleteDBClusterEndpoint",
                "rds:DescribeDBInstances",
                "rds:ModifyDBInstance",
                "rds:ModifyDBCluster",
                "rds:DescribeDBParameters",
                "rds:DeleteDBCluster",
                "rds:DescribeDBClusters",
                "rds:CreateTenantDatabase",
                "rds:DeleteDBInstance"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-pvrgxsmmsn"
                }
            }
        },
        {
            "Sid": "S3",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketPublicAccessBlock",
                "s3:ListTagsForResource",
                "s3:GetBucketTagging",
                "s3:PutBucketPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListBucket"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-pvrgxsmmsn"
                }
            }
        },
        {
            "Sid": "ScretManager",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:CreateSecret",
                "secretsmanager:RotateSecret",
                "secretsmanager:TagResource"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-pvrgxsmmsn"
                }
            }
        },
        {
            "Sid": "SQS",
            "Effect": "Allow",
            "Action": "sqs:SendMessage",
            "Resource": "arn:aws:sqs:*:*:cloudcustodian-notifications",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-pvrgxsmmsn"
                }
            }
        }
    ]
}
  POLICY
}

module "IAMPolicyCloudCustodianRoleForDeploy" {
  source = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/policy"
  name   = "${upper(var.enterprise_context.vertical_initials)}CloudCustodianRoleForDeploy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "IAMPassRole",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::*:role/IAMServiceRoleForCloudCustodianLambdaFunctions"
        },
        {
            "Sid": "LambdaAndEvents",
            "Effect": "Allow",
            "Action": [
                "lambda:CreateFunction",
                "events:PutTargets",
                "events:DescribeRule",
                "lambda:AddPermission",
                "lambda:GetFunction",
                "lambda:TagResource",
                "events:PutRule",
                "events:ListTargetsByRule",
                "lambda:GetFunctionConfiguration",
                "lambda:UpdateFunctionCode",
                "lambda:UpdateFunctionConfiguration",
                "lambda:UntagResource"
            ],
            "Resource": "*"
        }
    ]
}
  POLICY
}

# Terraform Azure Pipelines
module "IAMCustomPolicyForTerraformAzurePipeline" {
  source = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/policy"
  name   = "${upper(var.enterprise_context.vertical_initials)}CustomPolicyForTerraformAzurePipeline"
  policy = var.custom_pipeline_iam_policy
}
