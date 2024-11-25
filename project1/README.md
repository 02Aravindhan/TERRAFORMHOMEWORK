<!-- BEGIN_TF_DOCS -->
![project1hw](https://github.com/user-attachments/assets/de6bdc14-669e-40a2-a11b-1fbb895d59cd)
 ### project1: Basic Azure Resources Setup (VNET, Subnet, Resource Group, NSG, Route Table)

   * First we have to create the Resource Group
   * The name of the VNet, taken from the map key.address\_space: The IP address range for the VNet  
   * The name of the subnet.address\_prefixes: The IP address range for the subnet.
   * <b>virtual\_network\_name: Associates the subnet with the specified VNet.
   * <b>Virtual Network (VNET): Create a VNET with a specific address space .
   * <b>Network Security Group (NSG): Associate an NSG with subnets.defining security rules to control inbound and outbound traffic.
   *  <b>Route Table: Create a custom route table and associate it with a subnet.

```hcl
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets
  name = each.key
  address_space = [ each.value.address_space ]
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  depends_on = [ azurerm_resource_group.rg ]
  }

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name = each.key
  address_prefixes = [ each.value.address_prefix ]
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnets["project_vnets"].name
  depends_on = [ azurerm_resource_group.rg,azurerm_virtual_network.vnets ]
  
}

resource "azurerm_route_table" "subnetweb-udr" {

  name = "subnetweb-udr"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  
  depends_on = [ azurerm_resource_group.rg ]
}

   
// subnet assocate

resource "azurerm_subnet_route_table_association" "subnetweb_association" {
    for_each = var.subnets

    subnet_id = azurerm_subnet.subnets["SubnetWeb"].id
    route_table_id = azurerm_route_table.subnetweb-udr.id
    depends_on = [azurerm_subnet.subnets,azurerm_route_table.subnetweb-udr ]
}


//Subnet App to route table

resource "azurerm_route_table" "subnetApp-udr" {

  name = "subnetAPP-udr"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [ azurerm_resource_group.rg ]
}

   
// subnet assocate

resource "azurerm_subnet_route_table_association" "subnetApp_association" {
    for_each = var.subnets

    subnet_id = azurerm_subnet.subnets["SubnetApp"].id
    route_table_id = azurerm_route_table.subnetApp-udr.id
    depends_on = [azurerm_subnet.subnets,azurerm_route_table.subnetweb-udr ]
}

resource "azurerm_network_security_group" "SubnetApp_nsg" {      // Create the NSG for Subnet
  name = "SubnetApp-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}

resource "azurerm_network_security_rule" "nsg_rule" {     // Create the NSG Rule for NSG
   
    
      name                       = "Allow_HTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 80
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      network_security_group_name = azurerm_network_security_group.SubnetApp_nsg.name
      resource_group_name = azurerm_resource_group.rg.name

    }

resource "azurerm_network_security_rule" "nsg_rule1" {     // Create the NSG Rule for NSG
   
    
      name                       = "Allow_HTTPS"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 443
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      network_security_group_name = azurerm_network_security_group.SubnetApp_nsg.name
      resource_group_name = azurerm_resource_group.rg.name

      }
# Associate the NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.subnets["SubnetApp"].id
  network_security_group_id = azurerm_network_security_group.SubnetApp_nsg.id

depends_on = [ azurerm_network_security_group.SubnetApp_nsg ]
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

- [azurerm_network_security_group.SubnetApp_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_network_security_rule.nsg_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.nsg_rule1](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_route_table.subnetApp-udr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) (resource)
- [azurerm_route_table.subnetweb-udr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) (resource)
- [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet_network_security_group_association.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) (resource)
- [azurerm_subnet_route_table_association.subnetApp_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) (resource)
- [azurerm_subnet_route_table_association.subnetweb_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) (resource)
- [azurerm_virtual_network.vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_location"></a> [location](#input\_location)

Description: n/a

Type: `string`

### <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name)

Description: n/a

Type: `string`

### <a name="input_subnets"></a> [subnets](#input\_subnets)

Description: n/a

Type:

```hcl
map(object({
      subnets_name =string
      address_prefix=string
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

### <a name="output_project_vnets"></a> [project\_vnets](#output\_project\_vnets)

Description: n/a

### <a name="output_rg"></a> [rg](#output\_rg)

Description: n/a

### <a name="output_subnets"></a> [subnets](#output\_subnets)

Description: n/a

## Modules

No modules.

This is the project1 Configuration Terraform Files.
<!-- END_TF_DOCS -->