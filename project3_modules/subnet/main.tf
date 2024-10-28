resource "azurerm_subnet" "subnets" {
    
    name = var.subnets_name
    address_prefixes = [var.address_prefixes]
    resource_group_name = var.rg_name
    virtual_network_name = var.vnet_name
    
  
  
}
  
