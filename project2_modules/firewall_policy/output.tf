output "firewall_policy" {
  value = azurerm_firewall_policy.firewall_policy
}
output "firewall_policy_id" {
  value = azurerm_firewall_policy.firewall_policy.id
}
output "resource_group_name" {
  value = azurerm_firewall_policy.firewall_policy.resource_group_name
}
output "location" {
  value = azurerm_firewall_policy.firewall_policy.location
}