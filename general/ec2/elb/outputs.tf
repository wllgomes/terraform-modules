output "elb_arn" {
  value = aws_lb.this[0].arn
}
output "elb_id" {
  value = aws_lb.this[0].id
}
output "elb_dns_name" {
  value = aws_lb.this[0].dns_name
}
output "elb_zone_id" {
  value = aws_lb.this[0].zone_id
}

output "elb_tg_arn" {
  value = aws_lb_target_group.this[*].arn
}
output "elb_listener_arn" {
  value = aws_lb_listener.this[*].arn
}