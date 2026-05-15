# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
# Subnet Group
variable "subnets_ids" {
  type        = list(string)
  description = "(Required) A list of VPC subnet IDs."
  default     = null
}

# DB Instance
variable "engine" {
  type        = string
  description = "(Required unless a snapshot_identifier or replicate_source_db is provided) The database engine to use."
  default     = null
}
variable "instance_class" {
  description = "(Required) The instance type of the RDS instance."
  type        = string
  default     = null
}
variable "allocated_storage" {
  type        = number
  description = "The amount of allocated storage."
  default     = null
}
variable "max_allocated_storage" {
  type        = number
  description = "(Optional) When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Configuring this will automatically ignore differences to allocated_storage."
  default     = null
}

# RDS Cluster
variable "instances_number" {
  type        = number
  description = "(Required) Number of instances to attach to RDS Cluster"
  default     = null
}
variable "db_cluster_instance_class" {
  description = " (Required) The instance type of the RDS instance."
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
# Common
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/rds"
  }
}
variable "cluster" {
  type        = bool
  description = "Create or no RDS Cluster"
  default     = false
}

# Subnet Group
variable "create_subnet_group" {
  description = "Create subnet group"
  type        = bool
  default     = false
}
variable "description" {
  description = "The description of the DB subnet group"
  type        = string
  default     = null
}

# Parameter Group
variable "create_parameter_group" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = false
}
variable "parameter_group_name" {
  type        = string
  description = "(Optional) Name of the DB parameter group to associate."
  default     = null
}
variable "parameter_group_description" {
  type        = string
  description = "(Optional) Description of the DB parameter group to associate."
  default     = "Parameter Group for custom parameters"
}
variable "parameter_group_family" {
  description = "(Required, Forces new resource) The family of the DB parameter group."
  type        = string
  default     = null
}
variable "parameter_group_parameters" {
  description = "(Optional) A list of DB parameters to apply. Note that parameters may differ from a family to an other. Full list of all parameters can be discovered via aws rds describe-db-parameters after initial creation of the group."
  type        = list(map(string))
  default     = []
}

# RDS DB Instance (non-aurora)
variable "availability_zone" {
  description = "The Availability Zone of the RDS instance and Clusters"
  type        = string
  default     = null
}
variable "db_subnet_group_name" {
  type        = string
  description = "(Optional) Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group."
  default     = null
}
variable "identifier" {
  type        = string
  description = "(Optional, Forces new resource) The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier."
  default     = null
}
variable "engine_version" {
  type        = string
  description = "(Optional) The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10)."
  default     = null
}
variable "db_name" {
  type        = string
  description = "(Optional) The name of the database to create when the DB instance is created."
  default     = null
}
variable "username" {
  type        = string
  description = "(Required unless a snapshot_identifier or replicate_source_db is provided) Username for the master DB user."
  default     = "admin"
}
variable "subnet_name" {
  type        = string
  description = "(Optional, Forces new resource) The name of the DB subnet group. If omitted, Terraform will assign a random, unique name."
  default     = "subnet-group"
}
variable "secret_manager_kms_id" {
  type        = string
  description = "(Optional) ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret."
  default     = null
}
variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = true
}
variable "allow_major_version_upgrade" {
  description = "(Optional) Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible."
  type        = bool
  default     = false
}
variable "auto_minor_version_upgrade" {
  description = "(Optional) Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Defaults to true."
  type        = bool
  default     = true
}
variable "random_password_length" {
  description = "Length of random password to create"
  type        = number
  default     = 20
}
variable "backup_retention_period" {
  type        = number
  description = "(Optional) The days to retain backups for. Must be between 0 and 35."
  default     = 2 # RECOMENDED
  validation {
    condition     = var.backup_retention_period <= 35 && var.backup_retention_period >= 0
    error_message = "Value should be in the retention period 7 <= session <= 30."
  }
}
variable "vpc_security_group_ids" {
  type        = list(string)
  description = "(Required) List of VPC security groups to associate"
  default     = []
}
variable "final_snapshot_identifier" {
  description = "The name which is prefixed to the final snapshot on cluster destroy"
  type        = string
  default     = "LastSnapshot"
}
variable "backup_window" {
  type        = string
  description = "(Optional) The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'."
  default     = "23:00-23:59"
}
variable "maintenance_window" {
  type        = string
  description = "(Optional) The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  default     = "Sat:01:00-Sat:03:00"
}
variable "monitoring_interval" {
  type        = number
  description = "(Optional) The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
  default     = 0
}
variable "copy_tags_to_snapshot" {
  description = "(Optional, boolean) Copy all Instance tags to snapshots. Default is false."
  type        = bool
  default     = false
}
variable "publicly_accessible" {
  description = "(Optional) Bool to control if instance is publicly accessible. Default is false."
  type        = bool
  default     = false
}
variable "multi_az" {
  description = "(Optional) Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}
variable "deletion_protection" {
  description = "(Optional) If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false."
  type        = bool
  default     = false
}
variable "apply_immediately" {
  description = "(Optional) Specifies whether any database modifications are applied immediately, or during the next maintenance window. Default is false."
  type        = bool
  default     = false
}
variable "storage_encrypted" {
  description = "(Optional) Specifies whether the DB instance is encrypted."
  type        = bool
  default     = true
}
variable "kms_key_id" {
  description = "(Optional) The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN."
  type        = string
  default     = null
}
variable "storage_type" {
  type        = string
  description = "(Optional) The amount of storage in gibibytes (GiB) to allocate to each DB instance in the Multi-AZ DB cluster. (This setting is required to create a Multi-AZ DB cluster)."
  default     = null
}
variable "port" {
  description = "(Optional) The port on which the DB accepts connections."
  type        = string
  default     = null
}
variable "license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  type        = string
  default     = null
}

# RDS Cluster
variable "engine_mode" {
  type        = string
  description = "(Optional) The database engine mode. Valid values: global (only valid for Aurora MySQL 1.21 and earlier), multimaster, parallelquery, provisioned, serverless. Defaults to: provisioned. See the RDS User Guide for limitations when using serverless."
  default     = "provisioned"
}
variable "db_cluster_parameter_group_name" {
  type        = string
  description = "(Optional) A cluster parameter group to associate with the cluster."
  default     = null
}
variable "db_instance_parameter_group_name" {
  type        = string
  description = "(Optional) Instance parameter group to associate with all instances of the DB cluster."
  default     = null
}
variable "db_parameter_group_name" {
  type        = string
  description = "(Optional) The name of the DB parameter group to associate with this instance."
  default     = null
}
variable "availability_zones" {
  description = "The Availability Zone of the RDS instance and Clusters"
  type        = list(string)
  default     = null
}