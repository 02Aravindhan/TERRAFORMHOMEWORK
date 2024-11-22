output "vmss" {
  value = azurerm_windows_virtual_machine_scale_set.vmss
}
output "vmss_name" {
  value = azurerm_windows_virtual_machine_scale_set.vmss.name
}