# Records without alias
resource "aws_route53_record" "this" {
  count           = (var.alias == null) ? 1 : 0
  name            = var.name
  type            = var.type
  ttl             = var.default_ttl
  records         = var.records
  zone_id         = var.zone_id
  allow_overwrite = var.allow_overwrite
}

# Records with alias
resource "aws_route53_record" "this_alias" {
  count           = (var.alias != null) ? 1 : 0
  name            = var.name
  type            = var.type
  zone_id         = var.zone_id
  allow_overwrite = var.allow_overwrite

  alias {
    evaluate_target_health = var.evaluate_target_health
    name                   = var.alias
    zone_id                = var.alias_zone_id
  }
}