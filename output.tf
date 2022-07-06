#Mockup map of all LB's lookup per region/cloud
output "private_mode_details" {
  value = {
    "eu-west-1" = {
      private_mode_lb_vpc_id   = "vpc-12345678"
      private_mode_subnet_zone = "eu-west-1a"
    }
    "eu-west-2" = {
      private_mode_lb_vpc_id   = "vpc-12345678"
      private_mode_subnet_zone = "eu-west-2a"
    }
    "West Europe" = {
      private_mode_lb_vpc_id   = "vnet1:rg-1"
      private_mode_subnet_zone = "West Europe"
    }
  }
}
