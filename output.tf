#Map of all LB's lookup per region/cloud
output "private_mode_vpcs" {
  value = merge(local.controller_vpc, local.secondary_aws_vpcs, local.azure_vnet)

  #Prevent race conditions
  depends_on = [
    aviatrix_private_mode_lb.default,
    aviatrix_private_mode_lb.controller_cloud,
    aviatrix_private_mode_lb.multi_cloud,
  ]
}

output "multi_cloud_endpoint_vpc_id" {
  value = local.multi_cloud ? aviatrix_vpc.multi_cloud_endpoint[0].vpc_id : null

  #Prevent race conditions
  depends_on = [
    aviatrix_private_mode_multicloud_endpoint.default,
  ]
}

output "multi_cloud_vpc_id" {
  value = local.multi_cloud ? aviatrix_vpc.multi_cloud[0].vpc_id : null

  #Prevent race conditions
  depends_on = [
    aviatrix_private_mode_lb.multi_cloud,
  ]
}
