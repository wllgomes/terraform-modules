# ---------------------------------------------------------------------------------------------------------------------
# SERVICES ROLES
# ---------------------------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::794305992530:root"]
    }
  }
}

resource "aws_iam_role" "prowler_read_only_role_ph_consultoria" {
  name = "IAMProwlerReadOnlyRolePHConsultoria"

  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "prowler_read_only_role_ph_consultoria_attach" {
  for_each = toset([
    "arn:aws:iam::aws:policy/SecurityAudit",
    "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
  ])

  role       = aws_iam_role.prowler_read_only_role_ph_consultoria.name
  policy_arn = each.value
}

# Cloudwatch and Cloudwatch Logs ReadOnly from Monitor
module "CloudwatchReadOnlyMonitor" {
  source        = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/cross_account_role"
  name          = "CloudwatchReadOnlyMonitor"
  description   = "IAM Role for monitor - Grafana and Prometheus"
  principal_arn = "511977930555" # ena-network
  external_id   = "0WrtlrrlkqYhkkolv47L"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
  ]
  tags = merge(
    local.common_tags,
    {
      TerraformModule = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/cross_account_role"
    }
  )
}


# Cloud Custodian
module "IAMServiceRoleCloudCustodianLambdaFunctions" {
  source              = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/service_role"
  name                = "IAMServiceRoleForCloudCustodianLambdaFunctions"
  description         = "IAM Role for Cloud Custodian Lambda Functions"
  assume_role_service = "lambda.amazonaws.com"

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    module.IAMCloudCustodianPolicy.arn
  ]
  tags = merge(
    local.common_tags,
    {
      TerraformModule = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/service_role"
      Cliente         = "enacom"
    }
  )
}

module "IAMCloudCustodianRoleForDeploy" {
  source        = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/cross_account_role"
  name          = "IAMCloudCustodianRoleForDeploy"
  description   = "IAM Role for Cloud Custodian deploy policies from AWS ENA-Security Account"
  principal_arn = "852164034344" # ENA-Security
  external_id   = "0H2hDIbYcdhaY1EdroEwhxTHaIMv4S"
  managed_policy_arns = [
    module.IAMPolicyCloudCustodianRoleForDeploy.arn,
  ]
  tags = merge(
    local.common_tags,
    {
      TerraformModule = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/cross_account_role"
    }
  )
}

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

resource "aws_iam_role" "network_flow" {
  count = length(var.vpc_flow_traffic_types) > 0 ? 1 : 0

  name               = "${var.enterprise_context.vertical_initials}-iam-role-${lower(local.common_tags.Ambiente)}-default-network-flow"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_assume_role.json

  tags = local.common_tags
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

resource "aws_iam_role_policy" "network_flow" {
  count = length(var.vpc_flow_traffic_types) > 0 ? 1 : 0

  name   = "network_flow"
  role   = aws_iam_role.network_flow[0].id
  policy = data.aws_iam_policy_document.network_flow.json
}

# Steampipe
module "IAMServiceRoleForSteampipeEC2Monitor" {
  source              = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/cross_account_role"
  name                = "IAMServiceRoleForSteampipeEC2Monitor"
  description         = "IAM Role for Steampipe from monitor EC2 instance in AWS ENA-Network Account"
  principal_arn       = "511977930555" # ENA-Network
  external_id         = "1S2B6QeLJbPhcW3wxgCe"
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  tags = merge(
    local.common_tags,
    {
      TerraformModule = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/cross_account_role"
    }
  )
}

# Terraform Azure Pipelines
module "IAMRoleForTerraformAzurePipelines" {
  source        = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/cross_account_role"
  name          = "IAMRoleForTerraformAzurePipelines"
  description   = "IAM Role for Terraform Azure Pipelines"
  principal_arn = "511977930555" # ENA-Network
  external_id   = "0shHN26NiFblryJMpDHc"
  managed_policy_arns = [
    module.IAMCustomPolicyForTerraformAzurePipeline.arn,
    module.IAMPolicyEC2AzureAgents.arn
  ]
  tags = merge(
    local.common_tags,
    {
      Cliente = "enacom"
      Name    = "IAMRoleForTerraformAzurePipelines"
      CC      = "ena-nuvem"
    }
  )
}

# EC2 SSM
module "RoleEC2SSM" {
  source              = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/service_role"
  name                = "${upper(var.enterprise_context.vertical_initials)}ServiceRoleForEC2InstancesSSM"
  description         = "IAM Service Role for EC2 Instances managed by SSM"
  assume_role_service = "ec2.amazonaws.com"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    aws_iam_policy.session_manager_logs.arn
  ]
  tags = merge(
    local.common_tags,
    {
      TerraformModule = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/iam/service_role"
    }
  )
}
