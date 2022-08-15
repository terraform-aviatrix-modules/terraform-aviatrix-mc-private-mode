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

  proxies = [
    "id-89717328",
    "id-89714234",
  ]

  secondary_aws_regions = {
    "eu-west-1" = {
        account  = "AWS",                       #This field is optional. When left empty, it will fall back to controller account.
        vpc_name = "private-mode-eu-west-1",    #This field is optional. When left empty, it will automatically generate a name based on the region.
        cidr     = "10.255.0.0/28",
    }
    "eu-west-2" = {
        cidr     = "10.255.0.16/28",
    } 
  }

  multi_cloud_region = {
    region           = "West Europe",
    vpc_name         = "mc-pm",
    cidr             = "10.255.255.0/24",
    account          = "Azure",
    endpoint_region  = "eu-west-2",       
    endpoint_cidr    = "10.255.254.0/24",
    endpoint_name    = "aws-endpoint",        #This field is optional. When left empty, it will automatically generate a name based on the region.
    endpoint_account = "AWS",                 #This field is optional. When left empty, it will fall back to controller account.
    proxies          = {},
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
proxies | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/azure.png?raw=true" title="Azure"> | | Set of Controller proxies for Private Mode.
secondary_aws_regions | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> | | A map of regions where to deploy secondary AWS loadbalancers. Region must be the key!
multi_cloud_region | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/main/img/aws.png?raw=true" title="AWS"> | | Details of multi-cloud region (non-AWS) where the loadbalancer needs to be initiated.

### Outputs
This module will return the following outputs:

key | description
:---|:---
private_mode_vpcs | A map of vpcs for all regions where private mode is deployed,to feed into the spoke and transit gateway configuration.
multi_cloud_endpoint_vpc_id | The VPC ID of the VPC where the multi-cloud endpoint is deployed (AWS)
multi_cloud_vpc_id | The VPC ID of the VPC where the multi-cloud loadbalancer is deployed (Azure)