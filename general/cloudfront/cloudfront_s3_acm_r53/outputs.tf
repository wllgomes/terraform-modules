# ---------------------------------------------------------------------------------------------------------------------
# CLOUDFRONT
# ---------------------------------------------------------------------------------------------------------------------
output "cloudfront_id" {
  value = aws_cloudfront_distribution.this.id
}
output "cloudfront_arn" {
  value = aws_cloudfront_distribution.this.arn
}
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

# ---------------------------------------------------------------------------------------------------------------------
# ACM
# ---------------------------------------------------------------------------------------------------------------------
output "acm_arn" {
  value = aws_acm_certificate.this.arn
}
output "acm_id" {
  value = aws_acm_certificate.this.id
}
output "acm_domain_name" {
  value = aws_acm_certificate.this.domain_name
}

# ---------------------------------------------------------------------------------------------------------------------
# S3
# ---------------------------------------------------------------------------------------------------------------------
output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}
output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
output "bucket_id" {
  value = aws_s3_bucket.this.id
}
output "bucket_domain_name" {
  value = aws_s3_bucket.this.bucket_domain_name
}
output "bucket_regional_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}