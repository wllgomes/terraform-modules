# EC2 instance
locals {
  default_metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  metadata_options = merge(local.default_metadata_options, var.metadata_options)
}

resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.public_ip
  disable_api_termination     = var.api_termination
  disable_api_stop            = var.api_stop
  source_dest_check           = var.source_dest
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_profile

  metadata_options {
    http_endpoint               = local.metadata_options.http_endpoint
    http_tokens                 = local.metadata_options.http_tokens
    http_put_response_hop_limit = local.metadata_options.http_put_response_hop_limit
    instance_metadata_tags      = local.metadata_options.instance_metadata_tags
  }

  tags = merge(
    var.default_tags,
    {
      Name        = var.ec2_name
      Description = var.ec2_description
    }
  )
  # Important: Modifying any of the root_block_device settings other than volume_size or
  # tags requires resource replacement.
  # Doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#ebs-ephemeral-and-root-block-devices

  root_block_device {
    delete_on_termination = var.delete_on_termination
    encrypted             = var.encrypted
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    kms_key_id            = var.encrypted ? var.kms_key_id : null
    tags = merge(
      var.default_tags,
      var.ebs_tags,
      {
        Name = "${var.ec2_name}-root"
      }
    )
  }

}
