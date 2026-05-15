# Create a new Lightsail Instance
resource "aws_lightsail_instance" "this" {
  name              = var.name
  availability_zone = var.az
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  user_data         = var.user_data
  ip_address_type   = var.ip_type
  tags              = var.default_tags
}

# Secundary disk
resource "aws_lightsail_disk" "this" {
  count             = var.create_disk ? 1 : 0
  name              = var.disk_name
  size_in_gb        = var.disk_size
  availability_zone = var.az
}
resource "aws_lightsail_disk_attachment" "this" {
  count         = var.create_disk ? 1 : 0
  disk_name     = aws_lightsail_disk.this[count.index].name
  instance_name = aws_lightsail_instance.this.name
  disk_path     = var.disk_path
}

# Static IP
resource "aws_lightsail_static_ip" "this" {
  count = var.static_ip ? 1 : 0
  name  = "${var.static_ip_name}-${var.name}"
}
resource "aws_lightsail_static_ip_attachment" "this" {
  count          = var.static_ip ? 1 : 0
  static_ip_name = aws_lightsail_static_ip.this[count.index].id
  instance_name  = aws_lightsail_instance.this.id
}

# Application Port
resource "aws_lightsail_instance_public_ports" "this" {
  count = var.set_public_ports ? 1 : 0
  instance_name = aws_lightsail_instance.this.name
  port_info {
    cidrs = [var.cidr]
    protocol  = var.protocol
    from_port = var.from_port
    to_port   = var.to_port
  }
}