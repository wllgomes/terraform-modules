output "instance_arn" {
  value = aws_instance.this.arn
}
output "instance_id" {
  value = aws_instance.this.id
}
output "instance_ami" {
  value = aws_instance.this.ami
}
output "instance_type" {
  value = aws_instance.this.instance_type
}
output "instance_public_ip" {
  value = aws_instance.this.public_ip
}
output "instance_private_ip" {
  value = aws_instance.this.private_ip
}
output "instance_az" {
  value = aws_instance.this.availability_zone
}
output "network_interface_id" {
  value = aws_instance.this.primary_network_interface_id
}