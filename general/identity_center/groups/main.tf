# SSO Info
data "aws_ssoadmin_instances" "this" {}
locals {
  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# SSO Groups (Identity Store Groups)
resource "aws_identitystore_group" "this" {
  display_name      = var.display_name
  description       = var.description
  identity_store_id = local.identity_store_id
}
resource "aws_identitystore_group_membership" "this" {
  count = length(var.members)
  identity_store_id = local.identity_store_id
  group_id          = data.aws_identitystore_group.this.group_id
  member_id         = var.members[count.index]
}
data "aws_identitystore_group" "this" {
  identity_store_id = local.identity_store_id
  filter {
    attribute_path  = "DisplayName"
    attribute_value = aws_identitystore_group.this.display_name
  }
}