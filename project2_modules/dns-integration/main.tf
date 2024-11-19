resource "azurerm_private_endpoint_dns_settings" "dns_integration" {
  private_endpoint_id = var.private_endpoint_id
  record_name         = var.record_name
  record_type         = var.record_type
  zone_name           = var.zone_name
  ttl                 = var.ttl
}