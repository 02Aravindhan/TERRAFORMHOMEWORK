output "private_endpoint" {
  value = azurerm_private_endpoint.keyvault_private_endpoint
}
output "private_endpoint_id" {
 value= azurerm_private_endpoint.keyvault_private_endpoint.id
}
output "private_ip_address" {
  value = azurerm_private_endpoint.keyvault_private_endpoint.private_service_connection[0].private_ip_address
}
