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

# RDS Cluster
resource "aws_rds_cluster" "this" {
  count                            = var.create ? 1 : 0
  cluster_identifier               = lower(var.identifier)
  allocated_storage                = var.allocated_storage
  storage_type                     = var.storage_type
  engine                           = var.engine
  engine_version                   = var.engine_version
  engine_mode                      = var.engine_mode
  db_cluster_instance_class        = var.db_cluster_instance_class
  master_username                  = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["username"]
  master_password                  = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["password"]
  port                             = var.port
  db_cluster_parameter_group_name  = var.db_cluster_parameter_group_name
  db_instance_parameter_group_name = var.db_instance_parameter_group_name
  backup_retention_period          = var.backup_retention_period
  preferred_backup_window          = var.backup_window
  preferred_maintenance_window     = var.maintenance_window
  db_subnet_group_name             = var.db_subnet_group_name
  vpc_security_group_ids           = var.vpc_security_group_ids
  final_snapshot_identifier        = var.final_snapshot_identifier
  copy_tags_to_snapshot            = var.copy_tags_to_snapshot
  skip_final_snapshot              = var.skip_final_snapshot
  availability_zones               = var.availability_zones
  deletion_protection              = var.deletion_protection
  apply_immediately                = var.apply_immediately
  storage_encrypted                = var.storage_encrypted
  kms_key_id                       = var.kms_key_id
  tags = merge(
    var.tags,
    {
      Name = var.identifier
    }
  )
}

# RDS Cluster Instances
resource "aws_rds_cluster_instance" "this" {
  count                   = var.instances_number
  identifier              = "${var.identifier}-${count.index}"
  cluster_identifier      = aws_rds_cluster.this[0].id
  instance_class          = var.instance_class
  engine                  = aws_rds_cluster.this[0].engine
  engine_version          = aws_rds_cluster.this[0].engine_version
  publicly_accessible     = var.publicly_accessible
  tags = merge(
    var.tags,
    {
      Name = "${var.identifier}-instance-${count.index}"
    }
  )
}