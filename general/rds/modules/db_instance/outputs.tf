output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this[0].address
}
output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.this[0].arn
}
output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = aws_db_instance.this[0].availability_zone
}
output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.this[0].endpoint
}
output "db_instance_engine" {
  description = "The database engine"
  value       = aws_db_instance.this[0].engine
}
output "db_instance_engine_version_actual" {
  description = "The running version of the database"
  value       = aws_db_instance.this[0].engine_version_actual
}
output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = aws_db_instance.this[0].hosted_zone_id
}
output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.this[0].id
}
output "db_instance_resource_id" {
  description = "The RDS Resource ID of this[0] instance"
  value       = aws_db_instance.this[0].resource_id
}
output "db_instance_status" {
  description = "The RDS instance status"
  value       = aws_db_instance.this[0].status
}
output "db_instance_name" {
  description = "The database name"
  value       = aws_db_instance.this[0].identifier
}
output "db_instance_username" {
  description = "The master username for the database"
  value       = aws_db_instance.this[0].username
  sensitive   = true
}
output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.this[0].port
}
output "secretmanager_id" {
  description = "The ID of Secret Manager"
  value       = aws_secretsmanager_secret_version.this.id
}
output "secretmanager_arn" {
  description = "The ARN of Secret Manager"
  value       = aws_secretsmanager_secret_version.this.arn
}