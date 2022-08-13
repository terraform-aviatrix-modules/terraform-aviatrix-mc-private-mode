#Map of all LB's lookup per region/cloud
output "private_mode_vpcs" {
  value = merge(local.controller_vpc, local.secondary_aws_vpcs, local.azure_vnet)
}
