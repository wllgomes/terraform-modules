output "cloudwatch_metric_arn" {
  value = aws_cloudwatch_metric_alarm.this.arn
}
output "cloudwatch_metric_namespace" {
  value = aws_cloudwatch_metric_alarm.this.namespace
}
output "cloudwatch_metric_metric_name" {
  value = aws_cloudwatch_metric_alarm.this.metric_name
}
output "cloudwatch_metric_dimensions" {
  value = aws_cloudwatch_metric_alarm.this.dimensions
}
output "cloudwatch_metric_alarm_name" {
  value = aws_cloudwatch_metric_alarm.this.alarm_name
}
output "cloudwatch_metric_threshold" {
  value = aws_cloudwatch_metric_alarm.this.threshold
}
output "cloudwatch_metric_id" {
  value = aws_cloudwatch_metric_alarm.this.id
}
output "aws_sns_topic_id" {
  value = aws_sns_topic.this.id
}
output "aws_sns_topic_arn" {
  value = aws_sns_topic.this.arn
}
output "aws_sns_topic_name" {
  value = aws_sns_topic.this.name
}
output "aws_sns_subscription_arn" {
  value = aws_sns_topic_subscription.this.arn
}
output "aws_sns_subscription_endpoint" {
  value = aws_sns_topic_subscription.this.endpoint
}