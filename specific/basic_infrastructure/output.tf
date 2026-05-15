output "s3_state_bucket_name" {
  value = module.S3TerraformState.bucket_name
}

output "s3_state_kms_key_id" {
  value = module.KMSBucketS3.kms_key_id
}

# ---------------------------------------------------------------------------------------------------------------------
# Key Pair
# ---------------------------------------------------------------------------------------------------------------------

output "ec2_key_pair_name" {
  description = "EC2 Key Pair name"
  value       = length(aws_key_pair.ec2_keypair) > 0 ? aws_key_pair.ec2_keypair[0].key_name : null
}

# ---------------------------------------------------------------------------------------------------------------------
# OUTPUT policy
# ---------------------------------------------------------------------------------------------------------------------

output "agent_policy_arn" {
  description = "The ARN of the Azure Agent's Policy"
  value       = module.IAMPolicyEC2AzureAgents.arn
}

output "session_manager_log_policy_arn" {
  description = "The ARN of the Policy to allow Session Manager to log"
  value       = aws_iam_policy.session_manager_logs.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# OUTPUT role
# ---------------------------------------------------------------------------------------------------------------------

output "ec2_ssm_role_name" {
  value       = var.use_nat_instance ? module.RoleEC2SSM.role_name : null
  description = "The name of the EC2 SSM Role"
}

output "ec2_ssm_role_arn" {
  value       = var.use_nat_instance ? module.RoleEC2SSM.role_arn : null
  description = "The ARN of the EC2 SSM Role"
}

# ---------------------------------------------------------------------------------------------------------------------
# OUTPUT VPC KMS
# ---------------------------------------------------------------------------------------------------------------------

output "kms_ebs_arn" {
  description = "The ARN of EBS KMS"
  value       = module.KMSEBSVolumes.kms_arn
}


output "kms_ebs_id" {
  description = "The ID of EBS KMS"
  value       = module.KMSEBSVolumes.kms_id
}

output "kms_ebs_key_id" {
  description = "The KEY ID of EBS KMS"
  value       = module.KMSEBSVolumes.kms_key_id
}

# ---------------------------------------------------------------------------------------------------------------------
# OUTPUT VPC VALUES
# ---------------------------------------------------------------------------------------------------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.DefaultVPC.vpc_id
}
output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.DefaultVPC.vpc_arn
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.DefaultVPC.vpc_cidr_block
}
output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.DefaultVPC.default_security_group_id
}
output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = module.DefaultVPC.default_network_acl_id
}
output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = module.DefaultVPC.default_route_table_id
}
output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = module.DefaultVPC.vpc_instance_tenancy
}
output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = module.DefaultVPC.vpc_enable_dns_support
}
output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = module.DefaultVPC.vpc_enable_dns_hostnames
}
output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = module.DefaultVPC.vpc_main_route_table_id
}
output "vpc_ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = module.DefaultVPC.vpc_ipv6_association_id
}
output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = module.DefaultVPC.vpc_ipv6_cidr_block
}
output "backends_subnets" {
  description = "List of IDs of private subnets (backends)"
  value       = module.DefaultVPC.backends_subnets
}
output "databases_subnets" {
  description = "List of IDs of private subnets (databases)"
  value       = module.DefaultVPC.databases_subnets
}
output "backends_subnet_arns" {
  description = "List of ARNs of private subnets (backends)"
  value       = module.DefaultVPC.backends_subnet_arns
}
output "databases_subnet_arns" {
  description = "List of ARNs of private subnets (databases)"
  value       = module.DefaultVPC.databases_subnet_arns
}
output "backends_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets (backends)"
  value       = module.DefaultVPC.backends_subnets_cidr_blocks
}
output "databases_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets (databases)"
  value       = module.DefaultVPC.databases_subnets_cidr_blocks
}
output "frontends_subnets" {
  description = "List of IDs of public subnets (frontends)"
  value       = module.DefaultVPC.frontends_subnets
}
output "frontends_subnet_arns" {
  description = "List of ARNs of public subnets (frontends)"
  value       = module.DefaultVPC.frontends_subnet_arns
}
output "frontends_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets (frontends)"
  value       = module.DefaultVPC.frontends_subnets_cidr_blocks
}
output "frontends_route_table_ids" {
  description = "List of IDs of public route tables (frontends)"
  value       = module.DefaultVPC.frontends_route_table_ids
}
output "backends_route_table_ids" {
  description = "List of IDs of private route tables (backends)"
  value       = module.DefaultVPC.backends_route_table_ids
}
output "databases_route_table_ids" {
  description = "List of IDs of private route tables (database)"
  value       = module.DefaultVPC.databases_route_table_ids
}
output "frontend_internet_gateway_route_id" {
  description = "ID of the internet gateway route"
  value       = module.DefaultVPC.frontend_internet_gateway_route_id
}
output "databases_internet_gateway_route_id" {
  description = "ID of the database internet gateway route"
  value       = module.DefaultVPC.databases_internet_gateway_route_id
}
output "database_nat_gateway_route_ids" {
  description = "List of IDs of the database nat gateway route"
  value       = module.DefaultVPC.database_nat_gateway_route_ids
}
output "backends_internet_gateway_route_id" {
  description = "ID of the backend internet gateway route"
  value       = module.DefaultVPC.backends_internet_gateway_route_id
}
output "dbackend_nat_gateway_route_ids" {
  description = "List of IDs of the database nat gateway route"
  value       = module.DefaultVPC.dbackend_nat_gateway_route_ids
}
output "dhcp_options_id" {
  description = "The ID of the DHCP options"
  value       = module.DefaultVPC.dhcp_options_id
}
output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = module.DefaultVPC.nat_ids
}
output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.DefaultVPC.natgw_ids
}
output "natgw_public_ips" {
  description = "List of NAT Gateway public IPS"
  value       = module.DefaultVPC.natgw_public_ips
}
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.DefaultVPC.igw_id
}
output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = module.DefaultVPC.igw_arn
}
output "default_vpc_id" {
  description = "The ID of the Default VPC"
  value       = module.DefaultVPC.default_vpc_id
}
output "default_vpc_arn" {
  description = "The ARN of the Default VPC"
  value       = module.DefaultVPC.default_vpc_arn
}
output "default_vpc_cidr_block" {
  description = "The CIDR block of the Default VPC"
  value       = module.DefaultVPC.default_vpc_cidr_block
}
output "default_vpc_default_security_group_id" {
  description = "The ID of the security group created by default on Default VPC creation"
  value       = module.DefaultVPC.default_vpc_default_security_group_id
}
output "default_vpc_default_network_acl_id" {
  description = "The ID of the default network ACL of the Default VPC"
  value       = module.DefaultVPC.default_vpc_default_network_acl_id
}
output "default_vpc_default_route_table_id" {
  description = "The ID of the default route table of the Default VPC"
  value       = module.DefaultVPC.default_vpc_default_route_table_id
}
output "default_vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within Default VPC"
  value       = module.DefaultVPC.default_vpc_instance_tenancy
}
output "default_vpc_enable_dns_support" {
  description = "Whether or not the Default VPC has DNS support"
  value       = module.DefaultVPC.default_vpc_enable_dns_support
}
output "default_vpc_enable_dns_hostnames" {
  description = "Whether or not the Default VPC has DNS hostname support"
  value       = module.DefaultVPC.default_vpc_enable_dns_hostnames
}
output "default_vpc_main_route_table_id" {
  description = "The ID of the main route table associated with the Default VPC"
  value       = module.DefaultVPC.default_vpc_main_route_table_id
}
output "frontends_network_acl_id" {
  description = "ID of the public network ACL"
  value       = module.DefaultVPC.frontends_network_acl_id
}
output "frontends_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = module.DefaultVPC.frontends_network_acl_arn
}
output "backends_network_acl_id" {
  description = "ID of the backends network ACL"
  value       = module.DefaultVPC.backends_network_acl_id
}
output "private_network_acl_arn" {
  description = "ARN of the backends network ACL"
  value       = module.DefaultVPC.private_network_acl_arn
}
output "databases_network_acl_id" {
  description = "ID of the backends network ACL"
  value       = module.DefaultVPC.databases_network_acl_id
}
output "databases_network_acl_arn" {
  description = "ARN of the databases network ACL"
  value       = module.DefaultVPC.databases_network_acl_arn
}
output "dopt_domain_name_servers" {
  description = "Domain Name Server from DOPT"
  value       = module.DefaultVPC.dopt_domain_name_servers
}
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.DefaultVPC.azs
}
output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = module.DefaultVPC.name
}
output "database_subnet_group_name" {
  description = "Database Subnet Group Name"
  value       = module.DefaultVPC.database_subnet_group_name
}
output "sg_nat_instance_id" {
  description = "Security group ID for the NAT instance"
  value       = var.use_nat_instance ? module.SGEC2ForNATInstance[0].security_group_id : null
}
