<!-- BEGIN_TF_DOCS -->


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

module "name" {
  source = "../project2_modules/resource_group"
  rg_name = var.resource_group
  location = var.location
}

module "vnets" {
  source = "../project2_modules/vnets" 

  for_each = var.vnets
  address_space = [each.value.address_space  ]
  vnet_name = each.key
  rg_name = module.name.rg
  location = module.name.location
  
  depends_on = [ module.name ]
}

module "subnets" {
  source = "../project2_modules/subnet"
  for_each = var.subnets
  subnets_name = each.value.subnets_name
  address_prefixes = each.value.address_prefixes
  vnet_name = module.vnets["modules_vnets"].name
  rg_name = module.name.rg

  depends_on = [ module.vnets ]
  
}

module "nsg_name" {
  source = "../project2_modules/nsg"
  for_each = var.nsg_name
  nsg_name = each.value.name
  rg_name =module.name.rg 
  location = module.name.location
  
}
module "nsg_rules" {
  source = "../project2_modules/nsg_rule"
  for_each = var.nsg_rules
  nsg_name = module.nsg_name["module_nsg"].name
  rg_name = module.name.rg
  location = module.name.location
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source_address_prefix
  source_port_range           = each.value.source_port_range
  destination_address_prefix  = each.value.destination_address_prefix
  destination_port_range      = each.value.destination_port_range
    
    depends_on = [ module.name,module.nsg_name ]
  }

  module "route_table" {
    source = "../project2_modules/route _table"
    route_table = var.route_table
    rg_name = module.name.rg
    location = module.name.location
    
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
    destination_port_range     = string
    

  }))
```

### <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)

Description: n/a

Type: `string`

### <a name="input_route_table"></a> [route\_table](#input\_route\_table)

Description: n/a

Type: `string`

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

### <a name="output_module_rg"></a> [module\_rg](#output\_module\_rg)

Description: n/a

### <a name="output_nsg_name"></a> [nsg\_name](#output\_nsg\_name)

Description: n/a

### <a name="output_nsg_rules"></a> [nsg\_rules](#output\_nsg\_rules)

Description: n/a

### <a name="output_route_table"></a> [route\_table](#output\_route\_table)

Description: n/a

### <a name="output_subnets_name"></a> [subnets\_name](#output\_subnets\_name)

Description: n/a

### <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name)

Description: n/a

## Modules

The following Modules are called:

### <a name="module_name"></a> [name](#module\_name)

Source: ../project2_modules/resource_group

Version:

### <a name="module_nsg_name"></a> [nsg\_name](#module\_nsg\_name)

Source: ../project2_modules/nsg

Version:

### <a name="module_nsg_rules"></a> [nsg\_rules](#module\_nsg\_rules)

Source: ../project2_modules/nsg_rule

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