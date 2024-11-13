resource "azurerm_lb_rule" "lb_rule" {
   name                             = var.name
    protocol                         = var.protocol
    frontend_port                    = var.frontend_port
    backend_port                     = var.backend_port
    frontend_ip_configuration_name   = var.frontend_ip_configuration_name
    idle_timeout_in_minutes          = var.idle_timeout_in_minutes
    loadbalancer_id                  = var.loadbalancer_id
}

    # name                             = "myHttpRule"
    # protocol                         = "Tcp"
    # frontend_port                    = 80
    # backend_port                     = 80
    # frontend_ip_configuration_name   = "myPrivateFrontend"
    # backend_address_pool_name        = "myBackendPool"
    # probe_name                       = "myHealthProbe"
    # idle_timeout_in_minutes          = 4
