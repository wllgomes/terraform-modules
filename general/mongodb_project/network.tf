resource "mongodbatlas_network_container" "master" {
  project_id       = var.project_id
  atlas_cidr_block = var.atlas_cidr_block
  provider_name    = "AWS"
  region_name      = replace(upper(var.aws_region), "-", "_")
}

resource "mongodbatlas_project_ip_access_list" "main" {
  for_each = {
    for index, value in var.peering_connection_requesters :
    value.name => value
  }
  project_id = var.project_id
  cidr_block = each.value.cidr_block
  comment    = "cidr block of ${each.value.name} VPC. (${each.value.vpc_id})"

}

resource "mongodbatlas_network_peering" "main" {
  for_each = {
    for index, value in var.peering_connection_requesters :
    value.name => value
  }
  accepter_region_name   = each.value.region
  project_id             = var.project_id
  container_id           = mongodbatlas_network_container.master.id
  provider_name          = "AWS"
  route_table_cidr_block = each.value.cidr_block
  vpc_id                 = each.value.vpc_id
  aws_account_id         = each.value.aws_account
}

resource "mongodbatlas_project_ip_access_list" "direct" {
  for_each = {
    for index, value in var.direct_access :
    value.name => value
  }
  project_id = var.project_id
  cidr_block = each.value.cidr_block
  comment    = each.value.name

}
