# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.default_tags,
    {
      Name        = var.vpc_name
      Description = var.vpc_description
    }
  )
}
resource "aws_default_vpc" "this" {
  count = var.manage_default_vpc ? 1 : 0

  enable_dns_support   = var.default_vpc_enable_dns_support
  enable_dns_hostnames = var.default_vpc_enable_dns_hostnames

  tags = merge(
    var.default_tags,
    {
      Name        = var.default_vpc_name
      Description = var.default_vpc_description
    }
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Default Security Group
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_default_security_group" "this" {
  count  = var.manage_default_security_group ? 1 : 0
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  egress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0

  }

  tags = merge(
    var.default_tags,
    {
      Name        = "sg_default"
      Description = "Default SG - Do not use this"
    }
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Default ACL
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_default_network_acl" "this" {
  count = var.manage_default_network_acl ? 1 : 0

  default_network_acl_id = aws_vpc.this.default_network_acl_id

  # subnet_ids is using lifecycle ignore_changes, so it is not necessary to list
  # any explicitly. See https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/736.
  subnet_ids = null

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    var.default_tags,
    {
      Name        = "acl_default_${var.vpc_name}"
      Description = "Default ACL - Do not use this"
    }
  )

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Public (frontend) ACL
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_network_acl" "frontend" {
  count = var.frontends_dedicated_network_acl && length(var.frontend_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.frontend[*].id

  tags = merge(
    var.default_tags,
    {
      Name        = "acl_frontends"
      Description = "ACL for frontends subnets"
    }
  )
}
resource "aws_network_acl_rule" "frontend_inbound" {
  count = var.frontends_dedicated_network_acl && length(var.frontend_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.frontend[0].id

  egress      = false
  rule_number = 100
  rule_action = "allow"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_block  = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "frontend_outbound" {
  count = var.frontends_dedicated_network_acl && length(var.frontend_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.frontend[0].id
  egress         = true
  rule_number    = 100
  rule_action    = "allow"
  from_port      = 0
  to_port        = 0
  protocol       = -1
  cidr_block     = "0.0.0.0/0"
}

# ---------------------------------------------------------------------------------------------------------------------
# Private (backends and databases) ACL
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_network_acl" "backend" {
  count = var.backends_dedicated_network_acl && length(var.backend_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.backend[*].id

  tags = merge(
    var.default_tags,
    {
      Name        = "acl_backends"
      Description = "ACL for backends subnets"
    }
  )
}
resource "aws_network_acl_rule" "backend_inbound" {
  count = var.backends_dedicated_network_acl && length(var.backend_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.backend[0].id

  egress      = false
  rule_number = 100
  rule_action = "allow"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_block  = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "backend_outbound" {
  count = var.backends_dedicated_network_acl && length(var.backend_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.backend[0].id
  egress         = true
  rule_number    = 100
  rule_action    = "allow"
  from_port      = 0
  to_port        = 0
  protocol       = -1
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl" "database" {
  count = var.databases_dedicated_network_acl && length(var.database_subnets) > 0 ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.default_tags,
    {
      Name        = "acl_databases"
      Description = "ACL for databases subnets"
    }
  )
}
resource "aws_network_acl_rule" "database_inbound" {
  count = var.databases_dedicated_network_acl && length(var.database_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.database[0].id

  egress      = false
  rule_number = 100
  rule_action = "allow"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_block  = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "database_outbound" {
  count = var.databases_dedicated_network_acl && length(var.database_subnets) > 0 ? 1 : 0

  network_acl_id = aws_network_acl.database[0].id
  egress         = true
  rule_number    = 100
  rule_action    = "allow"
  from_port      = 0
  to_port        = 0
  protocol       = -1
  cidr_block     = "0.0.0.0/0"
}

# ---------------------------------------------------------------------------------------------------------------------
# DHCP Options Set
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_vpc_dhcp_options" "this" {
  count                = var.enable_dhcp_options ? 1 : 0
  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type

  tags = merge(
    var.default_tags,
    {
      Name = var.dopt_name
    }
  )
}
resource "aws_vpc_dhcp_options_association" "this" {
  count           = var.enable_dhcp_options ? 1 : 0
  vpc_id          = aws_vpc.this.id
  dhcp_options_id = aws_vpc_dhcp_options.this[count.index].id
}

# ---------------------------------------------------------------------------------------------------------------------
# Public subnets (frontend)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "frontend" {
  count = length(var.frontend_subnets) > 0 ? length(var.frontend_subnets) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(concat(var.frontend_subnets, [""]), count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)
  tags = merge(
    var.default_tags,
    {
    Name = "subnet-frontend-${count.index}" }
  )
}
# ---------------------------------------------------------------------------------------------------------------------
# Private subnets (backend and databases)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "backend" {
  count = length(var.backend_subnets) > 0 ? length(var.backend_subnets) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(concat(var.backend_subnets, [""]), count.index)
  map_public_ip_on_launch = false
  availability_zone       = element(var.azs, count.index)
  tags = merge(
    var.default_tags,
    {
    Name = "subnet-backend-${count.index}" }
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_subnets) > 0 ? length(var.database_subnets) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(concat(var.database_subnets, [""]), count.index)
  map_public_ip_on_launch = false
  availability_zone       = element(var.azs, count.index)
  tags = merge(
    var.default_tags,
    {
    Name = "subnet-database-${count.index}" }
  )
}
resource "aws_db_subnet_group" "database" {
  count = length(var.database_subnets) > 0 ? 1 : 0

  name       = "subnet-group-database"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(
    var.default_tags,
    {
    Name = "subnet-group-database" }
  )
}


# ---------------------------------------------------------------------------------------------------------------------
# Internet Gateways
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.default_tags,
    {
      Name = var.igw_name
    }
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# NAT Gateways
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = merge(
    var.default_tags,
    {
      Name = "eip-natgw-${var.vpc_name}"
    }
  )

}
resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.frontend.*.id[0]
  depends_on    = [aws_internet_gateway.this]
  tags = merge(
    var.default_tags,
    {
      Name = var.natgw_name
    }
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Default Route Table
#----------------------------------------------------------------------------------------------------
resource "aws_default_route_table" "default" {
  count = var.manage_default_route_table ? 1 : 0

  default_route_table_id = aws_vpc.this.default_route_table_id
  route                  = []

  timeouts {
    create = "5m"
    update = "5m"
  }

  tags = merge(
    var.default_tags,
    {
      Name = "rtb-default"
    }
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Public Routes
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "frontend" {
  count  = length(var.frontend_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.default_tags,
    {
      Name = var.rtb_frontend_name
    }
  )
}
resource "aws_route" "frontend_internet_gateway" {
  count                  = var.create_igw && length(var.frontend_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.frontend[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
  timeouts {
    create = "5m"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Privates Routes (backends and databases)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "backend" {
  count  = length(var.backend_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.default_tags,
    {
      Name = var.rtb_backend_name
    }
  )
}
resource "aws_route" "backend_internet_gateway" {
  count = var.create_igw && length(var.backend_subnets) > 0 && var.create_backend_subnet_internet_gateway_route == true ? 1 : 0

  route_table_id         = aws_route_table.backend[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[count.index].id
  timeouts {
    create = "5m"
  }
}
resource "aws_route" "backend_nat_gateway" {
  count = var.create_igw && length(var.backend_subnets) > 0 && var.create_backend_subnet_nat_gateway_route == true ? 1 : 0

  route_table_id         = element(aws_route_table.backend[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table" "database" {
  count  = length(var.database_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    var.default_tags,
    {
      Name = var.rtb_databases_name
    }
  )
}
resource "aws_route" "database_internet_gateway" {
  count = var.create_igw && length(var.backend_subnets) > 0 && var.create_database_subnet_internet_gateway_route == true ? 1 : 0

  route_table_id         = aws_route_table.database[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[count.index].id
  timeouts {
    create = "5m"
  }
}
resource "aws_route" "database_nat_gateway" {
  count = var.create_igw && length(var.backend_subnets) > 0 && var.create_database_subnet_nat_gateway_route == true ? 1 : 0

  route_table_id         = element(aws_route_table.database[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Public Routes Subnet Associate
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "frontend" {
  count          = length(var.frontend_subnets) > 0 ? length(var.frontend_subnets) : 0
  subnet_id      = element(aws_subnet.frontend.*.id, count.index)
  route_table_id = aws_route_table.frontend[0].id
}

# ---------------------------------------------------------------------------------------------------------------------
# Private Routes (backend and databases) Subnet Associate
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "backend" {
  count          = length(var.backend_subnets) > 0 ? length(var.backend_subnets) : 0
  subnet_id      = element(aws_subnet.backend.*.id, count.index)
  route_table_id = aws_route_table.backend[0].id
}
resource "aws_route_table_association" "database" {
  count          = length(var.database_subnets) > 0 ? length(var.database_subnets) : 0
  subnet_id      = element(aws_subnet.database.*.id, count.index)
  route_table_id = aws_route_table.database[0].id
}
