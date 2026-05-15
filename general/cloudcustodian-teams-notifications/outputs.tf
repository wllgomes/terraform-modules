# ---------------------------------------------------------------------------------------------------------------------
# OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "lambda_arn" {
  value = aws_lambda_function.this.arn
}
output "lambda_name" {
  value = aws_lambda_function.this.function_name
}
output "sqs_arn" {
  value = aws_sqs_queue.this.arn
}
output "iam_role_arn" {
  value = aws_iam_role.this.arn
}
output "iam_role_name" {
  value = aws_iam_role.this.name
}