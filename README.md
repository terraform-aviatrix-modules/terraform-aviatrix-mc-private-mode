# terraform-aviatrix-mc-private-mode

### Description
Deploys Aviatrix private mode communications between gateways, controller and CoPilot. Only supported for a controller in AWS.
Supports gateway deployment in both Azure and AWS commercial and GOV regions. No support for China regions.

### Diagram
\<Provide a diagram of the high level constructs thet will be created by this module>
<img src="<IMG URL>"  height="250">

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.0 | >= 1.1.0 | >= 6.8 | ~> 2.23.0

### Usage Example
```hcl
module "private_mode" {
  source  = "terraform-aviatrix-modules/mc-private-mode/aviatrix"
  version = "1.0.0"

  controller_account = "AWS"
  controller_region  = "eu-central-1"
  controller_vpc_id  = "vpc-12345678"

  multi_cloud = true

  proxies = {
    proxy1 = {
      instance_id = "id-89717328",
      vpc_id      = "vpc-87654321",
    }
    proxy2 = {
      instance_id = "id-89713443",
      vpc_id      = "vpc-87654321",
    }
  }

  secondary_regions = {
    region1 = {
        cloud            = "AWS"
        account          = "AWS",
        vpc_name         = "private-mode-eu-west-1",
        region           = "eu-west-1",
        cidr             = "10.255.0.0/28",
        proxies  = {
          instance_id = "id-89717328",
          vpc_id      = "vpc-87654321",
        }
    }
    region2 = {
        cloud            = "AWS"
        account          = "AWS",
        vpc_name         = "private-mode-eu-west-2",
        region           = "eu-west-2",
        cidr             = "10.255.0.16/28",
        proxies          = {
          instance_id = "id-89717328",
          vpc_id      = "vpc-87654321",
        }        
    } 
    region3 = {
        cloud    = "Azure"
        account  = "Azure",
        vpc_name = "private-mode-west-europe",
        region   = "West Europe",
        cidr     = "10.255.0.32/28",
        proxies  = {
          instance_id = "id-89717328",
          vpc_id      = "vpc-87654321",
        }        
    }           
  }
}
```

### Variables
The following variables are required:

Key | Supported_CSP's | Description
:-- | --: | :--
controller_account | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> | Account in which the controller LB needs to be created. (Not required when private mode is disabled)
controller_region | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> | Region in which the controller is active. (Not required when private mode is disabled)
controller_vpc_id | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> | Controller VPC or VNET ID. (Not required when private mode is disabled)

The following variables are optional:

<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> = AWS, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/azure.png?raw=true" title="Azure"> = Azure, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/gcp.png?raw=true" title="GCP"> = GCP, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/oci.png?raw=true" title="OCI"> = OCI, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/alibaba.png?raw=true" title="Alibaba"> = Alibaba

Key | Supported_CSP's | Default value | Description
:-- | --: | :-- | :--
enable_private_mode | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/azure.png?raw=true" title="Azure"> | true | Whether to enable Private Mode on an Aviatrix Controller.
copilot_instance_id | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> | true | Instance ID of a copilot instance to associate with an Aviatrix Controller in Private Mode.
multi_cloud | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/azure.png?raw=true" title="Azure"> | false | Whether to enable multi-cloud support for private mode.
proxies | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/azure.png?raw=true" title="Azure"> | | Set of Controller proxies for Private Mode.
regions | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/azure.png?raw=true" title="Azure"> | | A map of regions where to deploy secondary loadbalancers.

### Outputs
This module will return the following outputs:

key | description
:---|:---
private_mode_details | A map of details per region to feed into the spoke and transit gateway configuration.
