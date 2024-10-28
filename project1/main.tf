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
