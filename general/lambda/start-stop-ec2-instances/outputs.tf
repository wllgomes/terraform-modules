output "lambda_arn" {
  value = try(aws_lambda_function.function_ec2_start[0].arn, aws_lambda_function.function_ec2_stop[0].arn, "")
}
output "function_id" {
  value = try(aws_lambda_function.function_ec2_start[0].id, aws_lambda_function.function_ec2_stop[0].id, "")
}
output "function_name" {
  value = try(aws_lambda_function.function_ec2_start[0].function_name, aws_lambda_function.function_ec2_stop[0].function_name, "")
}
output "eventbridge_arn" {
  value = try(aws_cloudwatch_event_rule.start_instances[0].arn, aws_cloudwatch_event_rule.stop_instances[0].arn, "")
}
output "eventbridge_id" {
  value = try(aws_cloudwatch_event_rule.start_instances[0].id, aws_cloudwatch_event_rule.stop_instances[0].id, "")
}
output "eventbridge_name" {
  value = try(aws_cloudwatch_event_rule.start_instances[0].name, aws_cloudwatch_event_rule.stop_instances[0].name, "")
}