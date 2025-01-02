resource "azurerm_virtual_network" "vnets" {

  name                = var.vnets
  address_space = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
 
}
 resource "azurerm_subnet" "subnets" {
    
    name = var.subnets_name
    address_prefixes = [var.address_prefixes]
    resource_group_name = var.resource_group_name
    virtual_network_name = var.vnet_name
}