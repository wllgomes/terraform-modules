# Cloudwatch
resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = var.alarm_name
  alarm_description   = var.alarm_description
  alarm_actions       = [aws_sns_topic.this.arn]
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = var.datapoints_to_alarm
  dimensions = {
    "Currency" : "USD"
  }
  evaluation_periods  = var.evaluation_periods
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  metric_name        = "EstimatedCharges"
  namespace          = "AWS/Billing"
  tags = merge(
    var.tags,
    {
      Name = var.alarm_name
    }
  )
}

# SNS Topic
data "aws_caller_identity" "current" {}
resource "aws_sns_topic" "this" {
  name            = var.sns_name
  delivery_policy = <<POLICY
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false
  }
}
  POLICY
  policy          = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${data.aws_caller_identity.current.account_id}"
        }
      }
    }
  ]
}
  POLICY
  tags = merge(
    var.tags,
    {
      Name = "ph-sns-billing-alarm"
    }
  )
}

# SNS Subscription
resource "aws_sns_topic_subscription" "this" {
  endpoint                        = var.email
  protocol                        = "email"
  topic_arn                       = aws_sns_topic.this.arn
  confirmation_timeout_in_minutes = "60"
}