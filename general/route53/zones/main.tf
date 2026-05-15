locals {
  run_in_vpc = length(var.vpc_ids) > 0
}

# Zone
resource "aws_route53_zone" "this" {
  name    = var.name
  comment = var.comment
  tags    = var.default_tags
  dynamic "vpc" {
    for_each = { for id in var.vpc_ids : id => id }

    content {
      vpc_id = vpc.value
    }
  }
}