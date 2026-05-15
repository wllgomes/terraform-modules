# SSO Info
data "aws_ssoadmin_instances" "this" {}
locals {
  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# SSO users (Identity Store Users)
resource "aws_identitystore_user" "this" {
  identity_store_id = local.identity_store_id
  display_name      = var.display_name
  user_name         = var.email
  name {
    given_name  = var.first_name
    family_name = var.last_name
  }
  emails {
    primary = true
    value   = var.email
  }
}
data "aws_identitystore_user" "this" {
  identity_store_id = local.identity_store_id
  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = aws_identitystore_user.this.user_name
    }
  }
}