output "rg" {
    value = azurerm_resource_group.rg 
}

output "project_vnets" {
  value = azurerm_virtual_network.vnets
}

output "subnets" {
  value = azurerm_subnet.subnets
}



  
