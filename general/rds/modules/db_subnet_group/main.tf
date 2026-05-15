resource "aws_db_subnet_group" "this" {
  count = var.create ? 1 : 0

  name        = lower(var.name)
  subnet_ids  = var.subnets_ids
  description = var.description
  tags = merge(
    var.tags,
    {
      Name = lower(var.name)
    }
  )
}