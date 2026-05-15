# Random password for RDS Instance (RECOMMENDED for Security Compliance)
# Password is stored in Secret Manager
resource "random_password" "this" {
  length           = var.random_password_length
  special          = true
  override_special = "*-_+="
}
resource "aws_secretsmanager_secret" "this" {
  name                    = "SMForRDS-Instance-${var.identifier}"
  description             = "Credentials for RDS instance ${var.identifier}"
  recovery_window_in_days = 7
  kms_key_id              = var.secret_manager_kms_id
  tags = merge(
    var.tags,
    {
      Name        = "SMForRDS-Instance${var.identifier}"
      Description = "Credentials for RDS instance ${var.identifier}"
    }
  )
}
resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
{
  "password": "${random_password.this.result}",
  "username":"${var.username}"
  }
EOF
}
data "aws_secretsmanager_secret_version" "this" {
  secret_id  = aws_secretsmanager_secret.this.id
  depends_on = [aws_secretsmanager_secret_version.this]
}

# RDS Instance (non-aurora)
resource "aws_db_instance" "this" {
  count                                 = var.create ? 1 : 0
  identifier                            = lower(var.identifier)
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = var.instance_class
  db_name                               = var.db_name
  availability_zone                     = var.availability_zone
  username                              = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["username"]
  password                              = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["password"]
  port                                  = var.port
  network_type                          = var.network_type
  iops                                  = var.iops
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  parameter_group_name                  = var.parameter_group_name
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  delete_automated_backups              = var.delete_automated_backups
  ca_cert_identifier                    = var.ca_cert_identifier
  maintenance_window                    = var.maintenance_window
  db_subnet_group_name                  = var.db_subnet_group_name
  vpc_security_group_ids                = var.vpc_security_group_ids
  final_snapshot_identifier             = var.final_snapshot_identifier
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.monitoring_role_arn
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  domain                                = var.domain
  domain_iam_role_name                  = var.domain_iam_role_name
  character_set_name                    = var.character_set_name
  nchar_character_set_name              = var.nchar_character_set_name
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  skip_final_snapshot                   = var.skip_final_snapshot
  publicly_accessible                   = var.publicly_accessible
  multi_az                              = var.multi_az
  deletion_protection                   = var.deletion_protection
  apply_immediately                     = var.apply_immediately
  storage_encrypted                     = var.storage_encrypted
  storage_type                          = var.storage_type
  kms_key_id                            = var.kms_key_id
  license_model                         = var.license_model
  replica_mode                          = var.replica_mode
  replicate_source_db                   = var.replicate_source_db
  timezone                              = var.timezone
  customer_owned_ip_enabled             = var.customer_owned_ip_enabled
  lifecycle {
    ignore_changes = ["username"]
  }
  blue_green_update {
    enabled = try(var.blue_green_update.enabled, false)
  }
  tags = merge(
    var.tags,
    {
      "Name" = var.identifier
    },
  )
}