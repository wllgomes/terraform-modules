# ---------------------------------------------------------------------------------------------------------------------
# IAM POLICIES
# ---------------------------------------------------------------------------------------------------------------------

# Network flow
data "aws_iam_policy_document" "vpc_flow_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "network_flow" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.network_flow.name}:*"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# SERVICES ROLES
# ---------------------------------------------------------------------------------------------------------------------


resource "aws_iam_role" "network_flow" {
  count = length(var.vpc_flow_traffic_types) > 0 ? 1 : 0

  name               = "${var.enterprise_context.vertical_initials}-iam-role-${lower(local.common_tags.Ambiente)}-default-network-flow"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_assume_role.json

  tags = local.common_tags
}

resource "aws_iam_role_policy" "network_flow" {
  count = length(var.vpc_flow_traffic_types) > 0 ? 1 : 0

  name   = "network_flow"
  role   = aws_iam_role.network_flow[0].id
  policy = data.aws_iam_policy_document.network_flow.json
}
