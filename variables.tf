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

variable "multi_cloud" {
  description = "Whether to enable multi-cloud support for private mode."
  type        = bool
  default     = false
  nullable    = false
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
  type        = string
  default     = null
}

variable "secondary_regions" {
  description = "Map of secondary reagions where a loadbalancer needs to be initiated."
  type        = map(any)
  default     = {}

  validation {
    condition = alltrue([
    for k, v in var.regions : !can(regex("^cn-|^china ", lower(v.region)))])
    error_message = "Regions in China are not supported."
  }

  validation {
    condition = alltrue([
    for k, v in var.regions : contains(["aws", "azure", ], lower(v.cloud))])
    error_message = "Invalid cloud type detected. Choose AWS or Azure for each entry."
  }

  validation {
    condition = alltrue([
    for k, v in var.regions : length(v.vpc_name) <= 30])
    error_message = "Detected a vpc_name > 30 characters in one of entries. Max length is 30 characters."
  }
}

locals {
  is_china = can(regex("^cn-|^china ", lower(var.region))) && contains(["aws", "azure"], local.cloud)
  is_gov   = can(regex("^us-gov|^usgov |^usdod ", lower(var.region))) && contains(["aws", "azure"], local.cloud)

  cloud_type_map = {
    azure = 8,
    aws   = 1,
  }

  cloud_type_map_gov = {
    azure = 32,
    aws   = 256,
  }
}
