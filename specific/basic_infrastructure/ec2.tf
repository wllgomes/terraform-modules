# ---------------------------------------------------------------------------------------------------------------------
# EC2 common resources
# ---------------------------------------------------------------------------------------------------------------------
# SSH Key
data "local_file" "ec2_keypair" {
  count    = var.public_key_path != "" ? 1 : 0
  filename = var.public_key_path
}

resource "aws_key_pair" "ec2_keypair" {
  count      = var.public_key_path != "" ? 1 : 0
  key_name   = "${var.enterprise_context.vertical_initials}-ec2-keypair-${lower(local.common_tags.Ambiente)}"
  public_key = data.local_file.ec2_keypair[count.index].content
  tags = merge(
    local.common_tags,
    {
      Name = "${var.enterprise_context.vertical_initials}-ec2-keypair-${lower(local.common_tags.Ambiente)}"
    }
  )
}

# NAT Instance
module "EC2NATInstance" {
  count              = var.use_nat_instance ? 1 : 0
  source             = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/ec2/instance"
  ec2_name           = "${var.enterprise_context.vertical_initials}-ec2-${var.enterprise_context.environment}-nat-instance"
  ec2_description    = "EC2 instance for NAT Instance"
  ami                = var.enterprise_context.environment == "prd" ? "ami-02457590d33d576c3" : "ami-058a8a5ab36292159" # Amazon Linux 3
  instance_type      = "t3.micro"
  api_termination    = false
  public_ip          = true
  security_group_ids = [module.SGEC2ForNATInstance[count.index].security_group_id]
  subnet_id          = module.DefaultVPC.frontends_subnets[0]
  volume_size        = var.ebs_size
  encrypted          = true
  kms_key_id         = module.KMSEBSVolumes.kms_arn
  iam_profile        = module.RoleEC2SSM.role_name
  source_dest        = false
  user_data          = file("${path.module}/files/ec2-nat-instance.sh")
  default_tags = merge(
    local.common_tags,
    {
      AutoOff = var.enterprise_context.environment == "prd" ? "False" : "True"
      AutoOn  = var.enterprise_context.environment == "prd" ? "False" : "True"
      Name    = "${var.enterprise_context.vertical_initials}-ec2-${var.enterprise_context.environment}-nat-instance"
      custodian_bypass = "true"
    }
  )
  ebs_tags = {
    Snapshot = "yes"
  }
}
