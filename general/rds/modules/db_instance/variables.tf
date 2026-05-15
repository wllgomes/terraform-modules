# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "engine" {
  type        = string
  description = "(Required unless a snapshot_identifier or replicate_source_db is provided) The database engine to use."
}
variable "instance_class" {
  description = " (Required) The instance type of the RDS instance."
  type        = string
}
variable "allocated_storage" {
  type        = number
  description = "The amount of allocated storage."
  default     = 10
}
variable "max_allocated_storage" {
  type        = number
  description = "(Optional) When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Configuring this will automatically ignore differences to allocated_storage."
  default     = 20
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}
variable "create_cluster" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default     = {}
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
variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = null
}
variable "username" {
  type        = string
  description = "(Required unless a snapshot_identifier or replicate_source_db is provided) Username for the master DB user."
  default     = "admin"
}
variable "db_subnet_group_name" {
  type        = string
  description = "(Optional) Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group."
  default     = null
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
variable "parameter_group_name" {
  type        = string
  description = "(Optional) Name of the DB parameter group to associate."
  default     = null
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
  default     = null
}
variable "backup_window" {
  type        = string
  description = "(Optional) The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'."
  default     = "23:00-23:59"
}
variable "delete_automated_backups" {
  type        = bool
  description = "(Optional) Specifies whether to remove automated backups immediately after the DB instance is deleted. "
  default     = true
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
variable "monitoring_role_arn" {
  type        = string
  description = "((Optional) The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  default     = null
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
  description = "(Optional) One of standard (magnetic), gp2 (general purpose SSD), gp3 (general purpose SSD that needs iops independently) or io1 (provisioned IOPS SSD)."
  default     = "gp3"
}
variable "storage_throughput" {
  type        = string
  description = " (Optional) The storage throughput value for the DB instance. Can only be set when storage_type is gp3."
  default     = null
}
variable "iops" {
  description = "(Optional) The amount of provisioned IOPS. Setting this implies a storage_type of io1."
  type        = string
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
variable "character_set_name" {
  description = "(Optional) The character set name to use for DB encoding in Oracle and Microsoft SQL instances (collation)."
  type        = string
  default     = null
}
variable "nchar_character_set_name" {
  description = "(Optional, Forces new resource) The national character set is used in the NCHAR, NVARCHAR2, and NCLOB data types for Oracle instances."
  type        = string
  default     = null
}
variable "network_type" {
  description = "(Optional) The network type of the DB instance."
  type        = string
  default     = "IPV4"
}
variable "performance_insights_enabled" {
  description = "(Optional) Specifies whether Performance Insights are enabled."
  type        = bool
  default     = false
}
variable "performance_insights_retention_period" {
  description = "(Optional) Amount of time in days to retain Performance Insights data. "
  type        = number
  default     = "0"
}
variable "performance_insights_kms_key_id" {
  description = "(Optional) The ARN for the KMS key to encrypt Performance Insights data."
  type        = string
  default     = null
}
variable "replica_mode" {
  description = "(Optional) Specifies whether the replica is in either mounted or open-read-only mode."
  type        = string
  default     = null
}
variable "replicate_source_db" {
  description = "(Optional) Specifies that this resource is a Replicate database, and to use this value as the source database."
  type        = string
  default     = null
}
variable "timezone" {
  description = "(Optional) Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server."
  type        = string
  default     = null
}
variable "customer_owned_ip_enabled" {
  description = "(Optional) Indicates whether to enable a customer-owned IP address (CoIP) for an RDS on Outposts DB instance."
  type        = string
  default     = null
}
variable "ca_cert_identifier" {
  description = "(Optional) The identifier of the CA certificate for the DB instance."
  type        = string
  default     = null
}
variable "domain" {
  description = "(Optional) The ID of the Directory Service Active Directory domain to create the instance in."
  type        = string
  default     = null
}
variable "domain_iam_role_name" {
  description = "(Optional, but required if domain is provided) The name of the IAM role to be used when making API calls to the Directory Service."
  type        = string
  default     = null
}
variable "enabled_cloudwatch_logs_exports" {
  description = "(Optional) Set of log types to enable for exporting to CloudWatch logs."
  type        = list(any)
  default     = []
}
variable "blue_green_update" {
  description = "(Optional) Enables low-downtime updates using RDS Blue/Green deployments"
  type        = any
  default     = []
}