# Volume EBS without encryption
resource "aws_ebs_volume" "this" {
  count             = var.encrypted == false || var.encrypted == "false" ? 1 : 0
  availability_zone = var.az
  size              = var.size
  type              = var.type
  final_snapshot    = var.final_snapshot
  tags = merge(
    var.default_tags,
    {
      Name = var.name
    }
  )
}

# Volume EBS with KMS Encryption
resource "aws_ebs_volume" "this_kms" {
  count             = var.encrypted ? 1 : 0
  availability_zone = var.az
  size              = var.size
  type              = var.type
  final_snapshot    = var.final_snapshot
  encrypted         = var.encrypted
  kms_key_id        = var.kms_id
  tags = merge(
    var.default_tags,
    {
      Name = var.name
    }
  )
}

# EBS Volume Attachment without encryption
resource "aws_volume_attachment" "this" {
  count             = var.encrypted == false || var.encrypted == "false" ? 1 : 0
  device_name = var.device_name
  volume_id   = aws_ebs_volume.this[count.index].id
  instance_id = var.instance_id
  force_detach = var.force_detach
}

# EBS Volume Attachment with KMS Encryption
resource "aws_volume_attachment" "this_kms" {
  count       = var.encrypted ? 1 : 0
  device_name = var.device_name
  volume_id   = aws_ebs_volume.this_kms[count.index].id
  instance_id = var.instance_id
  force_detach = var.force_detach
}