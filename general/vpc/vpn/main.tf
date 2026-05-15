# ---------------------------------------------------------------------------------------------------------------------
# VPN Site-to-Site
# ---------------------------------------------------------------------------------------------------------------------

# VPN Gateway
resource "aws_vpn_gateway" "this" {
  count             = var.create_vpn ? 1 : 0
  vpc_id            = try(var.aws_vpn_gateway[count.index].vpc_id, null)
  availability_zone = try(var.aws_vpn_gateway[count.index].availability_zone, null)
  amazon_side_asn   = try(var.aws_vpn_gateway[count.index].amazon_side_asn, null)
  tags = try(var.aws_vpn_gateway[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/vpc/vpn"
  })
}

# Customer Gateway
resource "aws_customer_gateway" "this" {
  count           = var.create_vpn ? length(var.aws_customer_gateway) : 0
  device_name     = try(var.aws_customer_gateway[count.index].device_name, null)
  bgp_asn         = try(var.aws_customer_gateway[count.index].bgp_asn, "65000")
  ip_address      = try(var.aws_customer_gateway[count.index].ip_address, null)
  type            = try(var.aws_customer_gateway[count.index].type, "ipsec.1")
  certificate_arn = try(var.aws_customer_gateway[count.index].certificate_arn, null)
  tags = try(var.aws_customer_gateway[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/vpc/vpn"
  })
}

