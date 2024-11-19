output "private_endpoint_name" {
  value = azurerm_private_endpoint.keyvault_private_endpoint
}
output "private_ip_address" {
 value=  azurerm_private_endpoint.keyvault_private_endpoint.private_ip_address
}