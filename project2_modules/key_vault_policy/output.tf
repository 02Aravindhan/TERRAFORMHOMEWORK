output "key_vault_policy" {
  value = azurerm_key_vault_access_policy.key_vault_policy
}
output "key_vault_access_policy_id" {
  value = azurerm_key_vault_access_policy.key_vault_policy.id
}