# ---------------------------------------------------------------------------------------------------------------------
# OUTPUTS
# -------------------------------------------------------------------------------------------------------------------

output "db_parameter_group_name" {
  value = aws_db_parameter_group.this[*].name
}
output "db_parameter_group_arn" {
  value = aws_db_parameter_group.this[*].arn
}