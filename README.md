# terraform-aviatrix-mc-private-mode

### Description
Deploys Aviatrix private mode communications between gateways, controller and CoPilot

### Diagram
\<Provide a diagram of the high level constructs thet will be created by this module>
<img src="<IMG URL>"  height="250">

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.0 | >= 1.0 | >= 6.8 | ~> 2.23.0

### Usage Example
```
module "private_mode" {
  source  = "terraform-aviatrix-modules/mc-private-mode/aviatrix"
  version = "1.0.0"

}
```

### Variables
The following variables are required:

key | value
:--- | :---
\<keyname> | \<description of value that should be provided in this variable>

The following variables are optional:

key | default | value 
:---|:---|:---
\<keyname> | \<default value> | \<description of value that should be provided in this variable>

### Outputs
This module will return the following outputs:

key | description
:---|:---
\<keyname> | \<description of object that will be returned in this output>
