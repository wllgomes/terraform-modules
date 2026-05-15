resource "aws_flow_log" "network_flow" {
  for_each = var.vpc_flow_traffic_types

  iam_role_arn    = aws_iam_role.network_flow[0].arn
  log_destination = aws_cloudwatch_log_group.network_flow.arn
  traffic_type    = each.key
  vpc_id          = module.client_vpc.vpc_id

  tags = local.common_tags
}


resource "aws_cloudwatch_log_group" "network_flow" {
  name              = "/network/${var.client_name}"
  retention_in_days = 3

  tags = local.common_tags
}

