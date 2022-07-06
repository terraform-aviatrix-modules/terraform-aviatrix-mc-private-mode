#Map of all LB's lookup per region/cloud
output "private_mode_details" {
  value = { for k in keys(var.secondary_regions) : k => {
    private_mode_lb_vpc_id   = aviatrix_vpc.default[k].vpc_id
    private_mode_subnet_zone = "eu-west-2a" #Need to look into gathering this value
    }
  }
}
