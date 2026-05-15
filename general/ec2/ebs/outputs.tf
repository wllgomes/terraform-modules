output "volume_id" {
  value = aws_ebs_volume.this[*].id
}
output "volume_arn" {
  value = aws_ebs_volume.this[*].arn
}
output "volume_type" {
  value = aws_ebs_volume.this[*].type
}
output "volume_size" {
  value = aws_ebs_volume.this[*].size
}
output "volume_kms_id" {
  value = aws_ebs_volume.this_kms[*].id
}
output "volume_kms_arn" {
  value = aws_ebs_volume.this_kms[*].arn
}
output "volume_kms_type" {
  value = aws_ebs_volume.this_kms[*].type
}
output "volume_kms_size" {
  value = aws_ebs_volume.this_kms[*].size
}