output "backend_address_pool" {
  value = azurerm_lb_backend_address_pool.backend_address_pool
}
output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.backend_address_pool.id
}