output "frontends_route_table_ids" {
  description = "List of IDs of public route tables (frontends)"
  value       = module.client_vpc.frontends_route_table_ids
}
output "backends_route_table_ids" {
  description = "List of IDs of private route tables (backends)"
  value       = module.client_vpc.backends_route_table_ids
}
output "vpc_id" {
  description = "VPC ID"
  value       = module.client_vpc.vpc_id
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.client_vpc.vpc_cidr_block
}
output "backends_subnets" {
  description = "List of IDs of private subnets (backends)"
  value       = module.client_vpc.backends_subnets
}
output "cidr_block" {
  description = "VPC CIDR block"
  value       = module.client_vpc.vpc_cidr_block
}
output "natgw_public_ips" {
  description = "List of NAT Gateway IDs"
  value       = module.client_vpc.natgw_public_ips
}
output "alb_listener_arn" {
  description = "The ARN of the load balancer listener"
  value       = aws_lb_listener.this.arn
}
output "alb_security_group_id" {
  description = "The id of the load balancer security group"
  value       = aws_security_group.load_balancer.id
}
output "nat_public_ip" {
  description = "Public IP used for NAT access (either instance or gateway)"
  value       = var.use_nat_instance ? module.EC2NATInstance[0].instance_public_ip : module.client_vpc.natgw_public_ips[0]
}
output "nat_instance_id" {
  description = "NAT instance ID"
  value       = var.use_nat_instance ? module.EC2NATInstance[0].instance_id : null
}
output "sg_nat_instance_id" {
  description = "Security group ID for the NAT instance"
  value       = var.use_nat_instance ? module.SGEC2ForNATInstance[0].security_group_id : null
}
