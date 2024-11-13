output "rg" {
  value = data.azurerm_resource_group.project4-rg
}
output "vnet" {
  value = data.azurerm_virtual_network.vnet
}
output "subnet" {
  value = module.subnets
}
output "nic" {
  value = module.nic
}
output "key_vault" {
  value = module.key_vault
}

