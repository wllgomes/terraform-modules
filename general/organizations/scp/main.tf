# ---------------------------------------------------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------------------------------------------------

# Get root organization ID
data "aws_organizations_organization" "org" {}

# ---------------------------------------------------------------------------------------------------------------------
# SCP'S
# ---------------------------------------------------------------------------------------------------------------------

# Deny all access outside region
resource "aws_organizations_policy" "AllOutsideRegionProd" {
  count       = var.all_outside_region_prod == [] ? 0 : 1
  name        = try(var.all_outside_region_prod[count.index].name, "AllOutsideRegionProd")
  description = try(var.all_outside_region_prod[count.index].description, "Security policies to deny all access outside of region to production environment")
  tags = try(var.all_outside_region_prod[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/organizations/scp"
  })

  content = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyAllOutside",
            "Effect": "Deny",
            "NotAction": [
                "a4b:*",
                "acm:*",
                "account:*",
                "access-analyzer:ValidatePolicy",
                "access-analyzer:ListPolicyGenerations",
                "aws-marketplace-management:*",
                "aws-marketplace:*",
                "aws-portal:*",
                "budgets:*",
                "billing:*",
                "bedrock:*",
                "ce:*",
				"cost-optimization-hub:*",
				"cur:*",
                "chime:*",
                "cloudfront:*",
                "cloudwatch:*",
                "config:*",
                "cloudtrail:LookupEvents",
                "cloudtrail:DescribeTrails",
                "cloudtrail:GetEventSelectors",
                "cloudtrail:ListTags",
                "cloudtrail:GetInsightSelectors",
                "directconnect:*",
                "ec2:DescribeRegions",
                "ec2:DescribeTransitGateways",
                "ec2:DescribeVpnGateways",
                "fms:*",
                "globalaccelerator:*",
                "health:*",
                "iam:*",
                "importexport:*",
                "kms:*",
                "logs:*",
                "mobileanalytics:*",
                "networkmanager:*",
                "organizations:*",
                "pricing:*",
                "resource-groups:*",
                "route53:*",
                "route53domains:*",
                "s3:GetAccountPublic*",
                "s3:ListAllMyBuckets",
                "s3:PutAccountPublic*",
                "s3:GetEncryptionConfiguration",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "shield:*",
                "sts:*",
                "support:*",
                "trustedadvisor:*",
                "waf-regional:*",
                "waf:*",
                "wafv2:*",
                "wellarchitected:*"
            ],
            "Resource": "*",
            "Condition": {
                "StringNotEquals": {
                    "aws:RequestedRegion": ${jsonencode(var.all_outside_region_prod[count.index].region)}
                },
                "ArnNotLike": {
                     "aws:PrincipalARN": ${jsonencode(var.all_outside_region_prod[count.index].exception_principal)}
                }
            }
        }
    ]
}
POLICY
}
resource "aws_organizations_policy_attachment" "AllOutsideRegionProd" {
  for_each   = toset(flatten([for obj in var.all_outside_region_prod : obj.target_id != null ? obj.target_id : [data.aws_organizations_organization.org.roots[0].id]]))
  policy_id  = aws_organizations_policy.AllOutsideRegionProd[0].id
  target_id  = each.key
  depends_on = [aws_organizations_policy.AllOutsideRegionProd]
}
resource "aws_organizations_policy" "AllOutsideRegionSDLC" {
  count       = var.all_outside_region_sdlc == [] ? 0 : 1
  name        = try(var.all_outside_region_sdlc[count.index].name, "AllOutsideRegionSDLC")
  description = try(var.all_outside_region_sdlc[count.index].description, "Security policies to deny all access outside of region to SDLC environment")
  tags = try(var.all_outside_region_sdlc[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/organizations/scp"
  })

  content = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyAllOutside",
            "Effect": "Deny",
            "NotAction": [
                "a4b:*",
                "account:*",
                "access-analyzer:ValidatePolicy",
                "access-analyzer:ListPolicyGenerations",
                "acm:*",
                "aws-marketplace-management:*",
                "aws-marketplace:*",
                "aws-portal:*",
                "budgets:*",
                "billing:*",
                "bedrock:*",
                "ce:*",
				"cost-optimization-hub:*",
				"cur:*",
                "chime:*",
                "cloudfront:*",
                "cloudwatch:*",
                "config:*",
                "cloudtrail:LookupEvents",
                "cloudtrail:DescribeTrails",
                "cloudtrail:GetEventSelectors",
                "cloudtrail:ListTags",
                "cloudtrail:GetInsightSelectors",
                "directconnect:*",
                "ec2:DescribeRegions",
                "ec2:DescribeTransitGateways",
                "ec2:DescribeVpnGateways",
                "fms:*",
                "globalaccelerator:*",
                "health:*",
                "iam:*",
                "importexport:*",
                "kms:*",
                "logs:*",
                "mobileanalytics:*",
                "networkmanager:*",
                "organizations:*",
                "pricing:*",
                "resource-groups:*",
                "route53:*",
                "route53domains:*",
                "s3:GetAccountPublic*",
                "s3:ListAllMyBuckets",
                "s3:PutAccountPublic*",
                "s3:GetEncryptionConfiguration",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "shield:*",
                "sts:*",
                "support:*",
                "trustedadvisor:*",
                "waf-regional:*",
                "waf:*",
                "wafv2:*",
                "wellarchitected:*"
            ],
            "Resource": "*",
            "Condition": {
                "StringNotEquals": {
                    "aws:RequestedRegion": ${jsonencode(var.all_outside_region_sdlc[count.index].region)}
                },
                "ArnNotLike": {
                     "aws:PrincipalARN": ${jsonencode(var.all_outside_region_sdlc[count.index].exception_principal)}
                }
            }
        }
    ]
}
POLICY
}
resource "aws_organizations_policy_attachment" "AllOutsideRegionSDLC" {
  for_each   = toset(flatten([for obj in var.all_outside_region_sdlc : obj.target_id != null ? obj.target_id : [data.aws_organizations_organization.org.roots[0].id]]))
  policy_id  = aws_organizations_policy.AllOutsideRegionSDLC[0].id
  target_id  = each.key
  depends_on = [aws_organizations_policy.AllOutsideRegionSDLC]
}

