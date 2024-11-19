output "admin_username" {
  value = azurerm_key_vault_secret.admin_username
}
output "value" {
  value = azurerm_key_vault_secret.admin_username.value
}