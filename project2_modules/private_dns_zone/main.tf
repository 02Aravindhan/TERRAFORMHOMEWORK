resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.dns_names
  resource_group_name = var.resource_group_name
}