output "private_dns_record" {
  value = azurerm_private_dns_a_record.private_dns_record
}
output "private_dns_record_id" {
  value = azurerm_private_dns_a_record.private_dns_record.id
}