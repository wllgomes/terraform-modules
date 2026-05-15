# ---------------------------------------------------------------------------------------------------------------------
# LOAD BALANCERS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lb" "this" {
  count = var.create_lb ? 1 : 0

  name        = try(var.lb[count.index].name, null)
  name_prefix = try(var.lb[count.index].name_prefix, null)

  internal                                    = try(var.lb[count.index].internal, false)
  load_balancer_type                          = try(var.lb[count.index].load_balancer_type, "application")
  security_groups                             = try(var.lb[count.index].security_groups, null)
  idle_timeout                                = try(var.lb[count.index].idle_timeout, 60)
  ip_address_type                             = try(var.lb[count.index].ip_address_type, "ipv4")
  subnets                                     = try(var.lb[count.index].subnets, null)
  enable_deletion_protection                  = try(var.lb[count.index].enable_deletion_protection, true)
  enable_http2                                = try(var.lb[count.index].enable_http2, true)
  enable_xff_client_port                      = try(var.lb[count.index].enable_xff_client_port, false)
  enable_waf_fail_open                        = try(var.lb[count.index].enable_waf_fail_open, false)
  enable_tls_version_and_cipher_suite_headers = try(var.lb[count.index].enable_tls_version_and_cipher_suite_headers, false)
  preserve_host_header                        = try(var.lb[count.index].preserve_host_header, false)
  xff_header_processing_mode                  = try(var.lb[count.index].xff_header_processing_mode, "append")
  enable_cross_zone_load_balancing            = try(var.lb[count.index].enable_cross_zone_load_balancing, null)
  tags = try(var.lb[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/ec2/elb"
  })

  dynamic "access_logs" {
    for_each = length(var.access_logs) > 0 ? [var.access_logs] : []

    content {
      enabled = try(access_logs.value.enabled, try(access_logs.value.bucket, null) != null)
      bucket  = try(access_logs.value.bucket, null)
      prefix  = try(access_logs.value.prefix, null)
    }
  }
  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping

    content {
      subnet_id            = subnet_mapping.value.subnet_id
      allocation_id        = try(var.subnet_mapping[count.index].allocation_id, null)
      private_ipv4_address = try(var.subnet_mapping[count.index].private_ipv4_address, null)
      ipv6_address         = try(var.subnet_mapping[count.index].ipv6_address, null)
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# TARGETS GROUPS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lb_target_group" "this" {
  count = var.create_lb ? length(var.target_groups) : 0

  name        = try(var.target_groups[count.index].name, null)
  name_prefix = try(var.target_groups[count.index].name_prefix, null)

  port             = try(var.target_groups[count.index].port, null)
  protocol         = try(upper(var.target_groups[count.index].protocol), null)
  protocol_version = try(upper(var.target_groups[count.index].protocol_version), null)
  vpc_id           = try(var.target_groups[count.index].vpc_id, null)
  target_type      = try(var.target_groups[count.index].target_type, null)

  connection_termination             = try(var.target_groups[count.index].connection_termination, null)
  deregistration_delay               = try(var.target_groups[count.index].deregistration_delay, null)
  slow_start                         = try(var.target_groups[count.index].slow_start, null)
  proxy_protocol_v2                  = try(var.target_groups[count.index].proxy_protocol_v2, false)
  lambda_multi_value_headers_enabled = try(var.target_groups[count.index].lambda_multi_value_headers_enabled, false)
  load_balancing_algorithm_type      = try(var.target_groups[count.index].load_balancing_algorithm_type, null)
  preserve_client_ip                 = try(var.target_groups[count.index].preserve_client_ip, null)
  ip_address_type                    = try(var.target_groups[count.index].ip_address_type, null)
  load_balancing_cross_zone_enabled  = try(var.target_groups[count.index].load_balancing_cross_zone_enabled, null)

  tags = try(var.target_groups[count.index].tags, {
    CreatedBy       = "Terraform"
    TerraformModule = "https://gitlab.com/phconsultoria/phconsultoria-tfm/-/tree/main/modules/ec2/elb"
  })

  dynamic "health_check" {
    for_each = try([var.target_groups[count.index].health_check], [])

    content {
      enabled             = try(health_check.value.enabled, true)
      interval            = try(health_check.value.interval, "60")
      path                = try(health_check.value.path, "/")
      port                = try(health_check.value.port, null)
      healthy_threshold   = try(health_check.value.healthy_threshold, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
      timeout             = try(health_check.value.timeout, null)
      protocol            = try(health_check.value.protocol, null)
      matcher             = try(health_check.value.matcher, "200")
    }
  }
  dynamic "stickiness" {
    for_each = try([var.target_groups[count.index].stickiness], [])

    content {
      enabled         = try(stickiness.value.enabled, null)
      cookie_duration = try(stickiness.value.cookie_duration, null)
      type            = try(stickiness.value.type, null)
      cookie_name     = try(stickiness.value.cookie_name, null)
    }
  }
}
resource "aws_lb_target_group_attachment" "this" {
  count            = var.create_lb ? length(var.targets) : 0
  target_group_arn = try(var.targets[count.index].target_group_arn, aws_lb_target_group.this[0].arn)
  target_id        = try(var.targets[count.index].target_id, null)
  port             = try(var.targets[count.index].port, var.target_groups.health_check.port)
}

# ---------------------------------------------------------------------------------------------------------------------
# LISTENERS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lb_listener" "this" {
  count             = length(var.listener)
  load_balancer_arn = aws_lb.this[0].arn
  port              = var.listener[count.index].port
  protocol          = var.listener[count.index].protocol
  ssl_policy        = try(var.listener[count.index].ssl_policy, null)
  certificate_arn   = try(var.listener[count.index].certificate_arn, null)

  # forward (padrão)
  dynamic "default_action" {
    for_each = var.listener[count.index].default_action.type == "forward" ? [1] : []
    content {
      type             = "forward"
      target_group_arn = try(var.listener[count.index].target_group_arn,aws_lb_target_group.this[0].arn)
    }
  }

  # redirect
  dynamic "default_action" {
    for_each = var.listener[count.index].default_action.type == "redirect" ? [1] : []
    content {
      type = "redirect"
      redirect {
        port        = try(var.listener[count.index].default_action.redirect.port, "443")
        protocol    = try(var.listener[count.index].default_action.redirect.protocol, "HTTPS")
        status_code = try(var.listener[count.index].default_action.redirect.status_code, "301")
      }
    }
  }

  # fixed-response
  dynamic "default_action" {
    for_each = var.listener[count.index].default_action.type == "fixed-response" ? [1] : []
    content {
      type = "fixed-response"
      fixed_response {
        content_type = try(var.listener[count.index].default_action.fixed_response.content_type, "text/plain")
        message_body = try(var.listener[count.index].default_action.fixed_response.message_body, "Acesso negado")
        status_code  = try(var.listener[count.index].default_action.fixed_response.status_code, "403")
      }
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# LISTENERS RULES
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lb_listener_rule" "this" {
  count        = var.create_lb ? length(var.listener_rules) : 0
  listener_arn = try(var.listener_rules[count.index].listener_arn, aws_lb_listener.this[1].arn)
  priority     = try(var.listener_rules[count.index].priority, null)

  # forward action
  dynamic "action" {
    for_each = [
      for action_rule in var.listener_rules[count.index].actions :
      action_rule
      if action_rule.type == "forward"
    ]

    content {
      type             = action.value["type"]
      target_group_arn = try(action.value["target_group_arn"], aws_lb_target_group.this[0].id)
    }
  }

  # redirect actions
  dynamic "action" {
    for_each = [
      for action_rule in var.listener_rules[count.index].actions :
      action_rule
      if action_rule.type == "redirect"
    ]

    content {
      type = action.value["type"]
      redirect {
        host        = lookup(action.value, "host", null)
        path        = lookup(action.value, "path", null)
        port        = lookup(action.value, "port", null)
        protocol    = lookup(action.value, "protocol", null)
        query       = lookup(action.value, "query", null)
        status_code = action.value["status_code"]
      }
    }
  }

  # fixed-response actions
  dynamic "action" {
    for_each = [
      for action_rule in var.listener_rules[count.index].actions :
      action_rule
      if action_rule.type == "fixed-response"
    ]

    content {
      type = action.value["type"]
      fixed_response {
        message_body = lookup(action.value, "message_body", null)
        status_code  = lookup(action.value, "status_code", null)
        content_type = action.value["content_type"]
      }
    }
  }

  # Http header condition
  dynamic "condition" {
    for_each = [
      for condition_rule in var.listener_rules[count.index].condition :
      condition_rule
      if length(lookup(condition_rule, "http_header", [])) > 0
    ]

    content {
      dynamic "http_header" {
        for_each = condition.value["http_header"]

        content {
          http_header_name = http_header.value["http_header_name"]
          values           = http_header.value["values"]
        }
      }
    }
  }

  # Path Pattern condition
  dynamic "condition" {
    for_each = [
      for condition_rule in var.listener_rules[count.index].condition :
      condition_rule
      if length(lookup(condition_rule, "path_patterns", [])) > 0
    ]

    content {
      path_pattern {
        values = condition.value["path_patterns"]
      }
    }
  }

  # Host header condition
  dynamic "condition" {
    for_each = [
      for condition_rule in var.listener_rules[count.index].condition :
      condition_rule
      if length(lookup(condition_rule, "host_headers", [])) > 0
    ]

    content {
      host_header {
        values = condition.value["host_headers"]
      }
    }
  }

  # Http request method condition
  dynamic "condition" {
    for_each = [
      for condition_rule in var.listener_rules[count.index].condition :
      condition_rule
      if length(lookup(condition_rule, "http_request_methods", [])) > 0
    ]

    content {
      http_request_method {
        values = condition.value["http_request_methods"]
      }
    }
  }

  # Query string condition
  dynamic "condition" {
    for_each = [
      for condition_rule in var.listener_rules[count.index].condition :
      condition_rule
      if length(lookup(condition_rule, "query_strings", [])) > 0
    ]

    content {
      dynamic "query_string" {
        for_each = condition.value["query_strings"]

        content {
          key   = lookup(query_string.value, "key", null)
          value = query_string.value["value"]
        }
      }
    }
  }

  # Source IP address condition
  dynamic "condition" {
    for_each = [
      for condition_rule in var.listener_rules[count.index].condition :
      condition_rule
      if length(lookup(condition_rule, "source_ips", [])) > 0
    ]

    content {
      source_ip {
        values = condition.value["source_ips"]
      }
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# LISTENERS RULES CERTIFICATES
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lb_listener_certificate" "this" {
  count           = var.create_lb ? length(var.listener_rules_certificate) : 0
  listener_arn    = try(var.listener_rules_certificate[count.index].listener_arn, null)
  certificate_arn = try(var.listener_rules_certificate[count.index].certificate_arn, null)
}