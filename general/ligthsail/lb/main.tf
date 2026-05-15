# Load Balancer
resource "aws_lightsail_lb" "this" {
  name              = var.lb_name
  health_check_path = var.health_path
  instance_port     = var.instance_port
  tags              = var.default_tags
  ip_address_type   = var.ip_type
}
resource "aws_lightsail_lb_stickiness_policy" "this" {
  lb_name         = aws_lightsail_lb.this.name
  cookie_duration = var.cookie_duration
  enabled         = true
}