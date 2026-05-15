# ---------------------------------------------------------------------------------------------------------------------
# LAMBDA FUNCTIONS
# ---------------------------------------------------------------------------------------------------------------------

# Start EC2 instances
module "LambdaStartEC2Instances" {
  source           = "../../general/lambda/start-stop-ec2-instances"
  name             = "${var.enterprise_context.vertical_initials}-lambda-${lower(local.common_tags.Ambiente)}-start-ec2-instances"
  eventbridge_name = "${var.enterprise_context.vertical_initials}-eventbridge-${lower(local.common_tags.Ambiente)}-start-ec2-instances"
  policy_name      = "${upper(var.enterprise_context.vertical_initials)}CustomPolicyForLambdaStartEC2Instances"
  role_name        = "${upper(var.enterprise_context.vertical_initials)}ServiceRoleForLambdaStartEC2Instances"
  schedule_action  = "start"
  description      = "Automatc start-up EC2 instances"
  schedule         = "cron(0 10 ? * MON-FRI *)" # UTC time
  kms_arn          = module.KMSEBSVolumes.kms_arn
  tags             = local.common_tags
}

# Stop EC2 instances
module "LambdaStopEC2Instances" {
  source           = "../../general/lambda/start-stop-ec2-instances"
  name             = "${var.enterprise_context.vertical_initials}-lambda-${lower(local.common_tags.Ambiente)}-stop-ec2-instances"
  eventbridge_name = "${var.enterprise_context.vertical_initials}-eventbridge-${lower(local.common_tags.Ambiente)}-stop-ec2-instances"
  policy_name      = "${upper(var.enterprise_context.vertical_initials)}CustomPolicyForLambdaStopEC2Instances"
  role_name        = "${upper(var.enterprise_context.vertical_initials)}ServiceRoleForLambdaStopEC2Instances"
  schedule_action  = "stop"
  description      = "Automatc shutdown EC2 instances"
  schedule         = "cron(0 23 ? * MON-FRI *)" # UTC time
  tags             = local.common_tags
}
