# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------
module "client_vpc" {
  source                                  = "../../general/vpc"
  vpc_cidr                                = "${var.vpc_cidr_24_suffix}.0/24"
  vpc_name                                = "${var.enterprise_context.vertical_initials}-vpc-${lower(local.common_tags.Ambiente)}-${var.client_name}"
  igw_name                                = "${var.enterprise_context.vertical_initials}-igw-${lower(local.common_tags.Ambiente)}-${var.client_name}"
  natgw_name                              = "${var.enterprise_context.vertical_initials}-natgw-${lower(local.common_tags.Ambiente)}-${var.client_name}"
  azs                                     = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  dhcp_options_domain_name                = "enacom.local"
  enable_dhcp_options                     = true
  enable_nat_gateway                      = var.use_nat_instance ? false : true
  create_backend_subnet_nat_gateway_route = var.use_nat_instance ? false : true
  create_igw                              = true

  database_subnet_group_suffix = var.client_name

  frontend_subnets = coalesce(
    var.subnets_frontend_cidr,
    [
      "${var.vpc_cidr_24_suffix}.0/28", # [1, 16[
      "${var.vpc_cidr_24_suffix}.16/28" # [16, 31[
    ]
  )

  backend_subnets = coalesce(
    var.subnets_backend_cidr,
    [
      "${var.vpc_cidr_24_suffix}.32/28", # [32, 48[
      "${var.vpc_cidr_24_suffix}.48/28"  # [48, 64[
    ]
  )

  default_tags = local.common_tags
}

resource "aws_route" "frontend" {
  for_each = {
    for index, value in var.peering_connection_accepters :
    value.id => value
  }
  route_table_id            = module.client_vpc.frontends_route_table_ids[0]
  destination_cidr_block    = each.value.cidr_block
  vpc_peering_connection_id = each.value.id
}

resource "aws_route" "backend" {
  for_each = {
    for index, value in var.peering_connection_accepters :
    value.id => value
  }
  route_table_id            = module.client_vpc.backends_route_table_ids[0]
  destination_cidr_block    = each.value.cidr_block
  vpc_peering_connection_id = each.value.id
}

resource "aws_route" "backend_nat_instance" {
  count = var.use_nat_instance ? 1 : 0

  route_table_id         = element(module.client_vpc.backends_route_table_ids[*], count.index)
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.EC2NATInstance[count.index].network_interface_id
}

resource "aws_vpc_peering_connection_accepter" "main" {
  for_each = {
    for index, value in var.peering_connection_accepters :
    value.id => value
  }

  vpc_peering_connection_id = each.value.id
  auto_accept               = true
  tags = merge(
    local.common_tags,
    {
      Name = "${var.enterprise_context.vertical_initials}-pcx-${lower(local.common_tags.Ambiente)}-${each.value.name}"
    }
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUPS
# ---------------------------------------------------------------------------------------------------------------------

# NAT Instance
module "SGEC2ForNATInstance" {
  count           = var.use_nat_instance ? 1 : 0
  source          = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git"
  name            = "${var.enterprise_context.vertical_initials}-sg-${var.enterprise_context.environment}-ec2-${var.client_name}-nat-instance"
  use_name_prefix = false
  vpc_id          = module.client_vpc.vpc_id
  tags = merge(
    local.common_tags,
    {
      Name        = "${var.enterprise_context.vertical_initials}-sg-${var.enterprise_context.environment}-ec2-${var.client_name}-nat-instance"
      Description = "Security Group - EC2 instances with NAT Instance"
    }
  )

  # Ingress rules
  ingress_with_cidr_blocks = [
    {
      rule        = "all-icmp"
      cidr_blocks = module.client_vpc.vpc_cidr_block
      description = "Allow all ICMP"
    },
    {
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      cidr_blocks = "10.31.0.151/32"
      description = "Allow node-exporter from prometheus"
    },
    {
      rule        = "all-all"
      cidr_blocks = module.client_vpc.vpc_cidr_block
      description = "Allow all traffic within VPC"
    }
  ]
  # Egress rules
  egress_with_cidr_blocks = concat([
    {
      rule        = "all-icmp"
      cidr_blocks = module.client_vpc.vpc_cidr_block
      description = "Allow all ICMP to VPC"
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTP"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS"
    }
  ], var.additional_nat_instance_egress_with_cidr_blocks)
}
