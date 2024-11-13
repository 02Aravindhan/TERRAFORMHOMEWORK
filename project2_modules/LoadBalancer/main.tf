resource "azurerm_lb" "private_lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = var.sku
  //internal            = var.
frontend_ip_configuration {
    name                 = var.name
    subnet_id            = var.subnet_id
    private_ip_address   = var.private_ip_address
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}




# name                = "myPrivateLB"
#   location            = "East US"
#   resource_group_name = "myResourceGroup"
#   sku                 = "Basic"
#   internal            = true