variable "project_id" {
  type        = string
  description = "The unique ID for the project"
}

variable "container_id" {
  type = string
  description = "The Network Peering Container ID"
}

variable "peering_connection_requesters" {
  description = "Peering Connection Requesters"
  type = list(object({
    name        = string
    vpc_id      = string
    cidr_block  = string
    aws_account = string
    region      = string
  }))
  default = []
}

variable "direct_access" {
  description = "Peering Connection Requesters"
  type = list(object({
    name        = string
    cidr_block  = string
  }))
  default = []
}

variable "aws_region" {
  type        = string
  description = "region"
}
