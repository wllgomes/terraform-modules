resource "mongodbatlas_cluster" "main" {
  project_id   = var.project_id
  name         = var.project_name
  cluster_type = "REPLICASET"
  num_shards   = 1

  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = upper(var.aws_region)
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }

  lifecycle {
    ignore_changes = [
      replication_specs # TODO: tornar condicional isso
    ]
  }


  cloud_backup                 = true
  auto_scaling_compute_enabled = false
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = var.mongo_db_major_version

  # Provider Settings "block"
  provider_name               = "AWS"
  provider_instance_size_name = var.cluster_size

  depends_on = [mongodbatlas_network_container.master]
}
