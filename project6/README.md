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
 
 data "azurerm_resource_group" "project6-rg" {
   name = "module2-rg"
  
 }

 data "azurerm_virtual_network" "vnet" {
  name = "modules_vnets"
  resource_group_name =data.azurerm_resource_group.project6-rg.name
  depends_on = [ data.azurerm_resource_group.project6-rg ]
 }
 data "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.key
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet]
}
module "firewall_subnet" {
  source = "../project2_modules/subnet"
   for_each       = var.firewall_subnet
  subnets_name    = each.key
  address_prefixes= each.value.address_prefix
  vnet_name    = data.azurerm_virtual_network.vnet.name
  rg_name = data.azurerm_resource_group.project6-rg.name

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet, data.azurerm_subnet.subnet]
}
# Firewall Public IP

module "Public_ip" {
  source            = "../project2_modules/public_ip"
  public_ip_name    = "Firewall-public-IP"
  resource_group_name       = data.azurerm_resource_group.project6-rg.name
  location          = data.azurerm_resource_group.project6-rg.location
  allocation_method = "Static"
  sku               = "Standard"

  depends_on = [data.azurerm_resource_group.project6-rg]
}
// Firewall Policy

module "firewall_policy" {
  source               = "../project2_modules/firewall_policy"
  firewall_policy_name = "firewall-policy"
  resource_name        = data.azurerm_resource_group.project6-rg.name
  location             = data.azurerm_resource_group.project6-rg.location
  sku                  = "Standard"

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet]
}


# #Firewall

module "firewall" {
  source        = "../project2_modules/firewall"
  firewall_name = "firewall"
  resource_group_name = module.firewall_policy.resource_group_name
  location      = module.firewall_policy.location
  sku_name      = "AZFW_VNet"
  sku_tier      = "Standard"

  ip_configuration_name = "firewallconfiguration"
  subnet_id             = module.firewall_subnet["AzureFirewallSubnet"].subnet_id
  public_ip_address_id  = module.Public_ip.public_ip_id

  firewall_policy_id = module.firewall_policy.firewall_policy_id

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet, data.azurerm_subnet.subnet,
  module.Public_ip,module.firewall_policy]
}

// Route Table

module "route_table" {
  source           = "../project2_modules/route _table"
  route_table      = var.route_table_name
  rg_name          = data.azurerm_resource_group.project6-rg.name
  location         = data.azurerm_resource_group.project6-rg.location
  depends_on       = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet]
}

// firewall- Route

module "firewall_route" {
  source                 = "../project2_modules/route"
  route_name             = "route-to-firewall"
  resource_group_name    = module.route_table.resource_group_name
  location               = module.route_table.location
  route_table_name       = module.route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.8.4"

  depends_on = [module.firewall, module.route_table]
}
// Associate to routetable

module "routetable-associate" {
  source         = "../project2_modules/routetable-associate"
  subnet_id      = data.azurerm_subnet.subnet["subnet11"].id
  route_table_id = module.route_table.route_table_id

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_subnet.subnet, module.route_table]
}

// nsg

module "nsg" {
  source        = "../project2_modules/nsg"
  nsg_name      = var.nsg_name
  rg_name       = data.azurerm_resource_group.project6-rg.name
  location      = data.azurerm_resource_group.project6-rg.location

  depends_on = [data.azurerm_resource_group.project6-rg, data.azurerm_virtual_network.vnet]
}
module "nsg_rule" {
  source        = "../project2_modules/nsg_rule"
  for_each      = var.security_rules
  nsg_name      = each.key
  rg_name       = data.azurerm_resource_group.project6-rg.name
  location      = data.azurerm_resource_group.project6-rg.location

  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_ranges
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix

  depends_on = [module.nsg]
}
//nsg associate subnet

module "nsg-associate-to-sub" {
  source    = "../project2_modules/nsg-associate"
  subnet_id = data.azurerm_subnet.subnet["subnet11"].id
  network_security_group_id     = module.nsg.network_security_group_id
  depends_on = [data.azurerm_subnet.subnet,module.nsg ]
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.0.2)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.0.2)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.project6-rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) (data source)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_firewall_subnet"></a> [firewall\_subnet](#input\_firewall\_subnet)

Description: n/a

Type:

```hcl
map(object({
    subnet_name = string
    address_prefix = string
  }))
```

### <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name)

Description: n/a

Type: `string`

### <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name)

Description: n/a

Type: `string`

### <a name="input_security_rules"></a> [security\_rules](#input\_security\_rules)

Description: n/a

Type:

```hcl
map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_ranges     = list(string)
    source_address_prefix      = string
    destination_address_prefix = string
    nsg_name                   = string
   }))
```

### <a name="input_subnets"></a> [subnets](#input\_subnets)

Description: n/a

Type:

```hcl
map(object({
      subnets_name =string
      address_prefix=string
    }))
```

## Optional Inputs

No optional inputs.

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_Public_ip"></a> [Public\_ip](#module\_Public\_ip)

Source: ../project2_modules/public_ip

Version:

### <a name="module_firewall"></a> [firewall](#module\_firewall)

Source: ../project2_modules/firewall

Version:

### <a name="module_firewall_policy"></a> [firewall\_policy](#module\_firewall\_policy)

Source: ../project2_modules/firewall_policy

Version:

### <a name="module_firewall_route"></a> [firewall\_route](#module\_firewall\_route)

Source: ../project2_modules/route

Version:

### <a name="module_firewall_subnet"></a> [firewall\_subnet](#module\_firewall\_subnet)

Source: ../project2_modules/subnet

Version:

### <a name="module_nsg"></a> [nsg](#module\_nsg)

Source: ../project2_modules/nsg

Version:

### <a name="module_nsg-associate-to-sub"></a> [nsg-associate-to-sub](#module\_nsg-associate-to-sub)

Source: ../project2_modules/nsg-associate

Version:

### <a name="module_nsg_rule"></a> [nsg\_rule](#module\_nsg\_rule)

Source: ../project2_modules/nsg_rule

Version:

### <a name="module_route_table"></a> [route\_table](#module\_route\_table)

Source: ../project2_modules/route _table

Version:

### <a name="module_routetable-associate"></a> [routetable-associate](#module\_routetable-associate)

Source: ../project2_modules/routetable-associate

Version:

This is the project6 Configuration Terraform Files.
<!-- END_TF_DOCS -->