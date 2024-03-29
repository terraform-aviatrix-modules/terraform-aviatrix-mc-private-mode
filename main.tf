#Enable private mode on controller
resource "aviatrix_controller_private_mode_config" "default" {
  enable_private_mode = var.enable_private_mode
  copilot_instance_id = var.copilot_instance_id
  proxies             = var.proxies
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
resource "aviatrix_vpc" "controller_cloud" {
  for_each = var.enable_private_mode ? var.secondary_aws_regions : {}

  account_name = try(each.value.account, var.controller_account)
  cloud_type = (
    can(regex("^us-gov|^usgov |^usdod ", lower(each.key))) ?
    lookup(local.cloud_type_map_gov, "aws", null)
    :
    lookup(local.cloud_type_map, "aws", null)
  )

  region               = each.key
  name                 = try(each.value.vpc_name, format("private-mode-%s", each.key))
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
  private_mode_subnets = true

  depends_on = [
    aviatrix_controller_private_mode_config.default #Private mode needs te be enabled before we can start configuring it.
  ]
}

resource "aviatrix_private_mode_lb" "controller_cloud" {
  for_each = var.enable_private_mode ? var.secondary_aws_regions : {}

  account_name = try(each.value.account, var.controller_account)
  vpc_id       = aviatrix_vpc.controller_cloud[each.key].vpc_id
  region       = each.key
  lb_type      = "controller"

  depends_on = [
    aviatrix_controller_private_mode_config.default, #Private mode needs te be enabled before we can start configuring it.
  ]
}

#Multicloud endpoint creation
resource "aviatrix_vpc" "multi_cloud_endpoint" {
  count = local.multi_cloud ? 1 : 0

  account_name = try(var.multi_cloud.endpoint_account, var.controller_account)
  cloud_type = (
    can(regex("^us-gov|^usgov |^usdod ", lower(var.multi_cloud.endpoint_region))) ?
    lookup(local.cloud_type_map_gov, lower("AWS"), null)
    :
    lookup(local.cloud_type_map, lower("AWS"), null)
  )

  region               = var.multi_cloud.endpoint_region
  name                 = try(var.multi_cloud.endpoint_name, format("pm-endpoint-%s", var.multi_cloud.endpoint_region))
  cidr                 = var.multi_cloud.endpoint_cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
  private_mode_subnets = true

  depends_on = [
    aviatrix_controller_private_mode_config.default #Private mode needs te be enabled before we can start configuring it.
  ]
}

resource "aviatrix_private_mode_multicloud_endpoint" "default" {
  count = local.multi_cloud ? 1 : 0

  account_name         = try(var.multi_cloud.endpoint_account, var.controller_account)
  vpc_id               = aviatrix_vpc.multi_cloud_endpoint[0].vpc_id
  region               = var.multi_cloud.endpoint_region
  controller_lb_vpc_id = local.connecting_vpc[0]

  depends_on = [
    aviatrix_controller_private_mode_config.default, #Private mode needs te be enabled before we can start configuring it.
    aviatrix_private_mode_lb.controller_cloud,       #A loadbalancer needs to be deployed in same region, before we can deploy
  ]

  lifecycle {
    precondition {
      condition     = length(local.connecting_vpc) == 1
      error_message = format("Make sure there is a secondary AWS region defined in region %s.", var.multi_cloud.endpoint_region)
    }
  }
}

#Multicloud resources (Azure)
resource "aviatrix_vpc" "multi_cloud" {
  count = local.multi_cloud ? 1 : 0

  account_name = var.multi_cloud.account
  cloud_type = (
    can(regex("^us-gov|^usgov |^usdod ", lower(var.multi_cloud.region))) ?
    lookup(local.cloud_type_map_gov, "azure", null)
    :
    lookup(local.cloud_type_map, "azure", null)
  )

  region               = var.multi_cloud.region
  name                 = try(var.multi_cloud.vpc_name, format("private-mode-%s", replace(lower(var.multi_cloud.region), " ", "-")))
  cidr                 = var.multi_cloud.cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
  private_mode_subnets = true

  depends_on = [
    aviatrix_controller_private_mode_config.default #Private mode needs te be enabled before we can start configuring it.
  ]
}

resource "aviatrix_private_mode_lb" "multi_cloud" {
  count = local.multi_cloud ? 1 : 0

  account_name             = var.multi_cloud.account
  vpc_id                   = aviatrix_vpc.multi_cloud[0].vpc_id
  region                   = var.multi_cloud.region
  lb_type                  = "multicloud"
  multicloud_access_vpc_id = aviatrix_vpc.multi_cloud_endpoint[0].vpc_id #lower(each.value.cloud) == "aws" ? var.controller_vpc_id : aviatrix_vpc.multi_cloud_endpoint[0].vpc_id

  dynamic "proxies" {
    for_each = var.multi_cloud.proxies
    content {
      instance_id = proxies.value
      #proxy_type  = "multicloud"
      vpc_id = aviatrix_vpc.multi_cloud[0].vpc_id
    }
  }

  depends_on = [
    aviatrix_controller_private_mode_config.default,   #Private mode needs te be enabled before we can start configuring it.
    aviatrix_private_mode_multicloud_endpoint.default, #Controller cloud endpoint needs to be built before we can deploy the multi-cloud loadbalander.
  ]
}
