<!-- BEGIN_TF_DOCS -->
### Project2: Consume Modules to Create (VNET, Subnet, Resource Group, NSG, Route Table)
* Resource Group (rg): Creates the foundation for all resources.
* Virtual Networks (vnets): Creates network spaces for subnets.
* Subnets (subnets): Defines smaller network spaces within the VNETs.
* Network Security Groups (nsg\_name): Creates security rules for controlling network traffic.
* NSG Rules (nsg\_rules): Defines specific inbound and outbound traffic rules for NSGs.
* NSG to Subnet Association (nsg-t0-subnets-asso): Applies the security rules (NSG) to subnets.
* Route Tables (route\_table): Defines network routing the route table module to created.
* Route Table to Subnet Association (route-to-subnet-associate): Associates the routing logic with subnets.
* Each module has its own scope and configuration, and together they define a complete network infrastructure in Azure.

```hcl
terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

module "rg" {
  source = "../project2_modules/resource_group"
  rg_name = var.resource_group
  location = var.location
}
module "vnets" {
  source = "../project2_modules/vnets" 

  for_each = var.vnets
  address_space = [each.value.address_space  ]
  vnet_name = each.key
  rg_name = module.rg.rg
  location = module.rg.location
  
  depends_on = [ module.rg ]
}

module "subnets" {
  source = "../project2_modules/subnet"
  for_each = var.subnets
  subnets_name = each.value.subnets_name
  address_prefixes = each.value.address_prefixes
  vnet_name = module.vnets["modules_vnets"].name
  rg_name = module.rg.rg

  depends_on = [ module.vnets ]
  
}
module "nsg_name" {
  source = "../project2_modules/nsg"
  for_each = var.nsg_name
  nsg_name = each.value.name
  rg_name =module.rg.rg 
  location = module.rg.location
  
}
module "nsg_rules" {
  source = "../project2_modules/nsg_rule"
  for_each = var.nsg_rules
  nsg_name = each.value.nsg_name
  rg_name = module.rg.rg
  location = module.rg.location
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source_address_prefix
  source_port_range           = each.value.source_port_range
  destination_address_prefix  = each.value.destination_address_prefix
  destination_port_range     = each.value.destination_port_ranges
    
    depends_on = [ module.rg,module.nsg_name ]
  }
module "nsg-t0-subnets-asso" {
  source = "../project2_modules/nsg-associate"
  for_each = var.nsg-to-subnets-associate
  subnet_id =  module.subnets[each.value.subnets_name].subnet_id
  network_security_group_id = module.nsg_name[each.value.nsg_name].network_security_group_id

  
}


  module "route_table" {
    source = "../project2_modules/route _table"
    for_each = var.route_table
    route_table = each.key
    rg_name = module.rg.rg
    location = module.rg.location
    
  }
  
  module "route-to-subnet-associate" {
    source = "../project2_modules/routetable-associate"
    for_each = var.route-to-subnets-associate
    subnet_id =  module.subnets[each.value.subnets_name].subnet_id
    route_table_id = module.route_table[each.key].route_table.id
    
  }
  




```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0.2)

## Providers

No providers.

## Resources

No resources.

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: n/a

Type: `string`

### <a name="input_nsg-to-subnets-associate"></a> [nsg-to-subnets-associate](#input\_nsg-to-subnets-associate)

Description: n/a

Type:

```hcl
map(object({
    subnets_name=string
    nsg_name=string
    
  }))
```

### <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name)

Description: n/a

Type:

```hcl
map(object({
    name = string
  }))
```

### <a name="input_nsg_rules"></a> [nsg\_rules](#input\_nsg\_rules)

Description: n/a

Type:

```hcl
map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_address_prefix      = string
    source_port_range          = string
    destination_address_prefix = string
    destination_port_ranges     = list(string)
    nsg_name    =string

  }))
```

### <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)

Description: n/a

Type: `string`

### <a name="input_route-to-subnets-associate"></a> [route-to-subnets-associate](#input\_route-to-subnets-associate)

Description: n/a

Type:

```hcl
map(object({
    subnets_name=string
    

  }))
```

### <a name="input_route_table"></a> [route\_table](#input\_route\_table)

Description: n/a

Type:

```hcl
map(object({
    name=string
  }))
```

### <a name="input_subnets"></a> [subnets](#input\_subnets)

Description: n/a

Type:

```hcl
map(object({
      subnets_name =string
      address_prefixes=string
    }))
```

### <a name="input_vnets"></a> [vnets](#input\_vnets)

Description: n/a

Type:

```hcl
map(object({
    vnet_name = string
    address_space = string
  }))
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_nsg-subnets-asso"></a> [nsg-subnets-asso](#output\_nsg-subnets-asso)

Description: n/a

### <a name="output_nsg_name"></a> [nsg\_name](#output\_nsg\_name)

Description: n/a

### <a name="output_nsg_rules"></a> [nsg\_rules](#output\_nsg\_rules)

Description: n/a

### <a name="output_rg"></a> [rg](#output\_rg)

Description: n/a

### <a name="output_route_table"></a> [route\_table](#output\_route\_table)

Description: n/a

### <a name="output_routetable-subnets-asso"></a> [routetable-subnets-asso](#output\_routetable-subnets-asso)

Description: n/a

### <a name="output_subnets_name"></a> [subnets\_name](#output\_subnets\_name)

Description: n/a

### <a name="output_vnets"></a> [vnets](#output\_vnets)

Description: n/a

## Modules

The following Modules are called:

### <a name="module_nsg-t0-subnets-asso"></a> [nsg-t0-subnets-asso](#module\_nsg-t0-subnets-asso)

Source: ../project2_modules/nsg-associate

Version:

### <a name="module_nsg_name"></a> [nsg\_name](#module\_nsg\_name)

Source: ../project2_modules/nsg

Version:

### <a name="module_nsg_rules"></a> [nsg\_rules](#module\_nsg\_rules)

Source: ../project2_modules/nsg_rule

Version:

### <a name="module_rg"></a> [rg](#module\_rg)

Source: ../project2_modules/resource_group

Version:

### <a name="module_route-to-subnet-associate"></a> [route-to-subnet-associate](#module\_route-to-subnet-associate)

Source: ../project2_modules/routetable-associate

Version:

### <a name="module_route_table"></a> [route\_table](#module\_route\_table)

Source: ../project2_modules/route _table

Version:

### <a name="module_subnets"></a> [subnets](#module\_subnets)

Source: ../project2_modules/subnet

Version:

### <a name="module_vnets"></a> [vnets](#module\_vnets)

Source: ../project2_modules/vnets

Version:

This is the project2 Configuration Terraform Files.
<!-- END_TF_DOCS -->