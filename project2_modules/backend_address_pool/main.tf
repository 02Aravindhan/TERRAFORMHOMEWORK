resource "azurerm_lb_backend_address_pool" "backend_address_pool" {
   
    name = var.name
    loadbalancer_id = var.loadbalancer_id
  }

  
# name = "myBackendPool"