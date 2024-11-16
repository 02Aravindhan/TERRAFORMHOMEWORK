resource "azurerm_lb" "private_lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  
frontend_ip_configuration {
    name                 = var.frontend_ip_name
    subnet_id            = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}




