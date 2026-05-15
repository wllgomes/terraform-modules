output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = aws_db_subnet_group.this[0].id
}
output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = aws_db_subnet_group.this[0].arn
}
output "db_subnet_group_name" {
  description = "The Name of the db subnet group"
  value       = aws_db_subnet_group.this[0].name
}