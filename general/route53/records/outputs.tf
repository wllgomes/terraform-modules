output "fqdn" {
  value = one(aws_route53_record.this[*].fqdn)
}
output "name" {
  value = one(aws_route53_record.this[*].name)
}