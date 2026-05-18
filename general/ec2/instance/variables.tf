# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "ec2_name" {
  type        = string
  description = "EC2 instance name"
}
variable "ami" {
  type        = string
  description = "(Optional) AMI to use for the instance. Required unless launch_template is specified and the Launch Template specifes an AMI. If an AMI is specified in the Launch Template, setting ami will override the AMI specified in the Launch Template."
  validation {
    condition     = can(regex("^ami-", var.ami))
    error_message = "AMI ID have start with ami-"
  }
}
variable "instance_type" {
  type        = string
  description = "(Optional) Instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance."
}
variable "security_group_ids" {
  type        = list(string)
  description = "(Optional, VPC only) List of security group IDs to associate with."

  # Examples:
  #
  #  security_group_ids = [
  #       "sg-1a2b3c4d5e"
  #  ]

}
variable "subnet_id" {
  type        = string
  description = " (Optional) VPC Subnet ID to launch in."
  validation {
    condition     = can(regex("^subnet-", var.subnet_id))
    error_message = "Subnet ID have start with subnet-"
  }
}
variable "volume_size" {
  type        = number
  description = "(Optional) Size of the volume in gibibytes (GiB)."
  validation {
    condition     = can(regex("^[[:digit:]]+$", var.volume_size))
    error_message = "Volume size value error"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------
variable "ebs_tags" {
  type        = map(string)
  description = "Default Tags for EBS volumes"
  default     = null
}
variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/ec2/instances"
  }
}
variable "key_name" {
  type        = string
  description = "(Optional) Key name of the Key Pair to use for the instance; which can be managed using the aws_key_pair resource."
  default     = null
}
variable "ec2_description" {
  type        = string
  description = "Description for EC2 instance"
  default     = "EC2 instance"
}
variable "public_ip" {
  type        = bool
  description = "Public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC."
  default     = false
}
variable "api_termination" {
  type        = bool
  description = "(Optional) If true, enables EC2 Instance Termination Protection."
  default     = false
}
variable "api_stop" {
  type        = bool
  description = "(Optional) If true, enables EC2 Instance Stop Protection."
  default     = false
}
variable "user_data" {
  type        = string
  description = "User data"
  default     = ""
}
variable "source_dest" {
  type        = bool
  description = "(Optional) Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs. Defaults true."
  default     = true
}
variable "volume_type" {
  type        = string
  description = "Volume type"
  default     = "gp2"
}
variable "iam_profile" {
  type        = string
  description = "Profile IAM (Role)"
  default     = ""
}
variable "encrypted" {
  type        = bool
  description = "(Optional) Whether to enable volume encryption. Defaults to false."
  default     = false
}
variable "kms_key_id" {
  type        = string
  description = "(Optional) Amazon Resource Name (ARN) of the KMS Key to use when encrypting the volume. Must be configured to perform drift detection."
  default     = null
}
variable "delete_on_termination" {
  type        = bool
  description = "(Optional) Whether the volume should be destroyed on instance termination. Defaults to true."
  default     = true
}
variable "metadata_options" {
  type = object({
    http_endpoint               = optional(string, "enabled")
    http_tokens                 = optional(string, "required")
    http_put_response_hop_limit = optional(number, 1)
    instance_metadata_tags      = optional(string, "enabled")
  })
  description = "(Optional) Customize the metadata options (IMDS) for the instance. Controls IMDSv2 token requirement (http_tokens), endpoint availability, hop limit, and instance tag visibility via metadata."
  default     = {}
}
