output "user_ass_identity" {
  value = azurerm_user_assigned_identity.user_ass_identity
}
output "user_ass_identity_id" {
  value = azurerm_user_assigned_identity.user_ass_identity.principal_id
}
