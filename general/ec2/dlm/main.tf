# IAM Role for Data Lifecycle Manager
resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0
  name        = var.role_name
  description = "Role for Data Lifecycle Manager"
  tags = merge(
    var.default_tags,
    {
      Name = var.role_name
    }
  )
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Effect : "Allow",
        Sid : ""
        Principal : {
          Service : "dlm.amazonaws.com"
        },
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "this" {
  count = var.create_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = var.policy_arn
}

# Data Lifecycle Manager
resource "aws_dlm_lifecycle_policy" "this_with_new_role" {
  count = var.create_role ? 1 : 0
  description        = var.description
  execution_role_arn = aws_iam_role.this[0].arn
  state              = var.state
  tags = merge(
    var.default_tags,
    {
      Name = var.name
    }
  )

  policy_details {
    resource_types = ["VOLUME"]
    target_tags    = var.target_tags

    schedule {
      name        = var.schedule_name
      copy_tags   = var.copy_tags
      tags_to_add = var.add_tags

      create_rule {
        interval      = var.interval
        interval_unit = "HOURS"
        times         = var.times
      }

      retain_rule {
        count = var.retain
      }
    }
  }
}
resource "aws_dlm_lifecycle_policy" "this_with_existed_role" {
  count = var.create_role == false || var.create_role == "false" ? 1 : 0
  description        = var.description
  execution_role_arn = var.execution_role_arn
  state              = var.state
  tags = merge(
    var.default_tags,
    {
      Name = var.name
    }
  )

  policy_details {
    resource_types = ["VOLUME"]
    target_tags    = var.target_tags

    schedule {
      name        = var.schedule_name
      copy_tags   = var.copy_tags
      tags_to_add = var.add_tags

      create_rule {
        interval      = var.interval
        interval_unit = "HOURS"
        times         = var.times
      }

      retain_rule {
        count = var.retain
      }
    }
  }
}