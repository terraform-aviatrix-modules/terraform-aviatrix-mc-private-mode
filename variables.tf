variable "enable_private_mode" {
  description = "Whether to enable Private Mode on an Aviatrix Controller."
  type        = bool
  default     = true
  nullable    = false
}

variable "copilot_instance_id" {
  description = " Instance ID of a copilot instance to associate with an Aviatrix Controller in Private Mode."
  type        = string
  default     = null
}

variable "proxies" {
  description = "Set of Controller proxies for Private Mode."
  type        = string
  default     = null
}

locals {
  is_china = can(regex("^cn-|^china ", lower(var.region))) && contains(["aws", "azure"], local.cloud)
  is_gov   = can(regex("^us-gov|^usgov |^usdod ", lower(var.region))) && contains(["aws", "azure"], local.cloud)

  cloud_type = local.is_china ? lookup(local.cloud_type_map_china, local.cloud, null) : (local.is_gov ? lookup(local.cloud_type_map_gov, local.cloud, null) : lookup(local.cloud_type_map, local.cloud, null))
  cloud_type_map = {
    azure = 8,
    aws   = 1,
    gcp   = 4,
    oci   = 16,
    ali   = 8192,
  }

  cloud_type_map_china = {
    azure = 2048,
    aws   = 1024,
  }

  cloud_type_map_gov = {
    azure = 32,
    aws   = 256,
  }
}
