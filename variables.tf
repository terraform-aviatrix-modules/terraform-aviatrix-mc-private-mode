variable "controller_account" {
  description = "Account in which the controller LB needs to be created."
  type        = string
  default     = ""
  nullable    = false
}

variable "controller_vpc_id" {
  description = "Controller VPC ID."
  type        = string
  default     = ""
  nullable    = false
}

variable "controller_region" {
  description = "Region in which the controller is active."
  type        = string
  default     = ""
  nullable    = false

  validation {
    condition     = !can(regex("^cn-|^china ", lower(var.controller_region)))
    error_message = "Regions in China are not supported."
  }
}

variable "enable_private_mode" {
  description = "Whether to enable Private Mode on an Aviatrix Controller."
  type        = bool
  default     = true
  nullable    = false
}

variable "copilot_instance_id" {
  description = "Instance ID of a copilot instance to associate with an Aviatrix Controller in Private Mode."
  type        = string
  default     = null
}

variable "proxies" {
  description = "Set of Controller proxies for Private Mode."
  type        = list(string)
  default     = []
}

variable "secondary_aws_regions" {
  description = "Map of secondary AWS regions where a loadbalancer needs to be initiated."
  type        = map(any)
  default     = {}

  validation {
    condition = alltrue([
    for k, v in var.secondary_aws_regions : !can(regex("^cn-|^china ", lower(v.region)))])
    error_message = "Regions in China are not supported."
  }

  validation {
    condition = alltrue([
    for k, v in var.secondary_aws_regions : length(v.vpc_name) <= 30])
    error_message = "Detected a vpc_name > 30 characters in one of entries. Max length is 30 characters."
  }
}

variable "multi_cloud_region" {
  description = "Details of multi-cloud region (non-AWS) where the loadbalancer needs to be initiated."
  #Fix type and validation
  default  = {}
  nullable = false
}

locals {
  cloud_type_map = {
    azure = 8,
    aws   = 1,
  }

  cloud_type_map_gov = {
    azure = 32,
    aws   = 256,
  }

  multi_cloud    = var.multi_cloud_region != tomap({})
  connecting_vpc = [for k, v in aviatrix_vpc.controller_cloud : v.vpc_id if v.region == var.multi_cloud_region.endpoint_region]

  controller_vpc     = { (var.controller_region) = var.controller_vpc_id }
  secondary_aws_vpcs = { for k, v in var.secondary_aws_regions : v.region => aviatrix_vpc.controller_cloud[k].vpc_id }
  azure_vnet         = local.multi_cloud ? { azure = aviatrix_vpc.multi_cloud[0].vpc_id } : {}
}
