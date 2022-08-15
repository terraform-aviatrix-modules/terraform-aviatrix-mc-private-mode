#Map of all LB's lookup per region/cloud
output "private_mode_vpcs" {
  value = merge(local.controller_vpc, local.secondary_aws_vpcs, local.azure_vnet)
}

output "multi_cloud_endpoint_vpc_id" {
  value = local.multi_cloud ? aviatrix_vpc.multi_cloud_endpoint[0].vpc_id : null
}

output "multi_cloud_vpc_id" {
  value = local.multi_cloud ? aviatrix_vpc.multi_cloud[0].vpc_id : null
}
