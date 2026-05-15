variable "project_id" {
  type        = string
  description = "region"
}

variable "project_name" {
  type        = string
  description = "MongoDB cluster name"
}

variable "atlas_cidr_block" {
  type        = string
  description = "atlas CIDR block"
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

variable "mongo_db_major_version" {
  type        = string
  description = "MongoDB Major Version"
}

variable "cluster_size" {
  type        = string
  description = "MongoDB cluster instance size name"
}
