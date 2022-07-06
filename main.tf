#Enable private mode on controller
resource "aviatrix_controller_private_mode_config" "default" {
  enable_private_mode = var.enable_private_mode
  copilot_instance_id = var.copilot_instance_id
  proxies = { for k, v in var.proxies : k => {
    instance_id = v.instance_id,
    proxy_type  = "controller",
    vpc_id      = v.vpc_id,
  } }
}

#Controller VPC LB
resource "aviatrix_private_mode_lb" "default" {
  count        = var.enable_private_mode ? 1 : 0
  account_name = var.controller_account
  vpc_id       = var.controller_vpc_id
  region       = var.controller_region
  lb_type      = "controller"

  depends_on = [
    aviatrix_controller_private_mode_config.default
  ]
}

# Create a Private Mode multicloud vpc's and load balancers for any secondary regions
resource "aviatrix_vpc" "default" {
  for_each = var.enable_private_mode ? var.secondary_regions : []

  account_name = each.value.account
  cloud_type = (
    can(regex("^us-gov|^usgov |^usdod ", lower(each.value.region))) ?
    lookup(local.cloud_type_map_gov, lower(each.value.cloud), null)
    :
    lookup(local.cloud_type_map, lower(each.value.cloud), null)
  )

  region               = each.value.region
  name                 = each.value.vpc_name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
  private_mode_subnets = true
  num_of_subnet_pairs  = 1

  depends_on = [
    aviatrix_controller_private_mode_config.default
  ]
}

resource "aviatrix_private_mode_lb" "secondary" {
  for_each = var.enable_private_mode ? var.secondary_regions : []

  account_name             = each.value.account
  vpc_id                   = aviatrix_vpc.default[each.key].vpc_id
  region                   = each.value.region
  lb_type                  = "multicloud"
  multicloud_access_vpc_id = lower(each.value.cloud) == "aws" ? var.controller_vpc_id : aviatrix_vpc.multi_cloud_endpoint[0].vpc_id

  dynamic "proxies" {
    for_each = each.value.proxies
    content {
      instance_id = proxies.value.instance_id
      proxy_type  = proxies.value.vpc_id == var.controller_vpc_id ? "controller" : "multicloud"
      vpc_id      = proxies.value.vpc_id
    }
  }

  depends_on = [
    aviatrix_controller_private_mode_config.default
  ]
}

#Multicloud endpoint creation
resource "aviatrix_vpc" "multi_cloud_endpoint" {
  count = var.multi_cloud ? 1 : 0

  account_name = var.controller_account
  cloud_type = (
    can(regex("^us-gov|^usgov |^usdod ", lower(var.controller_region))) ?
    lookup(local.cloud_type_map_gov, lower("AWS"), null)
    :
    lookup(local.cloud_type_map, lower("AWS"), null)
  )

  region               = var.controller_region
  name                 = each.value.vpc_name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
  private_mode_subnets = true
  num_of_subnet_pairs  = 1

  depends_on = [
    aviatrix_controller_private_mode_config.default
  ]
}

resource "aviatrix_private_mode_multicloud_endpoint" "default" {
  count = var.multi_cloud ? 1 : 0

  account_name         = var.controller_account
  vpc_id               = aviatrix_vpc.multi_cloud_endpoint[0].vpc_id
  region               = var.controller_region
  controller_lb_vpc_id = var.controller_vpc_id

  depends_on = [
    aviatrix_controller_private_mode_config.default
  ]
}
