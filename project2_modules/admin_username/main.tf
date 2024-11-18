resource "azurerm_key_vault_secret" "admin_username" {
  name = var.admin_username
  value = var.value
  key_vault_id = var.key_vault_id
}