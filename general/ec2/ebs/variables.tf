# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "Name for EBS Volume"
}
variable "az" {
  type        = string
  description = "(Required) The AZ where the EBS volume will exist."
}
variable "size" {
  type        = number
  description = "(Optional) The size of the drive in GiBs."
}
variable "device_name" {
  type        = string
  description = "(Required) The device name to expose to the instance (for example, /dev/sdh or xvdh). See Device Naming on Linux Instances and Device Naming on Windows Instances for more information."
}
variable "instance_id" {
  type        = string
  description = "(Required) ID of the Instance to attach to"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/ec2/ebs"
  }
}
variable "type" {
  type        = string
  description = "(Optional) The type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp2)."
  default     = "gp2"
}
variable "encrypted" {
  type        = bool
  description = "(Optional) If true, the disk will be encrypted."
  default     = false
}
variable "kms_id" {
  type        = string
  description = "(Optional) The ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true. "
  default     = null
}
variable "final_snapshot" {
  type        = bool
  description = "(Optional) If true, snapshot will be created before volume deletion. Any tags on the volume will be migrated to the snapshot. By default set to false"
  default     = false
}
variable "force_detach" {
  type        = bool
  description = "(Optional, Boolean) Set to true if you want to force the volume to detach. Useful if previous attempts failed, but use this option only as a last resort, as this can result in data loss. See Detaching an Amazon EBS Volume from an Instance for more information."
  default     = false
}