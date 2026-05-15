resource "aws_lb" "this" {
  name               = "${var.enterprise_context.vertical_initials}-aws-lb-${lower(local.common_tags.Ambiente)}-${var.client_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer.id]
  idle_timeout       = var.load_balancer_idle_timeout
  subnets            = module.client_vpc.frontends_subnets

  tags = local.common_tags
}

resource "aws_security_group" "load_balancer" {
  name        = "${var.enterprise_context.vertical_initials}-security-group-${lower(local.common_tags.Ambiente)}-${var.client_name}-load-balancer"
  description = "Allows access from ALL"
  vpc_id      = module.client_vpc.vpc_id
  tags        = local.common_tags

  ingress {
    protocol    = "TCP"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow TCP port 443 from all"
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = module.client_vpc.backends_subnets_cidr_blocks
    description = "Allow all trafic"
  }
}



resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = var.acm_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Service Unavailable"
      status_code  = "503"
    }
  }

  tags = local.common_tags
}