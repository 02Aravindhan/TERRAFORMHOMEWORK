resource "azurerm_route_table" "route_table" {
    name = var.route_table
    resource_group_name = var.rg_name
    location = var.location
  
}