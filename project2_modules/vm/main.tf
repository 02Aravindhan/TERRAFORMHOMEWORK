resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = var.network_interface_ids
  os_disk {
    name                 = var.os_disk_name
    caching              = var.caching
    storage_account_type = var.storage_account_type
    disk_encryption_set_id = var.disk_encryption_set_id
  }
 
  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
 
}