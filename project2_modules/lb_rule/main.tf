resource "azurerm_lb_rule" "lb_rule" {
   name                             = var.lb_rule_name
    protocol                         = var.protocol
    frontend_port                    = var.frontend_port
    backend_port                     = var.backend_port
    frontend_ip_configuration_name   = var.frontend_ip_configuration_name
    idle_timeout_in_minutes          = var.idle_timeout_in_minutes
    loadbalancer_id                  = var.loadbalancer_id
}

 
