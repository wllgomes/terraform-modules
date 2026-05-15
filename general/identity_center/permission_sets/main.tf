# SSO Info
data "aws_ssoadmin_instances" "this" {}
locals {
  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  combs = chunklist(flatten([
    for k, v in var.group_assignments : setproduct([k], toset(v))
  ]), 2)
}

# Permissions Set
resource "aws_ssoadmin_permission_set" "this" {
  name             = var.name
  session_duration = "PT${var.session_duration_hours}H"
  description      = var.description
  instance_arn     = local.sso_instance_arn
  relay_state      = var.relay_state
  tags             = var.default_tags
}

# AWS Managed Policy Assign
resource "aws_ssoadmin_managed_policy_attachment" "this" {
  count              = length(var.managed_policies_arn)
  instance_arn       = local.sso_instance_arn
  managed_policy_arn = var.managed_policies_arn[count.index]
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
}

# In line policy Assign
resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  count              = var.inline_policy != null ? 1 : 0
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  inline_policy      = var.inline_policy
}

# Account Assign
resource "aws_ssoadmin_account_assignment" "this" {
  count              = length(local.combs)
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  principal_id       = local.combs[count.index][0]
  principal_type     = "GROUP"
  target_id          = local.combs[count.index][1]
  target_type        = "AWS_ACCOUNT"
}