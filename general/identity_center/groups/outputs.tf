output "group_name" {
  value = data.aws_identitystore_group.this.display_name
}
output "group_id" {
  value = data.aws_identitystore_group.this.group_id
}