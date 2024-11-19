output "ssl_certificate" {
  value = azurerm_key_vault_certificate.ssl_certificate
}
output "ssl_certificate_id" {
  value = azurerm_key_vault_certificate.ssl_certificate.id
}