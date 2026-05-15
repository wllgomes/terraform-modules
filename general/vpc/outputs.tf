# ---------------------------------------------------------------------------------------------------------------------
# DYNAMIC VALUES
# ---------------------------------------------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this.id, "")
}
output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this.arn, "")
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this.cidr_block, "")
}
output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = try(aws_vpc.this.default_security_group_id, "")
}
output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = try(aws_vpc.this.default_network_acl_id, "")
}
output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = try(aws_vpc.this.default_route_table_id, "")
}
output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = try(aws_vpc.this.instance_tenancy, "")
}
output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = try(aws_vpc.this.enable_dns_support, "")
}
output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = try(aws_vpc.this.enable_dns_hostnames, "")
}
output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = try(aws_vpc.this.main_route_table_id, "")
}
output "vpc_ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = try(aws_vpc.this.ipv6_association_id, "")
}
output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = try(aws_vpc.this.ipv6_cidr_block, "")
}
output "backends_subnets" {
  description = "List of IDs of private subnets (backends)"
  value       = aws_subnet.backend[*].id
}
output "databases_subnets" {
  description = "List of IDs of private subnets (databases)"
  value       = aws_subnet.database[*].id
}
output "backends_subnet_arns" {
  description = "List of ARNs of private subnets (backends)"
  value       = aws_subnet.backend[*].arn
}
output "databases_subnet_arns" {
  description = "List of ARNs of private subnets (databases)"
  value       = aws_subnet.database[*].arn
}
output "backends_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets (backends)"
  value       = compact(aws_subnet.backend[*].cidr_block)
}
output "databases_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets (databases)"
  value       = compact(aws_subnet.database[*].cidr_block)
}
output "frontends_subnets" {
  description = "List of IDs of public subnets (frontends)"
  value       = aws_subnet.frontend[*].id
}
output "frontends_subnet_arns" {
  description = "List of ARNs of public subnets (frontends)"
  value       = aws_subnet.frontend[*].arn
}
output "frontends_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets (frontends)"
  value       = compact(aws_subnet.frontend[*].cidr_block)
}
output "frontends_route_table_ids" {
  description = "List of IDs of public route tables (frontends)"
  value       = aws_route_table.frontend[*].id
}
output "backends_route_table_ids" {
  description = "List of IDs of private route tables (backends)"
  value       = aws_route_table.backend[*].id
}
output "databases_route_table_ids" {
  description = "List of IDs of private route tables (database)"
  value       = aws_route_table.database[*].id
}
output "frontend_internet_gateway_route_id" {
  description = "ID of the internet gateway route"
  value       = try(aws_route.frontend_internet_gateway[0].id, "")
}
output "databases_internet_gateway_route_id" {
  description = "ID of the database internet gateway route"
  value       = try(aws_route.database_internet_gateway[0].id, "")
}
output "database_nat_gateway_route_ids" {
  description = "List of IDs of the database nat gateway route"
  value       = aws_route.database_nat_gateway[*].id
}
output "backends_internet_gateway_route_id" {
  description = "ID of the backend internet gateway route"
  value       = try(aws_route.backend_internet_gateway[0].id, "")
}
output "dbackend_nat_gateway_route_ids" {
  description = "List of IDs of the database nat gateway route"
  value       = aws_route.backend_nat_gateway[*].id
}
output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = try(aws_vpc_dhcp_options.this[0].id, "")
}
output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat[*].id
}
output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}
output "natgw_public_ips" {
  description = "List of NAT Gateway public IPS"
  value       = aws_nat_gateway.this[*].public_ip
}
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, "")
}
output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].arn, "")
}
output "default_vpc_id" {
  description = "The ID of the Default VPC"
  value       = try(aws_default_vpc.this[0].id, "")
}
output "default_vpc_arn" {
  description = "The ARN of the Default VPC"
  value       = try(aws_default_vpc.this[0].arn, "")
}
output "default_vpc_cidr_block" {
  description = "The CIDR block of the Default VPC"
  value       = try(aws_default_vpc.this[0].cidr_block, "")
}
output "default_vpc_default_security_group_id" {
  description = "The ID of the security group created by default on Default VPC creation"
  value       = try(aws_default_vpc.this[0].default_security_group_id, "")
}
output "default_vpc_default_network_acl_id" {
  description = "The ID of the default network ACL of the Default VPC"
  value       = try(aws_default_vpc.this[0].default_network_acl_id, "")
}
output "default_vpc_default_route_table_id" {
  description = "The ID of the default route table of the Default VPC"
  value       = try(aws_default_vpc.this[0].default_route_table_id, "")
}
output "default_vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within Default VPC"
  value       = try(aws_default_vpc.this[0].instance_tenancy, "")
}
output "default_vpc_enable_dns_support" {
  description = "Whether or not the Default VPC has DNS support"
  value       = try(aws_default_vpc.this[0].enable_dns_support, "")
}
output "default_vpc_enable_dns_hostnames" {
  description = "Whether or not the Default VPC has DNS hostname support"
  value       = try(aws_default_vpc.this[0].enable_dns_hostnames, "")
}
output "default_vpc_main_route_table_id" {
  description = "The ID of the main route table associated with the Default VPC"
  value       = try(aws_default_vpc.this[0].main_route_table_id, "")
}
output "frontends_network_acl_id" {
  description = "ID of the public network ACL"
  value       = try(aws_network_acl.frontend[0].id, "")
}
output "frontends_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = try(aws_network_acl.frontend[0].arn, "")
}
output "backends_network_acl_id" {
  description = "ID of the backends network ACL"
  value       = try(aws_network_acl.backend[0].id, "")
}
output "private_network_acl_arn" {
  description = "ARN of the backends network ACL"
  value       = try(aws_network_acl.backend[0].arn, "")
}
output "databases_network_acl_id" {
  description = "ID of the backends network ACL"
  value       = try(aws_network_acl.database[0].id, "")
}
output "databases_network_acl_arn" {
  description = "ARN of the databases network ACL"
  value       = try(aws_network_acl.database[0].arn, "")
}
output "dopt_domain_name_servers" {
  description = "Domain Name Server from DOPT"
  value       = aws_vpc_dhcp_options.this[0].domain_name_servers
}
output "database_subnet_group_name" {
  description = "Database Subnet Group Name"
  value = try(aws_db_subnet_group.database[0].name, "")
}

# ---------------------------------------------------------------------------------------------------------------------
# STATIC VALUES
# ---------------------------------------------------------------------------------------------------------------------
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}
output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.vpc_name
}