# Deny Access-Key for root user
resource "aws_organizations_policy" "AccessKeyRootUser" {
  count       = var.accesskey_root == [] ? 0 : 1
  name        = try(var.accesskey_root[count.index].name, "AccessKeyRootUser")
  description = try(var.accesskey_root[count.index].description, "The root user should not have access keys per AWS security best practices.")
  tags = try(var.accesskey_root[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/organizations/scp"
  })

  content = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
            "Sid": "DenyAccessKeyRootUser",
            "Effect": "Deny",
            "Action": "iam:CreateAccessKey",
            "Resource": "arn:aws:iam::*:root"
		}
	]
}
POLICY
}
resource "aws_organizations_policy_attachment" "AccessKeyRootUser" {
  for_each   = toset(flatten([for obj in var.accesskey_root : obj.target_id != null ? obj.target_id : [data.aws_organizations_organization.org.roots[0].id]]))
  policy_id  = aws_organizations_policy.AccessKeyRootUser[0].id
  target_id  = each.key
  depends_on = [aws_organizations_policy.AccessKeyRootUser]
}

# Deny Access-Key for any user
resource "aws_organizations_policy" "AccessKey" {
  count       = var.accesskey == [] ? 0 : 1
  name        = try(var.accesskey[count.index].name, "AccessKey")
  description = try(var.accesskey[count.index].description, "Users should not have access keys per AWS security best practices.")
  tags = try(var.accesskey[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/organizations/scp"
  })

  content = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
            "Sid": "DenyAccessKey",
            "Effect": "Deny",
            "Action": "iam:CreateAccessKey",
            "Resource": "*",
            "Condition": {
                "ArnNotLike": {
                     "aws:PrincipalARN": ${jsonencode(var.accesskey[count.index].exception_principal)}
                }
            }
		}
	]
}
POLICY
}
resource "aws_organizations_policy_attachment" "AccessKey" {
  for_each   = toset(flatten([for obj in var.accesskey : obj.target_id != null ? obj.target_id : [data.aws_organizations_organization.org.roots[0].id]]))
  policy_id  = aws_organizations_policy.AccessKey[0].id
  target_id  = each.key
  depends_on = [aws_organizations_policy.AccessKey]
}

# Deny IAM User
resource "aws_organizations_policy" "iamuser" {
  count       = var.iam_user == [] ? 0 : 1
  name        = try(var.iam_user[count.index].name, "iam_user")
  description = try(var.iam_user[count.index].description, "IAM Users should not be created in environmnents with AWS Organizations.")
  tags = try(var.iam_user[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/organizations/scp"
  })

  content = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
            "Sid": "DenyAccessKey",
            "Effect": "Deny",
            "Action": "iam:CreateUser",
            "Resource": "*",
            "Condition": {
                "ArnNotLike": {
                     "aws:PrincipalARN": ${jsonencode(var.iam_user[count.index].exception_principal)}
                }
            }
		}
	]
}
POLICY
}
resource "aws_organizations_policy_attachment" "iamuser" {
  for_each   = toset(flatten([for obj in var.iam_user : obj.target_id != null ? obj.target_id : [data.aws_organizations_organization.org.roots[0].id]]))
  policy_id  = aws_organizations_policy.iamuser[0].id
  target_id  = each.key
  depends_on = [aws_organizations_policy.iamuser]
}

