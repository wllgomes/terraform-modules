output "cluster_id" {
  value = aws_rds_cluster.this[0].id
}
output "cluster_arn" {
  value = aws_rds_cluster.this[0].arn
}
output "cluster_identifier" {
  value = aws_rds_cluster.this[0].cluster_identifier
}
output "cluster_engine" {
  value = aws_rds_cluster.this[0].engine_version
}
output "instance_id" {
  value = aws_rds_cluster_instance.this[0].id
}
output "instance_arn" {
  value = aws_rds_cluster_instance.this[0].arn
}
output "instance_identifier" {
  value = aws_rds_cluster_instance.this[0].identifier
}
output "secretmanager_id" {
  description = "The ID of Secret Manager"
  value       = aws_secretsmanager_secret_version.this.id
}
output "secretmanager_arn" {
  description = "The ARN of Secret Manager"
  value       = aws_secretsmanager_secret_version.this.arn
}