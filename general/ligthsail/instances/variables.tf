# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  type        = string
  description = "The name of the records."
  default     = null
}
variable "az" {
  type        = string
  description = "(Required) The AZ where the EBS volume will exist."
}
variable "blueprint_id" {
  type        = string
  description = "(Required) The ID for a virtual private server image. A list of available blueprint IDs can be obtained using the AWS CLI command: aws lightsail get-blueprints"
}
variable "bundle_id" {
  type        = string
  description = "(Required) The bundle of specification information. See here (https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance#bundles)"

  # Examples:
  #
  # bundle_id = small_2_0 (ap-northeast-1)
  # bundle_id = xlarge_2_1 (ap-south-1)
  #
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
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/dlm"
  }
}
variable "create_disk" {
  type        = bool
  description = "(Optional) Status of disk"
  default     = false
}
variable "disk_name" {
  type        = string
  description = "(Required) The name of the Lightsail disk."
  default     = "Disk"
}
variable "disk_path" {
  type        = string
  description = "(Required) The name of the Lightsail disk."
  default     = "/dev/xvdf"
}
variable "disk_size" {
  type        = number
  description = "(Required) Disk size"
  default     = "8"
}
variable "disk_instances_name" {
  type        = string
  description = "(Required) The name of the instance to attach to the Disk."
  default     = null
}
variable "user_data" {
  type        = string
  description = "(Optional) launch script to configure server with additional user data"
  default     = ""

  # Example:
  #
  # user_data = file("files/userdata.sh")
  #

}
variable "ip_type" {
  type        = string
  description = "(Optional) The IP address type of the Lightsail Instance. Valid Values: dualstack | ipv4."
  default     = "ipv4"
}
variable "static_ip" {
  type        = bool
  description = "(Optional) Associate static IP for Lightsail Instance"
  default     = false
}
variable "static_ip_name" {
  type        = string
  description = "(Required) The name for the allocated static IP"
  default     = "StaticIP"
}
variable "set_public_ports" {
  type = bool
  description = "(Optional) Opens ports for a specific Amazon Lightsail instance, and specifies the IP addresses allowed to connect to the instance through the ports, and the protocol."
  default = false
}
variable "protocol" {
  type = string
  description = "(Required) IP protocol name. Valid values are tcp, all, udp, and icmp"
  default = "tcp"
}
variable "from_port" {
  type = number
  description = "(Required) First port in a range of open ports on an instance."
  default = 0
}
variable "to_port" {
  type = number
  description = "(Required) Last port in a range of open ports on an instance."
  default = 0
}
variable "cidr" {
  type = string
  description = "(Optional) Set of CIDR blocks."
  default = "0.0.0.0/0"
}