# Leave Organizations
resource "aws_organizations_policy" "LeaveDeleteOrganizations" {
  count       = var.leave_delete_organizations == [] ? 0 : 1
  name        = try(var.leave_delete_organizations[count.index].name, "LeaveDeleteOrganizations")
  description = try(var.leave_delete_organizations[count.index].description, "Restrict organization leave, delete, and remove actions to an infrastructure automation framework role and/or administrator role")
  tags = try(var.leave_delete_organizations[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/organizations/scp"
  })

  content = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
        {
        "Sid": "LeaveDeleteOrganizations",
        "Effect": "Deny",
        "Action": [
            "organizations:LeaveOrganization",
            "organizations:DeleteOrganization"
        ],
        "Resource": "*",
        "Condition": {
            "ArnNotLike": {
                "aws:PrincipalARN": "${try(var.leave_delete_organizations[0].exception_principal[0], "arn:aws:iam::*:root")}"
            }
          }
        }
	]
}
POLICY
}
resource "aws_organizations_policy_attachment" "LeaveDeleteOrganizations" {
  for_each   = toset(flatten([for obj in var.leave_delete_organizations : obj.target_id != null ? obj.target_id : [data.aws_organizations_organization.org.roots[0].id]]))
  policy_id  = aws_organizations_policy.LeaveDeleteOrganizations[0].id
  target_id  = each.key
  depends_on = [aws_organizations_policy.LeaveDeleteOrganizations]
}

# Create, change or delete trail in Cloudtrail
resource "aws_organizations_policy" "CreateModifyDeleteCloudtrailTrail" {
  count       = var.create_modify_delete_cloudtrail == [] ? 0 : 1
  name        = try(var.create_modify_delete_cloudtrail[count.index].name, "CreateModifyDeleteCloudtrail")
  description = try(var.create_modify_delete_cloudtrail[count.index].description, "Restrict CloudTrail actions to specific CloudTrails that are required by the security or compliance teams")
  tags = try(var.create_modify_delete_cloudtrail[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/organizations/scp"
  })

  content = <<POLICY
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "CreateModifyDeleteTrail",
			"Effect": "Deny",
			"Action": [
                "cloudtrail:DeleteTrail",
				"cloudtrail:UpdateTrail",
				"cloudtrail:CreateTrail",
				"cloudtrail:AddTags"
			],
			"Resource": "*",
			"Condition": {
                "ArnNotLike": {
                    "aws:PrincipalARN": "${try(var.create_modify_delete_cloudtrail[0].exception_principal[0], "arn:aws:iam::*:root")}"
                }
            }
		}
	]
}
POLICY
}
resource "aws_organizations_policy_attachment" "CreateModifyDeleteCloudtrailTrail" {
  for_each   = toset(flatten([for obj in var.create_modify_delete_cloudtrail : obj.target_id != null ? obj.target_id : [data.aws_organizations_organization.org.roots[0].id]]))
  policy_id  = aws_organizations_policy.CreateModifyDeleteCloudtrailTrail[0].id
  target_id  = each.key
  depends_on = [aws_organizations_policy.CreateModifyDeleteCloudtrailTrail]
}

# Create Instances of IAM Identity Center
resource "aws_organizations_policy" "IAMIdentityCenterCreateInstance" {
  count       = var.iam_identity_center_create_instance == [] ? 0 : 1
  name        = try(var.iam_identity_center_create_instance[count.index].name, "IAMIdentityCenterCreateInstance")
  description = try(var.iam_identity_center_create_instance[count.index].description, "Prevent creation of new account instances of IAM Identity Center.")
  tags = try(var.iam_identity_center_create_instance[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/organizations/scp"
  })

  content = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyMemberAccountInstances",
            "Effect": "Deny",
            "Action": [
                "sso:CreateInstance"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}
resource "aws_organizations_policy_attachment" "IAMIdentityCenterCreateInstance" {
  for_each   = toset(flatten([for obj in var.iam_identity_center_create_instance : obj.target_id != null ? obj.target_id : [data.aws_organizations_organization.org.roots[0].id]]))
  policy_id  = aws_organizations_policy.IAMIdentityCenterCreateInstance[0].id
  target_id  = each.key
  depends_on = [aws_organizations_policy.IAMIdentityCenterCreateInstance]
}