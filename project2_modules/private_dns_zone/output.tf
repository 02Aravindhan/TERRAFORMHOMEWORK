output "private_dns_zone" {
  value = azurerm_private_dns_zone.private_dns_zone
}
output "private_dns_zone_name" {
  value = azurerm_private_dns_zone.private_dns_zone.name
}