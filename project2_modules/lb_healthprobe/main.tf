resource "azurerm_lb_probe" "lb_probe"{
    name                = var.name
    protocol            = var.protocol
    port                = var.port
    interval_in_seconds = var.interval_in_seconds
    number_of_probes    = var.number_of_probes
    loadbalancer_id = var.loadbalancer_id
  }
  
# {
#     name                = "myHealthProbe"
#     protocol            = "Tcp"
#     port                = 80
#     interval_in_seconds = 5
#     number_of_probes    = 2
#   # }