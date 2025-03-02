output "compute_cluster_instance_ids" {
  value       = module.compute_cluster_instances.instance_ids
  description = "Compute cluster instance ids."
}

output "compute_cluster_instance_private_ips" {
  value       = module.compute_cluster_instances.instance_private_ips
  description = "Private IP address of compute cluster instances."
}

output "storage_cluster_instance_ids" {
  value       = module.storage_cluster_instances.instance_ids
  description = "Storage cluster instance ids."
}

output "storage_cluster_instance_private_ips" {
  value       = module.storage_cluster_instances.instance_private_ips
  description = "Private IP address of storage cluster instances."
}

output "storage_cluster_with_data_volume_mapping" {
  value       = module.storage_cluster_instances.instance_ips_with_data_mapping
  description = "Mapping of storage cluster instance ip vs. device path."
}

output "bastion_user" {
  value       = var.bastion_user
  description = "Bastion OS Login username."
}

/*
output "storage_cluster_desc_instance_ids" {
  value       = module.storage_cluster_tie_breaker_instance.instance_ids
  description = "Storage cluster desc instance id."
}

output "storage_cluster_desc_instance_private_ips" {
  value       = module.storage_cluster_tie_breaker_instance.instance_private_ips
  description = "Private IP address of storage cluster desc instance."
}

output "storage_cluster_desc_data_volume_mapping" {
  value       = module.storage_cluster_tie_breaker_instance.instance_ips_with_ebs_mapping
  description = "Mapping of storage cluster desc instance ip vs. device path."
}*/
