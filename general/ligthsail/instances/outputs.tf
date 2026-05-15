output "instance_name" {
  value = aws_lightsail_instance.this.name
}
output "instance_id" {
  value = aws_lightsail_instance.this.id
}
output "instance_arn" {
  value = aws_lightsail_instance.this.arn
}
output "instance_az" {
  value = aws_lightsail_instance.this.availability_zone
}
output "bundle_id" {
  value = aws_lightsail_instance.this.bundle_id
}
output "blueprint_id" {
  value = aws_lightsail_instance.this.blueprint_id
}
output "instance_public_ip_address" {
  value = aws_lightsail_instance.this.public_ip_address
}