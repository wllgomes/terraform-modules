# ---------------------------------------------------------------------------------------------------------------------
# IAM
# ---------------------------------------------------------------------------------------------------------------------

# IAM For Lambda
resource "aws_iam_role" "this" {
  name        = var.iam_role_name
  description = var.iam_role_description
  tags        = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  depends_on = [aws_iam_policy.this]
}
resource "aws_iam_policy" "this" {
  name        = var.iam_policy_name
  description = var.iam_policy_description
  tags        = var.tags

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "SQSSendMessage"
        Effect = "Allow",
        Action = [
          "sqs:SendMessage"
        ],
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "this_1" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn

  depends_on = [aws_iam_role.this]
}
resource "aws_iam_role_policy_attachment" "this_2" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"

  depends_on = [aws_iam_role.this]
}


# ---------------------------------------------------------------------------------------------------------------------
# SQS
# ---------------------------------------------------------------------------------------------------------------------

# Cloud Custodian Notification
resource "aws_sqs_queue" "this" {
  name = var.sqs_name
  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# LAMBDA FUNCTIONS
# ---------------------------------------------------------------------------------------------------------------------

# Cloud Custodian Notifications
resource "aws_lambda_function" "this" {
  function_name    = var.lambda_name
  description      = var.lambda_description
  role             = aws_iam_role.this.arn
  handler          = "custodian_notification.lambda_handler"
  runtime          = var.lambda_runtime
  filename         = "${path.module}/${var.lambda_filename}"
  source_code_hash = filebase64sha256("${path.module}/${var.lambda_filename}")

  environment {
    variables = {
      TEAMS_WEBHOOK_URL = var.teams_webhook
      URL_DOC           = var.url_doc
    }
  }

  tags = var.tags

  depends_on = [
    aws_sqs_queue.this,
    aws_iam_role.this
  ]
}
resource "aws_lambda_event_source_mapping" "custodian_sqs_to_lambda" {
  event_source_arn                   = aws_sqs_queue.this.arn
  function_name                      = aws_lambda_function.this.arn
  enabled                            = true
  batch_size                         = var.sqs_batch_size
  maximum_batching_window_in_seconds = var.sqs_maximum_batching_window_in_seconds
}