# ---------------------------------------------------------------------------------------------------------------------
# VPN GATEWAY
# ---------------------------------------------------------------------------------------------------------------------
output "vpn_gateway_arn" {
  value = aws_vpn_gateway.this[*].arn
}
output "vpn_gateway_id" {
  value = aws_vpn_gateway.this[*].id
}
output "vpn_gateway_amazon_side_asn" {
  value = aws_vpn_gateway.this[*].amazon_side_asn
}
output "vpn_gateway_availability_zone" {
  value = aws_vpn_gateway.this[*].availability_zone
}

# ---------------------------------------------------------------------------------------------------------------------
# CUSTOMER GATEWAY
# ---------------------------------------------------------------------------------------------------------------------
output "customer_gateway_id" {
  value = aws_customer_gateway.this[*].id
}
output "customer_gateway_arn" {
  value = aws_customer_gateway.this[*].arn
}
output "customer_gateway_name" {
  value = aws_customer_gateway.this[*].device_name
}
output "customer_gateway_ip_address" {
  value = aws_customer_gateway.this[*].ip_address
}

# ---------------------------------------------------------------------------------------------------------------------
# VPN CONNECTIONS
# ---------------------------------------------------------------------------------------------------------------------
output "vpn_connection_id" {
  value = aws_vpn_connection.this[*].id
}
output "vpn_connection_arn" {
  value = aws_vpn_connection.this[*].arn
}