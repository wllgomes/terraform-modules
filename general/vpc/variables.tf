# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "default_tags" {
  type        = map(string)
  description = "Default Tags"
  default = {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/vpc"
  }
}
variable "vpc_name" {
  type        = string
  description = "VPC name"
}
variable "default_vpc_name" {
  type        = string
  description = "Default VPC name"
  default     = null
}
variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []

  # Examples:
  #
  #azs = [
  #  "us-east-1a",
  #  "us-east-1b"
  #]

}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_description" {
  type        = string
  description = "Description for VPC"
  default     = "VPC created by Terraform"
}
variable "default_vpc_description" {
  type        = string
  description = "Description for VPC"
  default     = "Default VPC managed by Terraform - Do not use"
}
variable "enable_dns_support" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults to true."
  default     = true
}
variable "enable_dns_hostnames" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  default     = true
}
variable "default_vpc_enable_dns_support" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS support in the Default VPC. Defaults to true (requires manage_default_vpc set to true).."
  default     = true
}
variable "default_vpc_enable_dns_hostnames" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the Default VPC. Defaults true (requires manage_default_vpc set to true)."
  default     = true
}
variable "enable_ipv6" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block."
  type        = bool
  default     = false
}
variable "manage_default_security_group" {
  description = "Should be true to adopt and manage default security group"
  type        = bool
  default     = false
}
variable "manage_default_vpc" {
  description = "Should be true to adopt and manage Default VPC"
  type        = bool
  default     = false
}
variable "manage_default_route_table" {
  description = "Should be true to manage default route table"
  type        = bool
  default     = false
}
variable "manage_default_network_acl" {
  description = "Should be true to adopt and manage Default Network ACL"
  type        = bool
  default     = false
}
variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  type        = bool
  default     = false
}
variable "dopt_name" {
  description = "Set Dopt name"
  type        = string
  default     = "dopt-default"
}
variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}
variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}
variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}
variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}
variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}
variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  type        = bool
  default     = true
}
variable "igw_name" {
  description = "Set Internet GW name"
  type        = string
  default     = "igw-default"
}
variable "natgw_name" {
  description = "Set Nat GW name"
  type        = string
  default     = "ngw-default"
}
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}
variable "frontend_subnets" {
  description = "A list of public subnets (frontends) inside the VPC"
  type        = list(string)
  default     = []

  # Example:
  #
  #  frontend_subnets = [
  #  "10.254.0.0/24",
  #  "10.254.1.0/24"
  #]

}
variable "backend_subnets" {
  description = "A list of private subnets (backends) inside the VPC"
  type        = list(string)
  default     = []

  # Example:
  #
  #  backend_subnets = [
  #  "10.254.2.0/24",
  #  "10.254.3.0/24"
  #]

}
variable "database_subnets" {
  description = "A list of private subnets (databases) inside the VPC"
  type        = list(string)
  default     = []

  # Example:
  #
  #  database_subnets = [
  #  "10.254.4.0/24",
  #  "10.254.5.0/24"
  #]

}
variable "rtb_frontend_name" {
  type        = string
  description = "RTB Frontend name"
  default     = "rtb-frontends"
}
variable "rtb_backend_name" {
  type        = string
  description = "RTB Backends name"
  default     = "rtb-backends"
}
variable "rtb_databases_name" {
  type        = string
  description = "RTB Databases name"
  default     = "rtb-databases"
}
variable "create_backend_subnet_internet_gateway_route" {
  description = "Controls if an internet gateway route for private (backend) access should be created"
  type        = bool
  default     = false
}
variable "create_backend_subnet_nat_gateway_route" {
  description = "Controls if an nat gateway route for private (backend) access should be created"
  type        = bool
  default     = false
}
variable "create_database_subnet_internet_gateway_route" {
  description = "Controls if an internet gateway route for private (database) access should be created"
  type        = bool
  default     = false
}
variable "create_database_subnet_nat_gateway_route" {
  description = "Controls if an nat gateway route for private (database) access should be created"
  type        = bool
  default     = false
}
variable "frontends_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for public subnets (frontends)"
  type        = bool
  default     = false
}
variable "backends_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for private subnets (backends)"
  type        = bool
  default     = false
}
variable "databases_dedicated_network_acl" {
  description = "Whether to use dedicated network ACL (not default) and custom rules for private subnets (databases)"
  type        = bool
  default     = false
}
variable "database_subnet_group_suffix" {
  description = "Database subnet group suffix"
  type        = string
  default     = ""
}
