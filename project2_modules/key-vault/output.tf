output "key_vault" {
    value = azurerm_key_vault.Key_vault
  
}
output "key_vault_id" {
  value = azurerm_key_vault.Key_vault.id
}
