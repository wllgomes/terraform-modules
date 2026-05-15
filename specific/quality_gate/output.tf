output "role_arn" {
  value = aws_iam_role.quality_gate_role.arn
}

output "sqs_input_queue_arns" {
  value = [for q in aws_sqs_queue.QualityGateInput : q.arn]
}

output "sqs_output_queue_arn" {
  value = aws_sqs_queue.QualityGateOutput.arn
}

output "s3_communications_bucket_arn" {
  description = "ARN of the communications bucket"
  value       = module.S3TerraformQualityGateCommunications.bucket_arn
}

output "s3_records_bucket_arn" {
  description = "ARN of the records bucket"
  value       = module.S3TerraformQualityGateRecords.bucket_arn
}

output "s3_input_jsons_bucket_arn" {
  description = "ARN of the input JSONs bucket"
  value       = module.S3TerraformQualityGateInputJsons.bucket_arn
}
