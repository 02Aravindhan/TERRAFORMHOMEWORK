output "admin_password" {
  value = azurerm_key_vault_secret.admin_password
}
output "value" {
  value = azurerm_key_vault_secret.admin_password.value
}