resource "aws_sqs_queue" "QualityGateInput" {
  count                     = var.input_queue_count
  name                      = "${local.vertical_initials}-s3-${local.environment}-quality-gate-input-${count.index}"
  max_message_size          = 256 * 1024
  message_retention_seconds = 4 * 60 * 60 * 24
  tags                      = local.common_tags
}

resource "aws_sqs_queue" "QualityGateOutput" {
  name                      = "${local.vertical_initials}-s3-${local.environment}-quality-gate-output"
  max_message_size          = 256 * 1024
  message_retention_seconds = 4 * 60 * 60 * 24
  tags                      = local.common_tags
}
