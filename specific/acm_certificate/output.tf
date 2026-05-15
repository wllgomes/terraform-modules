output "acm_validation_record_name" {
  value = one(aws_acm_certificate.this.domain_validation_options).resource_record_name
}
output "acm_validation_record_value" {
  value = one(aws_acm_certificate.this.domain_validation_options).resource_record_value
}
output "acm_arn" {
  value = aws_acm_certificate.this.arn
}
