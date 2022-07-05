# terraform-aviatrix-mc-private-mode

### Description
Deploys Aviatrix private mode communications between gateways, controller and CoPilot

### Diagram
\<Provide a diagram of the high level constructs thet will be created by this module>
<img src="<IMG URL>"  height="250">

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.0 | >= 1.1.0 | >= 6.8 | ~> 2.23.0

### Usage Example
```
module "private_mode" {
  source  = "terraform-aviatrix-modules/mc-private-mode/aviatrix"
  version = "1.0.0"

}
```

### Variables
The following variables are required:

Key | Supported_CSP's | Description
:-- | --: | :--
controller_vpc_id | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/azure.png?raw=true" title="Azure"> | Controller VPC ID. (Not required when private mode is disabled)

The following variables are optional:

<img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/aws.png?raw=true" title="AWS"> = AWS, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/azure.png?raw=true" title="Azure"> = Azure, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/gcp.png?raw=true" title="GCP"> = GCP, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/oci.png?raw=true" title="OCI"> = OCI, <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/alibaba.png?raw=true" title="Alibaba"> = Alibaba

Key | Supported_CSP's | Default value | Description
:-- | --: | :-- | :--
enable_private_mode | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/azure.png?raw=true" title="Azure"> | true | Whether to enable Private Mode on an Aviatrix Controller.
copilot_instance_id | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/azure.png?raw=true" title="Azure"> | true | Instance ID of a copilot instance to associate with an Aviatrix Controller in Private Mode.
proxies | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/azure.png?raw=true" title="Azure"> | | Set of Controller proxies for Private Mode.

regions | <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/aws.png?raw=true" title="AWS"> <img src="https://github.com/terraform-aviatrix-modules/terraform-aviatrix-mc-private-mode/blob/master/img/azure.png?raw=true" title="Azure"> | | A map of regions where to deploy secondary loadbalancers.
### Outputs
This module will return the following outputs:

key | description
:---|:---
\<keyname> | \<description of object that will be returned in this output>
