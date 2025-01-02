resource "azurerm_lb" "private_lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  # tags = {
  #   environment = "production"
  # }
 frontend_ip_configuration {
    name                 = var.frontend_ip_name
    subnet_id            = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }

}

 resource "azurerm_lb_backend_address_pool" "backend_address_pool" {
   
    name = var.backpool_name
    loadbalancer_id =azurerm_lb.private_lb.id 
    depends_on = [ azurerm_lb.private_lb ]
  }

  resource "azurerm_lb_rule" "lb_rule" {
    name                             = var.lb_rule_name
    protocol                         = var.protocol
    frontend_port                    = var.frontend_port
    backend_port                     = var.backend_port
    frontend_ip_configuration_name   = var.frontend_ip_configuration_name
    idle_timeout_in_minutes          = var.idle_timeout_in_minutes
    loadbalancer_id                  = azurerm_lb.private_lb.id

    depends_on = [ azurerm_lb.private_lb,azurerm_lb_backend_address_pool.backend_address_pool ]
}
 
resource "azurerm_lb_probe" "lb_probe"{
    name                = var.HealthProbe_name
    port                = var.port
    interval_in_seconds = var.interval_in_seconds
    number_of_probes    = var.number_of_probes
    loadbalancer_id = azurerm_lb.private_lb.id

    depends_on = [ azurerm_lb.private_lb,azurerm_lb_backend_address_pool.backend_address_pool,azurerm_lb_rule.lb_rule ]
  }

  