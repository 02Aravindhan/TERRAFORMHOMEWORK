resource "azurerm_subnet" "subnets" {
    //for_each = var.vnet_name
    name = var.subnets_name
    address_prefixes = [var.address_prefixes]
    resource_group_name = var.rg_name
    virtual_network_name = var.vnet_name
    
  
  
}
  