# VPN Connection
resource "aws_vpn_connection" "this" {
  count                                   = var.create_vpn ? length(var.aws_vpn_connection) : 0
  vpn_gateway_id                          = try(var.aws_vpn_connection[count.index].vpn_gateway_id, aws_vpn_gateway.this[0].id)
  customer_gateway_id                     = try(var.aws_vpn_connection[count.index].customer_gateway_id, aws_customer_gateway.this[0].id)
  type                                    = try(var.aws_vpn_connection[count.index].type, aws_customer_gateway.this[0].type)
  transit_gateway_id                      = try(var.aws_vpn_connection[count.index].transit_gateway_id, null)
  transport_transit_gateway_attachment_id = try(var.aws_vpn_connection[count.index].transport_transit_gateway_attachment_id, null)
  static_routes_only                      = try(var.aws_vpn_connection[count.index].static_routes_only, false)
  enable_acceleration                     = try(var.aws_vpn_connection[count.index].enable_acceleration, null)
  local_ipv4_network_cidr                 = try(var.aws_vpn_connection[count.index].local_ipv4_network_cidr, "0.0.0.0/0")
  local_ipv6_network_cidr                 = try(var.aws_vpn_connection[count.index].local_ipv6_network_cidr, null)
  remote_ipv4_network_cidr                = try(var.aws_vpn_connection[count.index].remote_ipv4_network_cidr, "0.0.0.0/0")
  remote_ipv6_network_cidr                = try(var.aws_vpn_connection[count.index].remote_ipv6_network_cidr, null)
  outside_ip_address_type                 = try(var.aws_vpn_connection[count.index].outside_ip_address_type, "PublicIpv4")
  tunnel_inside_ip_version                = try(var.aws_vpn_connection[count.index].tunnel_inside_ip_version, "ipv4")
  tunnel1_inside_cidr                     = try(var.aws_vpn_connection[count.index].tunnel1_inside_cidr, null)
  tunnel2_inside_cidr                     = try(var.aws_vpn_connection[count.index].tunnel2_inside_cidr, null)
  tunnel1_preshared_key                   = try(var.aws_vpn_connection[count.index].tunnel1_preshared_key, null)
  tunnel2_preshared_key                   = try(var.aws_vpn_connection[count.index].tunnel2_preshared_key, null)
  tunnel1_dpd_timeout_action              = try(var.aws_vpn_connection[count.index].tunnel1_dpd_timeout_action, "clear")
  tunnel2_dpd_timeout_action              = try(var.aws_vpn_connection[count.index].tunnel2_dpd_timeout_action, "clear")
  tunnel1_dpd_timeout_seconds             = try(var.aws_vpn_connection[count.index].tunnel1_dpd_timeout_seconds, "30")
  tunnel2_dpd_timeout_seconds             = try(var.aws_vpn_connection[count.index].tunnel2_dpd_timeout_seconds, "30")
  tunnel1_enable_tunnel_lifecycle_control = try(var.aws_vpn_connection[count.index].tunnel1_enable_tunnel_lifecycle_control, false)
  tunnel2_enable_tunnel_lifecycle_control = try(var.aws_vpn_connection[count.index].tunnel2_enable_tunnel_lifecycle_control, false)
  tunnel1_ike_versions                    = try(var.aws_vpn_connection[count.index].tunnel1_ike_versions, null)
  tunnel2_ike_versions                    = try(var.aws_vpn_connection[count.index].tunnel2_ike_versions, null)
  tunnel1_phase1_dh_group_numbers         = try(var.aws_vpn_connection[count.index].tunnel1_phase1_dh_group_numbers, null)
  tunnel2_phase1_dh_group_numbers         = try(var.aws_vpn_connection[count.index].tunnel2_phase1_dh_group_numbers, null)
  tunnel1_phase1_encryption_algorithms    = try(var.aws_vpn_connection[count.index].tunnel1_phase1_encryption_algorithms, null)
  tunnel2_phase1_encryption_algorithms    = try(var.aws_vpn_connection[count.index].tunnel2_phase1_encryption_algorithms, null)
  tunnel1_phase1_integrity_algorithms     = try(var.aws_vpn_connection[count.index].tunnel1_phase1_integrity_algorithms, null)
  tunnel2_phase1_integrity_algorithms     = try(var.aws_vpn_connection[count.index].tunnel1_phase2_integrity_algorithms, null)
  tunnel1_phase1_lifetime_seconds         = try(var.aws_vpn_connection[count.index].tunnel1_phase1_lifetime_seconds, "28800")
  tunnel2_phase1_lifetime_seconds         = try(var.aws_vpn_connection[count.index].tunnel2_phase1_lifetime_seconds, "28800")
  tunnel1_phase2_dh_group_numbers         = try(var.aws_vpn_connection[count.index].tunnel1_phase2_dh_group_numbers, null)
  tunnel2_phase2_dh_group_numbers         = try(var.aws_vpn_connection[count.index].tunnel2_phase2_dh_group_numbers, null)
  tunnel1_phase2_encryption_algorithms    = try(var.aws_vpn_connection[count.index].tunnel1_phase2_encryption_algorithms, null)
  tunnel2_phase2_encryption_algorithms    = try(var.aws_vpn_connection[count.index].tunnel2_phase2_encryption_algorithms, null)
  tunnel1_phase2_integrity_algorithms     = try(var.aws_vpn_connection[count.index].tunnel1_phase2_integrity_algorithms, null)
  tunnel2_phase2_integrity_algorithms     = try(var.aws_vpn_connection[count.index].tunnel2_phase2_integrity_algorithms, null)
  tunnel1_phase2_lifetime_seconds         = try(var.aws_vpn_connection[count.index].tunnel1_phase2_lifetime_seconds, "3600")
  tunnel2_phase2_lifetime_seconds         = try(var.aws_vpn_connection[count.index].tunnel2_phase2_lifetime_seconds, "3600")
  tunnel1_rekey_fuzz_percentage           = try(var.aws_vpn_connection[count.index].tunnel1_rekey_fuzz_percentage, "100")
  tunnel2_rekey_fuzz_percentage           = try(var.aws_vpn_connection[count.index].tunnel2_rekey_fuzz_percentage, "100")
  tunnel1_rekey_margin_time_seconds       = try(var.aws_vpn_connection[count.index].tunnel1_rekey_margin_time_seconds, "540")
  tunnel2_rekey_margin_time_seconds       = try(var.aws_vpn_connection[count.index].tunnel2_rekey_margin_time_seconds, "540")
  tunnel1_replay_window_size              = try(var.aws_vpn_connection[count.index].tunnel1_replay_window_size, "1024")
  tunnel2_replay_window_size              = try(var.aws_vpn_connection[count.index].tunnel2_replay_window_size, "1024")
  tunnel1_startup_action                  = try(var.aws_vpn_connection[count.index].tunnel1_startup_action, "add")
  tunnel2_startup_action                  = try(var.aws_vpn_connection[count.index].tunnel2_startup_action, "add")
  tags = try(var.aws_vpn_connection[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/vpc/vpn"
  })
  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = try(var.aws_vpn_connection[count.index].tunnel1_log_options.cloudwatch_log_options.log_enabled, false)
      log_group_arn     = try(var.aws_vpn_connection[count.index].tunnel1_log_options.cloudwatch_log_options.log_group_arn, null)
      log_output_format = try(var.aws_vpn_connection[count.index].tunnel1_log_options.cloudwatch_log_options.log_output_format, null)
    }
  }
  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = try(var.aws_vpn_connection[count.index].tunnel2_log_options.cloudwatch_log_options.log_enabled, false)
      log_group_arn     = try(var.aws_vpn_connection[count.index].tunnel2_log_options.cloudwatch_log_options.log_group_arn, null)
      log_output_format = try(var.aws_vpn_connection[count.index].tunnel2_log_options.cloudwatch_log_options.log_output_format, null)
    }
  }
}

# VPN Routes
resource "aws_vpn_connection_route" "this" {
  count                  = var.create_vpn ? length(var.aws_vpn_connection_route) : 0
  destination_cidr_block = try(var.aws_vpn_connection_route[count.index].destination_cidr_block, "0.0.0.0/0")
  vpn_connection_id      = try(var.aws_vpn_connection_route[count.index].vpn_connection_id, aws_vpn_connection.this[0].id)
}