output "dlm_with_existed_id" {
  value = aws_dlm_lifecycle_policy.this_with_existed_role[*].id
}
output "dlm_with_existed_arn" {
  value = aws_dlm_lifecycle_policy.this_with_existed_role[*].arn
}
output "dlm_with_new_id" {
  value = aws_dlm_lifecycle_policy.this_with_new_role[*].id
}
output "dlm_with_new_arn" {
  value = aws_dlm_lifecycle_policy.this_with_new_role[*].arn
}
output "role_arn" {
  value = aws_iam_role.this[*].arn
}