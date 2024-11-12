output "disk_encryption-key" {
  value = azurerm_key_vault_key.key_disk
}
output "disk_encryption-key_id" {
  value = azurerm_key_vault_key.key_disk.id
}