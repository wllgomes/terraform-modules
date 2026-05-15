# RDS Subnet Group
module "rds_subnet_group" {
  source = "./modules/db_subnet_group"

  count       = var.create_subnet_group ? 1 : 0
  name        = lower(var.subnet_name)
  description = var.description
  subnets_ids = var.subnets_ids
  tags        = var.tags
}

# Parameter Group
module "parameter_group" {
  source = "./modules/db_parameter_group"

  count       = var.create_parameter_group ? 1 : 0
  name        = var.parameter_group_name
  description = var.parameter_group_description
  family      = var.parameter_group_family
  parameters  = var.parameter_group_parameters
  tags        = var.tags
}

# DB Instance (no aurora engine)
module "db_instance" {
  source = "./modules/db_instance"

  count                     = var.cluster == false && var.engine == "mariadb" || var.cluster == false && var.engine == "mysql" || var.cluster == false && var.engine == "postgresql" ? 1 : 0
  identifier                = lower(var.identifier)
  allocated_storage         = var.allocated_storage
  max_allocated_storage     = var.max_allocated_storage
  engine                    = var.engine
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  db_name                   = var.db_name
  availability_zone         = var.availability_zone
  username                  = var.username
  port                      = var.port
  parameter_group_name      = var.parameter_group_name
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  db_subnet_group_name      = var.db_subnet_group_name
  vpc_security_group_ids    = var.vpc_security_group_ids
  final_snapshot_identifier = "${var.final_snapshot_identifier}-DB-${var.identifier}"
  monitoring_interval       = var.monitoring_interval
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  publicly_accessible       = var.publicly_accessible
  multi_az                  = var.multi_az
  deletion_protection       = var.deletion_protection
  apply_immediately         = var.apply_immediately
  storage_encrypted         = var.storage_encrypted
  storage_type              = var.storage_type
  kms_key_id                = var.kms_key_id
  license_model             = var.license_model
  secret_manager_kms_id     = var.secret_manager_kms_id
  tags                      = var.tags
}

# RDS Cluster
module "rds_cluster" {
  source = "./modules/rds_cluster"

  count                            = var.cluster == true && var.engine != "mariadb" ? 1 : 0
  identifier                       = lower(var.identifier)
  allocated_storage                = var.allocated_storage
  storage_type                     = var.storage_type
  engine                           = var.engine
  engine_version                   = var.engine_version
  engine_mode                      = var.engine_mode
  db_cluster_instance_class        = var.db_cluster_instance_class
  username                         = var.username
  port                             = var.port
  db_cluster_parameter_group_name  = var.db_cluster_parameter_group_name
  db_instance_parameter_group_name = var.db_instance_parameter_group_name
  backup_retention_period          = var.backup_retention_period
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
  instances_number                 = var.instances_number
  publicly_accessible              = var.publicly_accessible
  instance_class                   = var.instance_class
}
