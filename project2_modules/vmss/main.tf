resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                            = var.vmss_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku                             = var.sku
  instances                       = var.instances
  upgrade_mode                    = var.upgrade_mode
  admin_username                 =var.admin_username
  admin_password                  = var.admin_password
  os_disk {
    caching = var.caching
    storage_account_type= var.storage_account_type 
  }

  network_interface {
    name                       = var.name
    primary                    = var.primary
    enable_accelerated_networking =var.enable_accelerated_networking
    ip_configuration {
       name = var.name
       subnet_id = var.subnet_id
    } 
  }

  identity {
    type = var.type
  }
}