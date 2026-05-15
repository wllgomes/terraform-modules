# ---------------------------------------------------------------------------------------------------------------------
# DEFAULTS VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "create_vpn" {
  description = "Controls if the VPN should be created"
  type        = bool
  default     = true
}
variable "tags" {
  type        = map(string)
  description = "Default Tags"
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# VPN VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
variable "aws_vpn_gateway" {
  description = "Provides a resource to create a VPC VPN Gateway."
  type        = any
  default     = []
}
variable "aws_customer_gateway" {
  description = "Provides a customer gateway inside a VPC. These objects can be connected to VPN gateways via VPN connections, and allow you to establish tunnels between your network and the VPC."
  type        = any
  default     = []
}
variable "aws_vpn_connection" {
  description = "Manages a Site-to-Site VPN connection. A Site-to-Site VPN connection is an Internet Protocol security (IPsec) VPN connection between a VPC and an on-premises network."
  type        = any
  default     = []
}
variable "aws_vpn_connection_route" {
  description = "Provides a static route between a VPN connection and a customer gateway."
  type        = any
  default     = []
}