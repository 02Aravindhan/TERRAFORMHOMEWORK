output "Managed_disk" {
  value = azurerm_managed_disk.Managed_disk
}

output "Managed_disk_id" {
  value = azurerm_managed_disk.Managed_disk.id
}