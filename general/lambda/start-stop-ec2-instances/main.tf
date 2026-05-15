# ---------------------------------------------------------------------------------------------------------------------
# IAM POLICIES AND ROLES
# ---------------------------------------------------------------------------------------------------------------------

# IAM Policy
resource "aws_iam_policy" "start" {
  count       = var.custom_iam_role_arn == null && var.schedule_action == "start" ? 1 : 0
  name        = var.policy_name
  path        = "/"
  description = "Custom policy to automatic start instances"
  tags = merge(
    var.tags,
    {
      Name = var.policy_name
    }
  )
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:StartInstances"
      ],
      "Resource": "*"
    },
    {
      "Sid": "kms",
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:CreateGrant",
        "kms:GenerateDataKey"
      ],
      "Resource": [
        "${var.kms_arn}"
      ]
    }
  ]
}
  POLICY
}
resource "aws_iam_policy" "stop" {
  count       = var.custom_iam_role_arn == null && var.schedule_action == "stop" ? 1 : 0
  name        = var.policy_name
  path        = "/"
  description = "Custom policy for Stop EC2 instances"
  tags = merge(
    var.tags,
    {
      Name = var.policy_name
    }
  )
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:StopInstances"
      ],
      "Resource": "*"
    }
  ]
}
  POLICY
}

# IAM Role
resource "aws_iam_role" "this" {
  count       = var.custom_iam_role_arn == null ? 1 : 0
  name        = var.role_name
  description = "IAM Service Role for Lambda Function stoped EC2 instances"
  tags = merge(
    var.tags,
    {
      Name = var.role_name
    }
  )
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole"
        ],
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "start" {
  count      = var.custom_iam_role_arn == null && var.schedule_action == "start" ? 1 : 0
  role       = aws_iam_role.this[count.index].name
  policy_arn = aws_iam_policy.start[count.index].arn
  depends_on = [aws_iam_policy.start]
}
resource "aws_iam_role_policy_attachment" "stop" {
  count      = var.custom_iam_role_arn == null && var.schedule_action == "stop" ? 1 : 0
  role       = aws_iam_role.this[count.index].name
  policy_arn = aws_iam_policy.stop[count.index].arn
  depends_on = [aws_iam_policy.stop]
}

# ---------------------------------------------------------------------------------------------------------------------
# LAMBDA FUNCTIONS
# ---------------------------------------------------------------------------------------------------------------------

# Lambda Function - Shutdown instances
data "archive_file" "python_ec2_stop" {
  count       = var.schedule_action == "stop" ? 1 : 0
  type        = "zip"
  source_dir  = "${path.module}/files/stop-ec2"
  output_path = "${path.module}/files/stop-instance.zip"
}
resource "aws_lambda_function" "function_ec2_stop" {
  count            = var.schedule_action == "stop" ? 1 : 0
  filename         = data.archive_file.python_ec2_stop[count.index].output_path
  source_code_hash = data.archive_file.python_ec2_stop[count.index].output_base64sha256
  function_name    = lower(var.name)
  description      = var.description
  role             = var.custom_iam_role_arn == null ? aws_iam_role.this[0].arn : var.custom_iam_role_arn
  runtime          = "python3.9"
  handler          = "main.lambda_handler"
  memory_size      = 128
  timeout          = 300

  tags = merge(
    var.tags,
    {
      Name = lower(var.name)
    }
  )
}
resource "aws_lambda_permission" "allow_eventbridge_ec2_stop" {
  count         = var.schedule_action == "stop" ? 1 : 0
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_instances[count.index].arn
}

# Lambda Function - Start up instances
data "archive_file" "python_ec2_start" {
  count       = var.schedule_action == "start" ? 1 : 0
  type        = "zip"
  source_dir  = "${path.module}/files/start-ec2"
  output_path = "${path.module}/files/start-instance.zip"
}
resource "aws_lambda_function" "function_ec2_start" {
  count            = var.schedule_action == "start" ? 1 : 0
  filename         = data.archive_file.python_ec2_start[count.index].output_path
  source_code_hash = data.archive_file.python_ec2_start[count.index].output_base64sha256
  function_name    = lower(var.name)
  description      = var.description
  role             = var.custom_iam_role_arn == null ? aws_iam_role.this[0].arn : var.custom_iam_role_arn
  runtime          = "python3.9"
  handler          = "main.lambda_handler"
  memory_size      = 128
  timeout          = 300
  tags = merge(
    var.tags,
    {
      Name = lower(var.name)
    }
  )
}
resource "aws_lambda_permission" "allow_eventbridge_ec2_start" {
  count         = var.schedule_action == "start" ? 1 : 0
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_instances[count.index].arn
}

# ---------------------------------------------------------------------------------------------------------------------
# EVENTBRIDGE RULES
# ---------------------------------------------------------------------------------------------------------------------

# Start instances
resource "aws_cloudwatch_event_rule" "start_instances" {
  count               = var.schedule_action == "start" ? 1 : 0
  name                = lower(var.eventbridge_name)
  description         = "Rule for Start EC2 instances"
  schedule_expression = var.schedule
  tags = merge(
    var.tags,
    {
      Name = lower(var.eventbridge_name)
    }
  )
  depends_on = [aws_lambda_function.function_ec2_start]
}
resource "aws_cloudwatch_event_target" "start_instances_event_target" {
  count     = var.schedule_action == "start" ? 1 : 0
  target_id = lower(var.eventbridge_name)
  rule      = aws_cloudwatch_event_rule.start_instances[count.index].name
  arn       = aws_lambda_function.function_ec2_start[count.index].arn
}

# Stop instances
resource "aws_cloudwatch_event_rule" "stop_instances" {
  count               = var.schedule_action == "stop" ? 1 : 0
  name                = lower(var.eventbridge_name)
  description         = "Rule for Stop EC2 instances"
  schedule_expression = var.schedule
  tags = merge(
    var.tags,
    {
      Name = lower(var.eventbridge_name)
    }
  )
  depends_on = [aws_lambda_function.function_ec2_stop]
}
resource "aws_cloudwatch_event_target" "stop_instances" {
  count     = var.schedule_action == "stop" ? 1 : 0
  target_id = lower(var.eventbridge_name)
  rule      = aws_cloudwatch_event_rule.stop_instances[count.index].name
  arn       = aws_lambda_function.function_ec2_stop[count.index].arn
}