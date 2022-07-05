#Enable private mode on controller
resource "aviatrix_controller_private_mode_config" "default" {
  enable_private_mode = var.enable_private_mode
  copilot_instance_id = var.copilot_instance_id
  proxies             = var.proxies
}

#Controller VPC LB
resource "aviatrix_private_mode_lb" "default" {
  count        = var.enable_private_mode ? 1 : 0
  account_name = "devops"
  vpc_id       = var.controller_vpc_id
  region       = "us-east-1"
  lb_type      = "controller"

  depends_on = [
    aviatrix_controller_private_mode_config.default
  ]
}

# Create a Private Mode multicloud vpc's and load balancers for any secondary regions
resource "aviatrix_vpc" "default" {
  for_each = var.enable_private_mode ? var.regions : []

  account_name         = each.value.account
  cloud_type           = local.cloud_type
  region               = each.value.region
  name                 = each.value.vpc_name
  cidr                 = each.value.cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}

resource "aviatrix_private_mode_lb" "secondary" {
  for_each = var.enable_private_mode ? var.regions : []

  account_name             = each.value.account
  vpc_id                   = aviatrix_vpc.default[each.key].vpc_id
  region                   = each.value.region
  lb_type                  = "multicloud"
  multicloud_access_vpc_id = "vpc-abcdef"
  proxies {
    instance_id = "i-123456"
    proxy_type  = "multicloud"
    vpc_id      = "vpc-abcdef"
  }

  depends_on = [
    aviatrix_controller_private_mode_config.default
  ]
}

resource "aviatrix_private_mode_multicloud_endpoint" "default" {
  for_each = var.enable_private_mode ? var.regions : []

  account_name         = each.value.account
  vpc_id               = aviatrix_vpc.default[each.key].vpc_id
  region               = each.value.region
  controller_lb_vpc_id = var.controller_vpc_id
}
