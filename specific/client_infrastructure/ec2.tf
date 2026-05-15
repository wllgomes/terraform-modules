# ---------------------------------------------------------------------------------------------------------------------
# EC2 common resources
# ---------------------------------------------------------------------------------------------------------------------

# NAT Instance
module "EC2NATInstance" {
  count              = var.use_nat_instance ? 1 : 0
  source             = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/ec2/instance"
  ec2_name           = "${var.enterprise_context.vertical_initials}-ec2-${var.enterprise_context.environment}-${var.client_name}-nat-instance"
  ec2_description    = "EC2 instance for NAT Instance"
  ami                = var.enterprise_context.environment == "prd" ? "ami-02457590d33d576c3" : "ami-058a8a5ab36292159" # Amazon Linux 3
  instance_type      = "t3.micro"
  api_termination    = false
  public_ip          = true
  security_group_ids = [module.SGEC2ForNATInstance[count.index].security_group_id]
  subnet_id          = module.client_vpc.frontends_subnets[0]
  volume_size        = "10"
  encrypted          = true
  kms_key_id         = data.aws_kms_key.ebs.arn
  iam_profile        = "${upper(var.enterprise_context.vertical_initials)}ServiceRoleForEC2InstancesSSM"
  source_dest        = false
  user_data          = file("${path.module}/files/ec2-nat-instance.sh")
  default_tags = merge(
    local.common_tags,
    {
      AutoOff = var.enterprise_context.environment == "prd" ? "False" : var.auto_off
      AutoOn  = var.enterprise_context.environment == "prd" ? "False" : var.auto_on
      Name    = "${var.enterprise_context.vertical_initials}-ec2-${var.enterprise_context.environment}-${var.client_name}-nat-instance"
      custodian_bypass = "true"
    }
  )
  ebs_tags = {
    Snapshot = "yes"
  }
}
